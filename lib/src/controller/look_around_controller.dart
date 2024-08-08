import 'dart:async';

import 'package:flutter_look_around/flutter_look_around.dart';
import 'package:flutter_look_around/src/state/base_state.dart';

/// Callback method for when the LookAround is ready to be used.
///
/// Pass to [FlutterLookAround.onLookAroundCreated] to receive a [LookAroundController] when the
/// look around is created.
typedef LookAroundCreatedCallback = void Function(
    LookAroundController controller);

FlutterLookAroundPlatform _flutterLookAroundPlatform =
    FlutterLookAroundPlatform.instance;

class LookAroundController {
  final int viewId;

  bool _isNavigationEnabled = true;
  bool _showsRoadLabels = true;
  BadgePosition _badgePosition = BadgePosition.topLeading;
  POIPointOfInterestFilter _poiPointOfInterestFilter =
      POIPointOfInterestFilter.includingAll;

  LookAroundController._(LookAroundBaseState lookAroundState,
      {required this.viewId, required dynamic initSetting}) {
    if (initSetting == null) return;
    if (initSetting['isNavigationEnabled'] != null) {
      _isNavigationEnabled = initSetting['isNavigationEnabled']!;
    }
    if (initSetting['showsRoadLabels'] != null) {
      _showsRoadLabels = initSetting['showsRoadLabels']!;
    }
    if (initSetting['badgePosition'] != null) {
      _badgePosition = BadgePosition.values[initSetting['badgePosition']];
    }
    if (initSetting['POIPointOfInterestFilter'] != null) {
      _poiPointOfInterestFilter = POIPointOfInterestFilter.fromMap(
          initSetting['POIPointOfInterestFilter']);
    }

    FlutterLookAroundPlatform.instance = _flutterLookAroundPlatform;
  }

  /// Initialize control of a [FlutterLookAround] with [id].
  ///
  /// Mainly for internal use when instantiating a [LookAroundController] passed
  /// in [FlutterLookAround.onLookAroundCreated] callback.
  static Future<LookAroundController> init(
      int id, LookAroundBaseState lookAroundState) async {
    final dynamic initSetting = await _flutterLookAroundPlatform.init(id);
    return LookAroundController._(lookAroundState,
        viewId: id, initSetting: initSetting);
  }

  bool get isNavigationEnabled => _isNavigationEnabled;

  bool get showsRoadLabels => _showsRoadLabels;

  BadgePosition get badgePosition => _badgePosition;

  POIPointOfInterestFilter get poiPointOfInterestFilter =>
      _poiPointOfInterestFilter;

  bool? get isLookAroundAvailable =>
      _flutterLookAroundPlatform.isLookAroundAvailable(viewId: viewId);

  /// Sets look around to allow moving to another panorama.
  ///
  /// Return [Future] while the change has been made on the platform side.
  Future<void> setUserNavigationEnabled(bool enable) {
    if (enable == _isNavigationEnabled) {
      return Future.delayed(Duration.zero);
    }
    return _flutterLookAroundPlatform
        .setUserNavigationEnabled(viewId, enable)
        .then((value) => _isNavigationEnabled = enable);
  }

  /// showsRoadLabels;
  Future<void> setShowRoadLabels(bool showRoadLabels) {
    if (showRoadLabels == _showsRoadLabels) {
      return Future.delayed(Duration.zero);
    }
    return _flutterLookAroundPlatform
        .setShowRoadLabels(viewId, showRoadLabels)
        .then((value) => _showsRoadLabels = showRoadLabels);
  }

  /// Badge position of the look around.
  Future<void> setBadgePosition(BadgePosition badgePosition) {
    if (badgePosition == _badgePosition) {
      return Future.delayed(Duration.zero);
    }
    return _flutterLookAroundPlatform
        .setBadgePosition(viewId, badgePosition)
        .then((value) => _badgePosition = badgePosition);
  }

  /// POIPointOfInterestFilter of the look around.
  Future<void> setPOIPointOfInterestFilter(
      POIPointOfInterestFilter poiPointOfInterestFilter) {
    return _flutterLookAroundPlatform
        .setPOIPointOfInterestFilter(viewId, poiPointOfInterestFilter)
        .then((value) => _poiPointOfInterestFilter = poiPointOfInterestFilter);
  }

  /// Updates configuration options of the look around user interface.
  ///
  /// Change listeners are notified once the update has been made on the
  /// platform side.
  ///
  /// The returned [Future] completes after listeners have been notified.
  Future<dynamic> updateLookAround(Map<String, dynamic> optionsUpdate) {
    return _flutterLookAroundPlatform.updateLookAroundOptions(optionsUpdate,
        viewId: viewId);
  }
}
