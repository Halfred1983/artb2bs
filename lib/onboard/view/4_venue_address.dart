import 'package:artb2b/onboard/cubit/onboarding_cubit.dart';
import 'package:artb2b/onboard/cubit/onboarding_state.dart';
import 'package:artb2b/widgets/dot_indicator.dart';
import 'package:artb2b/widgets/google_places.dart';
import 'package:auth_service/auth.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../app/resources/styles.dart';
import '../../app/resources/theme.dart';
import '../../host/view/host_setting_page.dart';
import '../../injection.dart';
import '../../utils/common.dart';
import '../../widgets/loading_screen.dart';
import '5_venue_spaces.dart';


class VenueAddressPage extends StatelessWidget {
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => VenueAddressPage());
  }

  bool isOnboarding;
  VenueAddressPage({Key? key, this.isOnboarding = true}) : super(key: key);

  final FirebaseAuthService authService = locator<FirebaseAuthService>();
  final FirestoreDatabaseService databaseService = locator<FirestoreDatabaseService>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnboardingCubit>(
      create: (context) => OnboardingCubit(
        databaseService: databaseService,
        userId: authService.getUser().id,
      ),
      child: SelectAddressView(isOnboarding: isOnboarding),
    );
  }
}



class SelectAddressView extends StatefulWidget {
  SelectAddressView({Key? key, this.isOnboarding = true}) : super(key: key);


  bool isOnboarding;
  @override
  State<SelectAddressView> createState() => _SelectAddressViewState();
}

class _SelectAddressViewState extends State<SelectAddressView> {
  final TextEditingController _aptBuilding = TextEditingController();

  User? user;
  GoogleMapController? _mapController;
  LatLng? _selectedLocation; // For storing the selected location

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  late BitmapDescriptor markerGalleryIcon;

  String _mapStyle = '';

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/googleMapsStyle.json').then((string) {
      _mapStyle = string;
    });

    BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(30, 30)),
        'assets/images/marker_gallery.png'
    ).then((onValue) {
      markerGalleryIcon = onValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> addressInfo = [Container()];
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return const LoadingScreen();
        }
        if(state is AddressChosen || state is LoadedState) {
          user = state.user!;
          UserAddress? address = user!.userInfo!.address;
          if(address != null) {
            _aptBuilding.text = user!.userInfo!.address!.aptBuilding ?? '';

            addressInfo = [
              verticalMargin16,
              Text('Country', style: TextStyles.boldN90016),
              verticalMargin8,
              InactiveTextField(label: address!.country,),
              verticalMargin16,
              Text('Address', style: TextStyles.boldN90016),
              verticalMargin8,
              InactiveTextField(label: address!.address+address!.number,),
              TextField(
                controller: _aptBuilding,
                autofocus: false,
                style: TextStyles.semiBoldN90014,
                onChanged: (String value) {
                  address = address!.copyWith(aptBuilding: value);
                  context.read<OnboardingCubit>().chooseAddress(address!);
                },
                autocorrect: false,
                enableSuggestions: false,
                decoration: AppTheme.textInputDecoration.copyWith(hintText: 'Apt/Building',),
                keyboardType: TextInputType.text,
              ),
              verticalMargin16,
              Text('Province', style: TextStyles.boldN90016),
              verticalMargin8,
              InactiveTextField(label: address!.province,),
              verticalMargin16,
              Text('City', style: TextStyles.boldN90016),
              verticalMargin8,
              InactiveTextField(label: address!.city,),
            ];
          }
        }
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: !widget.isOnboarding ? AppBar(
            scrolledUnderElevation: 0,
            title: Text(user!.userInfo!.name!, style: TextStyles.boldN90017,),
            centerTitle: true,
            iconTheme: const IconThemeData(
              color: AppTheme.n900, //change your color here
            ),
          ) : null,
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: horizontalPadding32 + (widget.isOnboarding ? verticalPadding48 : EdgeInsets.zero),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(widget.isOnboarding)... [
                      verticalMargin48,
                      const LineIndicator(
                        totalSteps: 9,
                        currentStep: 2,
                      ),
                      verticalMargin24,
                      Text('Where is your venue located',
                          style: TextStyles.boldN90029),
                      verticalMargin48,
                    ],
                    GoogleAddressLookup(onAddressChosen: (address) {
                      context.read<OnboardingCubit>().chooseAddress(address);
                      setState(() {
                        _selectedLocation = LatLng(
                          address.location!.latitude,
                          address.location!.longitude,
                        );
                      });

                      _animateToLocation(_selectedLocation!);

                    },),
                    verticalMargin12,
                    SizedBox(
                      height: 300, // Height for the Google Map
                      child: _buildGoogleMap(),
                    ),
                    ...addressInfo,
                    verticalMargin48,
                    verticalMargin24
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: Container(
            padding: horizontalPadding32,
            width: double.infinity,
            child: FloatingActionButton(
                backgroundColor:  true ? AppTheme.n900 : AppTheme.disabledButton,
                foregroundColor: true ? AppTheme.primaryColor : AppTheme.n900,
                onPressed: () {
                  if(_canContinue()) {
                    if (widget.isOnboarding) {
                      context.read<OnboardingCubit>().save(
                          user!, UserStatus.locationInfo);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            VenueSpacesPage()), // Replace NewPage with the actual class of your new page
                      );
                    }
                    else {
                      context.read<OnboardingCubit>().save(user!);
                      Navigator.of(context)..pop()..pop();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HostSettingPage()),
                      );
                    }
                  }
                  else { return ; }
                },
                child: const Text('Continue',)
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation
              .centerDocked,
        );
      },
    );
  }


  // Build the Google Map widget
  Widget _buildGoogleMap() {
    return GoogleMap(
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      zoomGesturesEnabled: true,
      scrollGesturesEnabled: true,
      mapToolbarEnabled: false,
      rotateGesturesEnabled: false,
      tiltGesturesEnabled: false,
      myLocationEnabled: false,
      mapType: MapType.normal,
      compassEnabled: false,
      onMapCreated: (controller) {
        _mapController = controller;
        controller.setMapStyle(_mapStyle);
      },
      initialCameraPosition: CameraPosition(
        target: _selectedLocation ?? const LatLng(51.4975, 0.2000), // Default to (0, 0) if no location is chosen
        zoom: 10.0,
      ),
      markers: _selectedLocation != null
          ? {
        Marker(
          markerId: MarkerId('selected-location'),
          position: _selectedLocation!,
          icon: markerGalleryIcon,
        ),
      }
          : {},
    );
  }

  // Animate the camera to the selected location
  Future<void> _animateToLocation(LatLng location) async {
    if (_mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(location, 14.0),
      );
    }
  }

  bool _canContinue() {
    return user!.userInfo!.address != null;
    // user!.userInfo.address!.country != null &&
    // user!.userInfo.address!.address != null &&
    // user!.userInfo.address!.province != null &&
    // user!.userInfo.address!.city != null;
  }
}

class InactiveTextField extends StatelessWidget {
  const InactiveTextField({
    super.key, required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      enabled: false,
      style: TextStyles.semiBoldN90014,
      autocorrect: false,
      enableSuggestions: false,
      decoration: AppTheme.textInputDecoration.copyWith(hintText: label,
          fillColor: AppTheme.disabledButton),
      keyboardType: TextInputType.text,
    );
  }
}
