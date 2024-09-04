import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../app/resources/assets.dart';
import '../app/resources/styles.dart';
import '../app/resources/theme.dart';
import '../utils/common.dart';
import '../utils/currency/currency_helper.dart';
import 'common_card_widget.dart';

class HostListCardBig extends StatefulWidget {
  final User user;

  HostListCardBig({super.key, required this.user});

  @override
  _HostListCardBigState createState() => _HostListCardBigState();
}

class _HostListCardBigState extends State<HostListCardBig> {
  final PageController controller = PageController(viewportFraction: 1, keepPage: true);
  List<int> currentIndices = [];

  @override
  void initState() {
    super.initState();
    currentIndices = List.filled(widget.user.photos?.length ?? 0, 0);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> photos = [];
    if (widget.user.photos != null && widget.user.photos!.isNotEmpty) {
      photos = List.generate(
        widget.user.photos!.length,
            (index) => ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: FadeInImage(
            imageErrorBuilder: (context, error, stackTrace) {
              return const Image(
                image: AssetImage(Assets.logo),
                fit: BoxFit.cover,
              );
            },
            width: double.infinity,
            placeholder: const AssetImage(Assets.logo),
            image: NetworkImage(widget.user.photos![index].url!),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    // Build your list item using the user data
    return Container(
      width: double.infinity,
      padding: verticalPadding8,
      child: InkWell(
        onTap: () => context.pushNamed(
          'profile',
          pathParameters: {'userId': widget.user.id},
        ),
        child: CommonCard(
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(24),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                if(photos.isNotEmpty) ...[
                  Stack(
                    children: [
                      SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: PageView.builder(
                          onPageChanged: (pageId,) {
                            setState(() {
                              currentIndices[
                              0] = pageId;
                            });
                          },
                          padEnds: false,
                          controller: controller,
                          itemCount: photos.length,
                          itemBuilder: (context, index) {
                            return photos[index % photos.length];
                          },
                        ), // Select photo dynamically using index
                      ),
                      Positioned.fill(
                        bottom: 12,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: AnimatedSmoothIndicator(
                            activeIndex: currentIndices.isNotEmpty ? currentIndices[
                            0] : 0,
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
                        ),
                      )
                    ],
                  ),
                ]
                else ... [
                  const SizedBox(
                    width: double.infinity,
                    height: 200,
                    child:FadeInImage(
                      placeholder: AssetImage(Assets.logo),
                      image: NetworkImage(Assets.logoUrl),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ],
                SizedBox(
                  height: 100,
                  child: Padding(
                    padding: horizontalPadding24 + verticalPadding12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.user.userInfo!.name!, style: TextStyles.boldN90017,),
                            Row(
                              children: [
                                const Icon(Icons.location_pin, size: 10,),
                                Text(widget.user.userInfo!.address!.city,
                                  softWrap: true, style: TextStyles.regularN90010,),
                              ],
                            ),
                            Expanded(child: Container(),),
                            Text(widget.user.venueInfo!.typeOfVenue != null ?
                            widget.user.venueInfo!.typeOfVenue!.join(", ") :
                            '', softWrap: true, style: TextStyles.semiBoldP40010,),
                            verticalMargin24

                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('From', style: TextStyles.regularAccent12,),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: AppTheme.primaryColor,
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(' ${widget.user.bookingSettings!.basePrice!} '
                                        '${CurrencyHelper.currency(widget.user.userInfo!.address!.country).currencySymbol}',
                                      style: TextStyles.semiBoldN90017,),

                                  ],
                                ),
                              ),
                            ),
                          ],
                        )],
                    ),

                  ),
                )


              ]
          ),
        ),
      ),
    );
  }
}
