import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../app/resources/styles.dart';
import '../../app/resources/theme.dart';
import '../../utils/common.dart';

class PhotoDetails extends StatelessWidget {
  const PhotoDetails({super.key, required this.artwork});

  final Artwork artwork;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Artwork details", style: TextStyles.boldAccent24,),
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: AppTheme.primaryColourViolet, //change your color here
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
              padding: horizontalPadding24 + verticalPadding12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                          artwork.url!,
                          fit: BoxFit.contain
                      ),
                    ),
                  ),
                  verticalMargin24,
                  Text('Name:', style: TextStyles.semiBoldAccent16,),
                  verticalMargin8,
                  Text(artwork.name ?? 'n/a', style: TextStyles.boldViolet16,),
                  Divider(thickness: 0.5, color: AppTheme.black.withOpacity(0.4),),
                  verticalMargin24,
                  Text('Year:', style: TextStyles.semiBoldAccent16,),
                  verticalMargin8,
                  Text(artwork.name ?? 'n/a', style: TextStyles.boldViolet16,),
                  Divider(thickness: 0.5, color: AppTheme.black.withOpacity(0.4),),
                  verticalMargin24,
                  Text('Technique:', style: TextStyles.semiBoldAccent16,),
                  verticalMargin8,
                  Text(artwork.technique ?? 'n/a', style: TextStyles.boldViolet16,),
                  Divider(thickness: 0.5, color: AppTheme.black.withOpacity(0.4),),
                  verticalMargin24,
                  Text('Price:', style: TextStyles.semiBoldAccent16,),
                  verticalMargin8,
                  Text(artwork.price != null ? '${artwork.price} GBP' : 'n/a', style: TextStyles.boldViolet16,),
                  Divider(thickness: 0.5, color: AppTheme.black.withOpacity(0.4),),
                  verticalMargin24,
                  Text('Size:', style: TextStyles.semiBoldAccent16,),
                  verticalMargin8,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(FontAwesomeIcons.arrowsLeftRight, color: AppTheme.primaryColourViolet, size: 30,),
                      horizontalMargin8,
                      Text(artwork.width != null ? '${artwork.width} cm' : 'n/a', style: TextStyles.boldViolet16,),
                      horizontalMargin24,
                      const Icon(FontAwesomeIcons.arrowsUpDown, color: AppTheme.primaryColourViolet, size: 30,),
                      horizontalMargin8,
                      Text(artwork.height != null ? '${artwork.height} cm' : 'n/a', style: TextStyles.boldViolet16,),
                    ],
                  ),
                  Divider(thickness: 0.5, color: AppTheme.black.withOpacity(0.4),),
                  verticalMargin24,
                  Text('Vibes:', style: TextStyles.semiBoldAccent16,),
                  verticalMargin8,
                  Text( (artwork.tags != null && artwork.tags!.isNotEmpty) ? artwork.tags!.join(", ") : 'n/a',
                    style: TextStyles.boldViolet16,),
                ],
              ),
            )
            )
        );
  }
}
