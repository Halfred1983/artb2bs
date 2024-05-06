

import 'package:flutter/material.dart';

class SearchFilter {
  final String? searchQuery;
  final RangeValues? priceRange;
  final List<String>? venueCategory;
  final double? radius;
  final String? priceInput;
  final String? daysInput;
  final List<String>? venueTypes;

  SearchFilter({
    this.searchQuery,
    this.priceRange,
    this.venueCategory,
    this.radius,
    this.priceInput,
    this.daysInput,
    this.venueTypes,
  });

  SearchFilter copyWith({
    String? searchQuery,
    RangeValues? priceRange,
    List<String>? venueCategory,
    double? radius,
    String? priceInput,
    String? daysInput,
    List<String>? venueTypes,
  }) {
    return SearchFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      priceRange: priceRange ?? this.priceRange,
      venueCategory: venueCategory ?? this.venueCategory,
      radius: radius ?? this.radius,
      priceInput: priceInput ?? this.priceInput,
      daysInput: daysInput ?? this.daysInput,
      venueTypes: venueTypes ?? this.venueTypes,
    );
  }
}