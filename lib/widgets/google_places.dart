import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/app/resources/theme.dart';
import 'package:artb2b/onboard/cubit/onboarding_cubit.dart';
import 'package:artb2b/utils/common.dart';
import 'package:database_service/database.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:google_places_flutter/DioErrorHandler.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_details.dart';
import 'package:google_places_flutter/model/prediction.dart';

import '../utils/currency/currency_helper.dart';


class GoogleAddressLookup extends StatefulWidget {
  final String hint;
  final Function(UserAddress) onAddressChosen;

  GoogleAddressLookup({Key? key, this.hint = 'Your location', required this.onAddressChosen} ) : super(key: key);

  @override
  _GoogleAddressLookupState createState() => _GoogleAddressLookupState();
}

class _GoogleAddressLookupState extends State<GoogleAddressLookup> {
  GeoFlutterFire geoFlutterFire = GeoFlutterFire();
  late String apiKey;
  late var _dio;
  late final TextEditingController _placeController;

  @override
  void initState() {
    _dio = Dio();
    _placeController = TextEditingController(text: '');
    apiKey = dotenv.env['const GOOGLE_API_KEY']!;
    super.initState();
  }

  @override
  void dispose() {
    _placeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
      verticalMargin12,
      GooglePlaceAutoCompleteTextField(
        boxDecoration: const BoxDecoration(),
        textEditingController: _placeController,
        googleAPIKey: apiKey,
        inputDecoration:AppTheme.textInputDecoration.copyWith(hintText: widget.hint),
        debounceTime: 400,
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (Prediction prediction) {
          print("placeDetails" + prediction.lat.toString());
        },

        itemClick: (Prediction prediction) async {
          _placeController.text = prediction.description ?? "";
          _placeController.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description?.length ?? 0));
          var address = await getPlaceDetailsFromPlaceId(prediction);

          if(address != null) {
            if (!mounted) return;
            widget.onAddressChosen(address);
          }

          // Navigator.of(context).pop(address);
        },
        seperatedBuilder: const Divider(),
        containerHorizontalPadding: 10,

        // OPTIONAL// If you want to customize list view item builder
        itemBuilder: (context, index, Prediction prediction) {
          return Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Icon(Icons.location_on),
                const SizedBox(
                  width: 7,
                ),
                Expanded(child: Text("${prediction.description ?? ""}"))
              ],
            ),
          );
        },

        isCrossBtnShown: true,

        // default 600 ms ,
      ),
    ],
          );
  }



  String _address = '';
  String _place = '';
  String _province = '';
  String _city = '';
  String _zip = '';
  String _number = '';
  String _country = 'GB';
  String _locale = 'en_GB';

  Future<UserAddress?> getPlaceDetailsFromPlaceId(Prediction prediction) async {
    var url = "https://maps.googleapis.com/maps/api/place/details/json?placeid=${prediction.placeId}&key=${apiKey}";
    try {
      Response response = await _dio.get(
        url,
      );

      PlaceDetails placeDetails = PlaceDetails.fromJson(response.data);


      if (placeDetails.result != null && mounted) {
        placeDetails.result?.addressComponents?.forEach((element) {
          if (element.types!.contains('administrative_area_level_2')) {
            _province = element.longName!;
          }
          if (element.types!.contains('route')) {
            _address = element.longName!;
          }
          if (element.types!.contains('street_number')) {
            _number = element.longName!;
          }

          if(_city.isEmpty) _city = getCity(element);

          if (element.types!.contains('locality')) {
            _place = element.longName!;
          }
          if (element.types!.contains('postal_code')) {
            _zip = element.longName!;
          }
          if (element.types!.contains('country')) {
            _country = element.shortName!;
            _locale = 'en_$_country';
          }
        });
        String? formattedAddress = placeDetails.result?.formattedAddress;

        GeoFirePoint location;
        // if(result.result != null && result.result?.geometry != null ) {
        double? lat = placeDetails.result?.geometry?.location?.lat;
        double? lng = placeDetails.result?.geometry?.location?.lng;

        location = geoFlutterFire.point(latitude: lat!, longitude: lng!);
        // }

        return UserAddress(address: _address,
            place: _place,
            province: _province,
            city: _city,
            number: _number,
            zipcode: _zip,
            country: _country,
            locale: _locale,
            currencyCode: CurrencyHelper
                .currency(_country)
                .currencyName!,
            location: location,
            formattedAddress: formattedAddress ?? "");
      }
    }
    catch(e){
      var errorHandler = ErrorHandler.internal().handleError(e);
      _showSnackBar("${errorHandler.message}");
    }
  }

  String getCity(AddressComponents element) {
    String city = '';
    if (element.types!.contains('administrative_area_level_3')) {
      city = element.longName!;
    }
    if(city.isEmpty && element.types!.contains('locality')) {
      city = element.longName!;
    }
    if (city.isEmpty && element.types!.contains('postal_town')) {
      city = element.longName!;
    }
    return city;
  }

  _showSnackBar(String errorData) {
      final snackBar = SnackBar(
        content: Text("$errorData"),
      );

      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}