import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'explore_state.dart';


class ExploreCubit extends Cubit<ExploreState> {
  ExploreCubit({required this.databaseService,
    required this.userId}) : super(InitialState()) {
    getUserAndHosts(userId);
  }

  final DatabaseService databaseService;
  final String userId;
  List<User> hosts = [];

  void getUserAndHosts(String userId) async {
    try {
      emit(LoadingState());
      final user = await databaseService.getUser(userId: userId);
      hosts = await databaseService.getHostsList();
      emit(LoadedState(user!, hosts, SearchFilter()));
    } catch (e) {
      emit(ErrorState());
    }
  }

  void updateSearchQuery(String searchQuery) {
    if (state is LoadedState) {
      LoadedState loadedState = state as LoadedState;
      SearchFilter newFilter = loadedState.filter.copyWith(searchQuery: searchQuery);

      emit(LoadedState(
          loadedState.user,
          filterHosts(newFilter),
          newFilter)
      );
    }
  }

  void updatePriceRange(RangeValues priceRange) {
    if (state is LoadedState) {
      LoadedState loadedState = state as LoadedState;
      SearchFilter newFilter = loadedState.filter.copyWith(priceRange: priceRange);
      emit(LoadedState(loadedState.user, loadedState.hosts, newFilter));
    }
  }

  void updateVenueCategory(List<String> venueCategory) {
    if (state is LoadedState) {
      LoadedState loadedState = state as LoadedState;
      SearchFilter newFilter = loadedState.filter.copyWith(venueCategory: venueCategory);
      emit(LoadedState(loadedState.user, loadedState.hosts, newFilter));
    }
  }

  void updateVenueVibes(List<String> venueVibes) {
    if (state is LoadedState) {
      LoadedState loadedState = state as LoadedState;
      SearchFilter newFilter = loadedState.filter.copyWith(venueVibes: venueVibes);
      emit(LoadedState(loadedState.user, loadedState.hosts, newFilter));
    }
  }

  void updateDaysInput(String daysInput) {
    if (state is LoadedState) {
      LoadedState loadedState = state as LoadedState;
      SearchFilter newFilter = loadedState.filter.copyWith(daysInput: daysInput);
      emit(LoadedState(loadedState.user, loadedState.hosts, newFilter));
    }
  }

  void applyFilters() {
    if (state is LoadedState) {
      LoadedState loadedState = state as LoadedState;
      List<User> filteredHosts = filterHosts(loadedState.filter);
      emit(LoadedState(loadedState.user, filteredHosts, loadedState.filter));
    }
  }

  void restFilters() {
    if (state is LoadedState) {
      LoadedState loadedState = state as LoadedState;
      emit(LoadedState(loadedState.user, hosts, SearchFilter()));
    }
  }

  List<User> filterHosts(SearchFilter filter) {
    List<User> filteredHosts = hosts.where((host) {

      bool matchesSearchQuery = true;
      if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
        matchesSearchQuery = host.userInfo!.name.toString().toLowerCase()
            .contains(filter.searchQuery ?? '');
      }

      int basePrice = int.parse(host.bookingSettings!.basePrice!);
      int startPrice = filter.priceRange != null ? filter.priceRange!.start.toInt() : 0;
      int endPrice = filter.priceRange != null ? filter.priceRange!.end.toInt() : 10000;

      bool matchesPriceRange = basePrice >= startPrice && basePrice <= endPrice;
      bool matchesVenueCategory = filter.venueCategory == null || filter.venueCategory!.isEmpty;
      if(filter.venueCategory != null && filter.venueCategory!.isNotEmpty
        && host.venueInfo!.typeOfVenue != null) {
        matchesVenueCategory = host.venueInfo!.typeOfVenue!.any((venue) =>
            filter.venueCategory!.contains(
                venue)); // Add more conditions for other filters...
      }
      bool matchesVenueVibes = filter.venueVibes == null || filter.venueVibes!.isEmpty;
      if(filter.venueVibes != null && filter.venueVibes!.isNotEmpty
        && host.venueInfo!.vibes != null) {
        matchesVenueCategory = host.venueInfo!.vibes!.any((venue) =>
            filter.venueVibes!.contains(
                venue)); // Add more conditions for other filters...
      }
      return matchesSearchQuery && matchesPriceRange && matchesVenueCategory && matchesVenueVibes;
      // Use logical AND or OR depending on your requirements
    }).toList();
    return filteredHosts;
  }
}