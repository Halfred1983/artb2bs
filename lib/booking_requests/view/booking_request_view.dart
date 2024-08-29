import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/booking_requests/cubit/booking_request_cubit.dart';
import 'package:artb2b/booking_requests/cubit/booking_request_state.dart';
import 'package:artb2b/utils/common.dart';
import 'package:artb2b/widgets/loading_screen.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../injection.dart';
import '../../app/resources/theme.dart';
import '../../utils/booking_utils.dart';
import '../../widgets/scollable_chips.dart';
import 'booking_card.dart';
import 'booking_dialog.dart';

class BookingRequestView extends StatefulWidget {
  final List<String> choices;
  final bool isEmbedded;
  final User user;

  BookingRequestView({
    super.key,
    this.isEmbedded = false,
    List<String>? choices,
    required this.user,
  }) : choices = choices ?? ['All'] + BookingStatus.values.map((e) => e.name.capitalize()).toList() + ['Upcoming'];

  @override
  State<BookingRequestView> createState() => _BookingRequestViewState();
}

class _BookingRequestViewState extends State<BookingRequestView> {

  final Map<String, User> _userCache = {}; // Cache for user data
  final int _pageSize = 10;

  final PagingController<int, Booking> _pagingController =
  PagingController(firstPageKey: 0);
  bool _isLoading = false;
  String _filter = 'All';

  @override
  void initState() {
    super.initState();

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }


  Future<void> _fetchPage(int pageKey, {bool reset = false}) async {
    try {
      if(reset) {
        _pagingController.itemList!.clear();
      }

      // Fetch the bookings from your data source (e.g., API or database)
      final newItems = await context.read<BookingRequestCubit>()
          .fetchBookingList(reset: reset, user: widget.user, filter: _filter);

      // Load host and artist data in parallel and cache it
      await Future.wait(newItems.map((booking) async {
        if (!_userCache.containsKey(booking.hostId)) {
          _userCache[booking.hostId!] = await locator<FirestoreDatabaseService>().getUser(userId: booking.hostId!) as User;
        }
        if (!_userCache.containsKey(booking.artistId)) {
          _userCache[booking.artistId!] = await locator<FirestoreDatabaseService>().getUser(userId: booking.artistId!) as User;
        }
      }));

      final isLastPage = newItems.length < _pageSize; // Determine if it's the last page
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingRequestCubit, BookingRequestState>(
        builder: (context, state) {
          if (state is LoadingState && state.bookings.isEmpty) {
            return const LoadingScreen();
          } else if (state is ErrorState) {
            return _buildErrorDialog(context, state.error, state.user);
          } else if (state is LoadedState) {


            Widget body = Column(
                children: [
                  _buildFilterSection(context, state.user),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        verticalMargin24,
                        if(_isLoading) ...[ const CircularProgressIndicator(color: AppTheme.accentColor,) ]
                        else if  (state.bookings.isEmpty && (_pagingController.itemList != null
                            && _pagingController.itemList!.isEmpty)) ... [
                          Padding(
                            padding: horizontalPadding24,
                            child: Text(
                              'No bookings for the selected criteria',
                              style: TextStyles.boldN90029,
                            ),
                          ) ]
                        else ...[
                            Expanded(
                                child: Padding(
                                  padding: widget.isEmbedded
                                      ? EdgeInsets.zero
                                      : horizontalPadding32,
                                  child:
                                  PagedListView<int, Booking>(

                                    pagingController: _pagingController,
                                    builderDelegate: PagedChildBuilderDelegate<Booking>(
                                        itemBuilder: (context, item, index) {

                                          final host = _userCache[item.hostId!];
                                          final artist = _userCache[item.artistId!];

                                          return BookingCard(
                                            booking: item,
                                            host: host!,
                                            artist: artist!,
                                            user: widget.user,
                                            onTap: (booking) => BookingUtils.showBookingDetails(context, booking, widget.user),
                                            isEmbedded: widget.isEmbedded,
                                          );
                                        }
                                    ),
                                  ),
                                )
                            ),
                          ]
                      ],
                    ),
                  ),
                ]
            );

            if (!widget.isEmbedded) {
              return Scaffold(
                appBar: AppBar(
                  scrolledUnderElevation: 0,
                  title: Padding(
                    padding: horizontalPadding32,
                    child: Text('Your Bookings', style: TextStyles.boldN90029),
                  ),
                  backgroundColor: AppTheme.white,
                  centerTitle: false,
                  titleSpacing: 0,
                ),
                body: body,
              );
            }

            return body;
          }
          else {
            return const LoadingScreen();
          }
        }
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Widget _buildFilterSection(BuildContext context, User user) {
    return Container(
      decoration: ShapeDecoration(
        color: widget.isEmbedded ? AppTheme.backgroundColor : AppTheme.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Padding(
        padding: EdgeInsets.zero,
        child: ScrollableChips(
          choices: widget.choices,
          onSelectionChanged: (selectedValue) {

            //RESET FILTER ??
            setState(() {
              _isLoading = true;
              _filter = selectedValue;
              _fetchPage(0, reset: true );
            });


            // context.read<BookingRequestCubit>().updateFilter(_filter, user);
          },
          selectedValue: _filter,
        ),
      ),
    );
  }

  Widget _buildErrorDialog(BuildContext context, String message, User user) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      title: Center(child: Text('Error', style: TextStyles.semiBoldAccent14)),
      content: Text(message, textAlign: TextAlign.center, style: TextStyles.semiBoldAccent14),
      actions: [
        Center(
          child: TextButton(
            onPressed: () {
              context.read<BookingRequestCubit>().exitAlert(user);
            },
            child: Text('OK', style: TextStyles.semiBoldAccent14),
          ),
        ),
      ],
    );
  }

}