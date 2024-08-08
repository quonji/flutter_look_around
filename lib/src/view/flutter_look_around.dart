import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_look_around/src/controller/look_around_controller.dart';
import 'package:flutter_look_around/src/state/look_around_state.dart';
import 'package:flutter_look_around/src/type/badge_position.dart';
import 'package:flutter_look_around/src/type/lat_lng.dart';
import 'package:flutter_look_around/src/type/poi_filter.dart';

class FlutterLookAround extends StatefulWidget {
  const FlutterLookAround({
    super.key,
    required this.initPosition,
    this.isNavigationEnabled = true,
    this.showsRoadLabels = true,
    this.badgePosition = BadgePosition.topLeading,
    this.poiPointOfInterestFilter,
    this.onLookAroundCreated,
    this.gestureRecognizers,
    this.errorWidget,
    this.ignoring = false,
  });

  /// The initial position of the camera.
  final LatLng initPosition;

  /// Whether the user can navigate to another panorama.
  final bool? isNavigationEnabled;

  /// Whether road labels are shown.
  final bool? showsRoadLabels;

  /// The position of the badge.
  final BadgePosition? badgePosition;

  /// The filter for the points of interest.
  final POIPointOfInterestFilter? poiPointOfInterestFilter;

  /// Callback to receive the LookAroundController when the widget has been created.
  final LookAroundCreatedCallback? onLookAroundCreated;

  /// The gesture recognizers that will override the default recognizers.
  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;

  /// The widget displays while the platform view is down or unavailable.
  final Widget? errorWidget;

  /// Whether the widget should be ignored.
  final bool? ignoring;

  @override
  State<FlutterLookAround> createState() => LookAroundState();
}
