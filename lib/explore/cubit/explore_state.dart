import 'package:database_service/database.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ExploreState extends Equatable {}

class InitialState extends ExploreState {
  @override
  List<Object> get props => [];
}

class LoadingState extends ExploreState {
  @override
  List<Object> get props => [];
}

class LoadedState extends ExploreState {
  LoadedState(this.user, this.hosts, this.filter);

  final User user;
  final List<User> hosts;
  final SearchFilter filter;

  @override
  List<Object> get props => [user, hosts, filter ];
}

// class DataSaved extends ArtworkState {
//   DataSaved(this.user);
//   final User user;
//
//
//   @override
//   List<Object> get props => [user];
// }

class ErrorState extends ExploreState {
  final String message;

  ErrorState({this.message = 'An error occurred'});
  @override
  List<Object> get props => [message];
}

class SearchFilter {
  final String? searchQuery;
  final RangeValues? priceRange;
  final List<String>? venueCategory;
  final double? radius;
  final String? priceInput;
  final String? daysInput;
  final List<String>? venueVibes;

  SearchFilter({
    this.searchQuery,
    this.priceRange,
    this.venueCategory,
    this.radius,
    this.priceInput,
    this.daysInput,
    this.venueVibes,
  });

  SearchFilter copyWith({
    String? searchQuery,
    RangeValues? priceRange,
    List<String>? venueCategory,
    double? radius,
    String? priceInput,
    String? daysInput,
    List<String>? venueVibes,
  }) {
    return SearchFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      priceRange: priceRange ?? this.priceRange,
      venueCategory: venueCategory ?? this.venueCategory,
      radius: radius ?? this.radius,
      priceInput: priceInput ?? this.priceInput,
      daysInput: daysInput ?? this.daysInput,
      venueVibes: venueVibes ?? this.venueVibes,
    );
  }
}