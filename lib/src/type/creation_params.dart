import 'package:flutter_look_around/src/type/badge_position.dart';
import 'package:flutter_look_around/src/type/lat_lng.dart';
import 'package:flutter_look_around/src/type/poi_filter.dart';

class CreationParams {
  final LatLng? location;
  final bool? isNavigationEnabled;
  final bool? showsRoadLabels;
  BadgePosition? badgePosition;
  POIPointOfInterestFilter? poiPointOfInterestFilter;

  CreationParams({
    this.location,
    this.isNavigationEnabled = false,
    this.showsRoadLabels = false,
    this.badgePosition = BadgePosition.topLeading,
    this.poiPointOfInterestFilter,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "latitude": location?.latitude,
      "longitude": location?.longitude,
      "isNavigationEnabled": isNavigationEnabled,
      "showsRoadLabels": showsRoadLabels,
      "badgePosition": badgePosition?.name ?? "bottomTrailing",
      "POIPointOfInterestFilter": poiPointOfInterestFilter?.toMap(),
    };
  }

  bool hasChanged(CreationParams other) {
    return location != other.location ||
        isNavigationEnabled != other.isNavigationEnabled ||
        showsRoadLabels != other.showsRoadLabels ||
        badgePosition != other.badgePosition ||
        poiPointOfInterestFilter != other.poiPointOfInterestFilter;
  }

  Map<String, dynamic> updatesMap(CreationParams newOptions) {
    final Map<String, dynamic> updates = <String, dynamic>{};
    if (location != newOptions.location) {
      updates["latitude"] = newOptions.location?.latitude;
      updates["longitude"] = newOptions.location?.longitude;
    }
    if (isNavigationEnabled != newOptions.isNavigationEnabled) {
      updates["isNavigationEnabled"] = newOptions.isNavigationEnabled;
    }
    if (showsRoadLabels != newOptions.showsRoadLabels) {
      updates["showsRoadLabels"] = newOptions.showsRoadLabels;
    }
    if (badgePosition != newOptions.badgePosition) {
      updates["badgePosition"] =
          newOptions.badgePosition?.name ?? "bottomTrailing";
    }
    if (poiPointOfInterestFilter != newOptions.poiPointOfInterestFilter) {
      updates["POIPointOfInterestFilter"] =
          newOptions.poiPointOfInterestFilter?.toMap();
    }
    return updates;
  }
}
