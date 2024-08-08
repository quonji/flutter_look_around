import 'package:flutter_look_around/src/type/poi_category.dart';

class POIPointOfInterestFilter {

  /// The list of categories to include.
  final List<POICategory> _includedCategories;

  /// The list of categories to exclude.
  final List<POICategory> _excludedCategories;

  /// A filter that includes all categories.
  static final POIPointOfInterestFilter includingAll =
      POIPointOfInterestFilter._(
    includedCategories: POICategory.values,
    excludedCategories: [],
  );

  /// A filter that excludes all categories.
  static final POIPointOfInterestFilter excludingAll =
      POIPointOfInterestFilter._(
    includedCategories: [],
    excludedCategories: POICategory.values,
  );

  /// A filter that includes all categories except the ones passed.
  Map<String, dynamic> toMap() {
    final poiLength = POICategory.values.length;
    return <String, dynamic>{
      'includingAll': _includedCategories.length == poiLength,
      'includedCategories': _includedCategories.map((e) => e.name).toList(),
      'excludedCategories': _excludedCategories.map((e) => e.name).toList(),
      'excludingAll': _excludedCategories.length == poiLength,
    };
  }

  /// A filter that includes all categories except the ones passed.
  factory POIPointOfInterestFilter.fromMap(Map<String, dynamic> map) {
    return POIPointOfInterestFilter._(
      includedCategories: (map['includedCategories'] as List)
          .map((e) =>
              POICategory.values.firstWhere((element) => element.name == e))
          .toList(),
      excludedCategories: (map['excludedCategories'] as List)
          .map((e) =>
              POICategory.values.firstWhere((element) => element.name == e))
          .toList(),
    );
  }

  /// Private constructor
  POIPointOfInterestFilter._({
    List<POICategory>? includedCategories,
    List<POICategory>? excludedCategories,
  })  : _includedCategories = includedCategories ?? [],
        _excludedCategories = excludedCategories ?? [];

  /// A filter that includes the categories passed.
  factory POIPointOfInterestFilter.including(List<POICategory> categories) {
    return POIPointOfInterestFilter._(
      includedCategories: categories,
      excludedCategories: [],
    );
  }

  /// A filter that excludes the categories passed.
  factory POIPointOfInterestFilter.excluding(List<POICategory> categories) {
    return POIPointOfInterestFilter._(
      includedCategories: [],
      excludedCategories: categories,
    );
  }

  /// A filter that includes the categories passed and excludes the rest.
  bool includes(POICategory category) {
    return _includedCategories.contains(category);
  }

  /// A filter that excludes the categories passed and includes the rest.
  bool excludes(POICategory category) {
    return _excludedCategories.contains(category);
  }

  List<POICategory> get includedCategories => _includedCategories;

  List<POICategory> get excludedCategories => _excludedCategories;
}
