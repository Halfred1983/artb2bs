import 'package:artb2b/utils/common.dart';
import 'package:artb2b/widgets/audience.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../app/resources/assets.dart';
import '../app/resources/styles.dart';
import '../app/resources/theme.dart';
import '../utils/currency/currency_helper.dart';

class HostProfileWidget extends StatefulWidget {
  const HostProfileWidget({super.key, required this.user});
  final User user;

  @override
  State<HostProfileWidget> createState() => _HostProfileWidgetState();
}

class _HostProfileWidgetState extends State<HostProfileWidget> {
  int _currentIndex = 0;
  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    List<Widget> photos = [];

    if (widget.user.photos != null && widget.user.photos!.isNotEmpty) {
      photos = List.generate(
        widget.user.photos!.length,
            (index) =>
            ShaderMask(
              // blendMode: BlendMode.src,
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.black,
                    ],
                    begin: Alignment.center,
                    end: Alignment.bottomCenter
                ).createShader(bounds);
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(24)),
                child: FadeInImage(
                  width: double.infinity,
                  placeholder: const AssetImage(Assets.logo),
                  image: NetworkImage(widget.user.photos![index].url!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
      );
    } else {
      photos = [
        ShaderMask(
          // blendMode: BlendMode.src,
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.black,
                  ],
                  begin: Alignment.center,
                  end: Alignment.bottomCenter
              ).createShader(bounds);
            },
            child: const ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(24)),
                child: Image(
                  image: AssetImage(Assets.logo),
                  fit: BoxFit.cover,
                )
            )
        ),

      ];
    }

    return
      SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
              padding: horizontalPadding8 + verticalPadding8,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          height: 500,
                          width: double.infinity,
                          child: PageView.builder(
                            onPageChanged: (pageId,) {
                              setState(() {
                                _currentIndex = pageId;
                              });
                            },
                            padEnds: false,
                            controller: controller,
                            itemCount: photos.length,
                            itemBuilder: (_, index) {
                              return photos[index % photos.length];
                            },
                          ), // Select photo dynamically using index
                        ),
                        Positioned(
                          bottom: 24,
                          left: 0,
                          right: 0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AnimatedSmoothIndicator(
                                activeIndex: _currentIndex,
                                count: photos.length,
                                effect: const ExpandingDotsEffect(
                                  spacing: 5,
                                  dotHeight: 10,
                                  dotWidth: 10,
                                  dotColor: Colors.white,
                                  activeDotColor: Colors.white,
                                  // type: WormType.thin,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 48,
                          left: -10,
                          child: Padding(
                            padding: horizontalPadding32,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.user.userInfo!.name!,
                                  style: TextStyles.boldWhite29,),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width - 2 * horizontalPadding32.horizontal, // Adjust width to fit within screen bounds considering padding
                                  child: Text(
                                    widget.user.userInfo!.address!.formattedAddress,
                                    style: TextStyles.regularWhite14,
                                    softWrap: true,
                                    maxLines: 3, // Allow unlimited lines
                                    overflow: TextOverflow.visible, // Display all text
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    verticalMargin32,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    AudienceWidget(
                                      audienceCount: widget.user.venueInfo!
                                          .audience != null
                                          ? int.parse(
                                          widget.user.venueInfo!.audience!)
                                          : 0,),
                                    Text(widget.user.venueInfo!.audience ??
                                        0.toString(),
                                      style: TextStyles.boldAccent20,),
                                  ],
                                ),
                                verticalMargin8,
                                Text('Audience/Day',
                                  style: TextStyles.semiBoldN20014,)
                              ],
                            ),

                            horizontalMargin12,
                            const SizedBox(height: 48,
                                child: VerticalDivider(
                                    color: AppTheme.divider)),
                            horizontalMargin12,

                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(widget.user.venueInfo!.spaces!,
                                      style: TextStyles.boldAccent20,),
                                    const Icon(
                                      Icons.crop_free_sharp, size: 24,
                                      color: AppTheme.accentColor,),
                                  ],
                                ),
                                verticalMargin8,
                                Text('Total Spaces',
                                  style: TextStyles.semiBoldN20014,)
                              ],
                            ),
                          ],
                        ),
                        verticalMargin32,
                        Padding(
                          padding: horizontalPadding24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.user.venueInfo!.aboutYou!,
                                style: TextStyles.regularN200,),
                              verticalMargin32,
                              const SizedBox(width: 325,
                                  child: Divider(
                                      height: 1, color: AppTheme.divider)),
                              verticalMargin32,
                              Text(
                                'Opening hours', style: TextStyles.semiBoldN90014,),
                              verticalMargin8,
                              Column(
                                children: widget.user.venueInfo?.openingTimes?.map((e) =>
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(e.dayOfWeek.toString().split('.').last.capitalize() + ' ', style: TextStyles.regularN90014,),
                                        if(e.hourInterval.isEmpty) Text('n/a', style: TextStyles.regularN90014,) else
                                          Text(e.hourInterval.map((interval) {
                                            if(interval.from == null || interval.to == null) {
                                              return 'n/a';
                                            }
                                            final from = '${interval.from!.hour.toString().padLeft(2, '0')}:${interval.from!.minute.toString().padLeft(2, '0')}';
                                            final to = '${interval.to!.hour.toString().padLeft(2, '0')}:${interval.to!.minute.toString().padLeft(2, '0')}';
                                            return '$from-$to';
                                          }).join(', '), style: TextStyles.regularN90014,),
                                      ],
                                    )
                                ).toList() ?? [],
                              ),
                              verticalMargin32,
                              Text('Booking requirements',
                                style: TextStyles.semiBoldN90014,),
                              verticalMargin8,
                              Text('Price per space: ${double.parse(widget.user.bookingSettings!.basePrice!)} '
                                  '${CurrencyHelper.currency(widget.user.userInfo!.address!.country).currencySymbol}'
                                , style: TextStyles.regularN90014,),
                              verticalMargin8,
                              Text('Min spaces: ${widget.user.bookingSettings!
                                  .minSpaces ?? 'n/a'}', style: TextStyles.regularN90014,),
                              verticalMargin8,
                              Text('Min days: ${widget.user.bookingSettings!
                                  .minLength ?? 'n/a'}', style: TextStyles.regularN90014,),
                              verticalMargin32
                            ],
                          ),
                        )

                      ],
                    ),
                  ]
              )
          )
      );
  }
}