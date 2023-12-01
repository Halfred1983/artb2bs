import 'dart:typed_data';

import 'package:artb2b/utils/common.dart';
import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/app/resources/theme.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:google_place/google_place.dart';

import 'app_text_field.dart';


class GoogleAddressLookup extends StatefulWidget {
  const GoogleAddressLookup({Key? key}) : super(key: key);


  @override
  _GoogleAddressLookupState createState() => _GoogleAddressLookupState();
}

class _GoogleAddressLookupState extends State<GoogleAddressLookup> {
  GooglePlace? _googlePlace;
  GeoFlutterFire geoFlutterFire = GeoFlutterFire();
  List<AutocompletePrediction> _predictions = [];
  late final TextEditingController _placeController;

  @override
  void initState() {
    String apiKey = 'AIzaSyACKPGCrcpyYx3w1PWxoaQhXOd0wGB7cSk';
    _googlePlace = GooglePlace(apiKey);
    _placeController = TextEditingController(text: '');
    super.initState();
  }

  @override
  void dispose() {
    _placeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppTheme.primaryColourViolet //change your color here
        ),
        title: Text("Your location", style: TextStyles.boldAccent24,),
        centerTitle: true,
      ),
      body: Container(
        padding: horizontalPadding24,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            verticalMargin12,
            Row(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: AppTextField(
                    controller: _placeController,
                    key: const Key('Address place'),
                    autoCorrect: false,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        autoCompleteSearch(value);
                      } else {
                        if (_predictions.length > 0 && mounted) {
                          setState(() {
                            _predictions = [];
                          });
                        }
                      }
                    },
                  ),
                ),
                horizontalMargin12,
                Expanded(
                    flex: 1,
                    child:
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _placeController.text = '';
                          _predictions = [];
                        });
                      },
                        style: ButtonStyle(
                          overlayColor: MaterialStateColor.resolveWith((states) => AppTheme.accentColor),
                        ),
                        child:Text('Clear',
                        style: TextStyles.semiBoldViolet14.copyWith(decoration: TextDecoration.underline),)
                    ),

                )
              ],
            ),

            ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _predictions.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 4.0),
                        child: Icon(Icons.location_on_outlined,
                          size: 30, color: AppTheme.black,),
                      ),
                      Flexible(
                       child: Text(_predictions[index].description ?? '',
                            style: TextStyles.semiBoldViolet16,),
                      ),
                    ],
                  ),

                  onTap: () async {
                    debugPrint(_predictions[index].placeId);
                    var address = await getDetails(_predictions[index].placeId!);

                    Navigator.of(context).pop(address);

                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void autoCompleteSearch(String value) async {
    var result = await _googlePlace?.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        _predictions = result.predictions!;
      });
    }
  }

  String _address = '';
  String _place = '';
  String _province = '';
  String _city = '';
  String _zip = '';
  String _number = '';

  Future<UserAddress?> getDetails(String placeId) async {
    var result = await _googlePlace?.details.get(placeId);
    if (result != null && result.result != null && mounted) {

      result.result?.addressComponents?.forEach((element) {
        if (element.types!.contains('administrative_area_level_2')) {
          _province = element.shortName!;
        }
        if (element.types!.contains('route')) {
          _address = element.longName!;
        }
        if (element.types!.contains('street_number')) {
          _number = element.longName!;
        }
        if (element.types!.contains('administrative_area_level_3')) {
          _city = element.longName!;
        }
        if (element.types!.contains('postal_town')) {
          _city = element.longName!;
        }
        if (element.types!.contains('locality')) {
          _place = element.longName!;
        }
        if (element.types!.contains('postal_code')) {
          _zip = element.longName!;
        }
      });
      String? formattedAddress = result.result?.formattedAddress;

      GeoFirePoint location;
      // if(result.result != null && result.result?.geometry != null ) {
        double? lat = result.result?.geometry?.location?.lat;
        double? lng = result.result?.geometry?.location?.lng;

        location = geoFlutterFire.point(latitude: lat!, longitude: lng!);
      // }

      return UserAddress(address: _address, place: _place,
          province: _province, city: _city ,
          number: _number, zipcode:_zip, location: location, formattedAddress: formattedAddress ?? "");
    }
  }
}