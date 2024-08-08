import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_look_around/flutter_look_around.dart';
import 'package:flutter_look_around/src/flutter_look_around_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class FlutterLookAroundPlatform extends PlatformInterface {
  FlutterLookAroundPlatform() : super(token: _token);

  static FlutterLookAroundPlatform _instance = MethodChannelFlutterLookAround();

  static final Object _token = Object();

  static FlutterLookAroundPlatform get instance => _instance;

  get lookAroundEventStreamController => null;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [UrlLauncherPlatform] when they register themselves.
  static set instance(FlutterLookAroundPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Initializes the platform interface with [id].
  ///
  /// This method is called when the plugin is first initialized.
  Future<dynamic> init(int viewId) {
    throw UnimplementedError('init() has not been implemented.');
  }

  /// FlutterLookAround is deactivated
  void deactivate(int viewId) {
    throw UnimplementedError('deactivate() has not been implemented.');
  }

  /// Updates configuration options of the look around user interface.
  ///
  /// Change listeners are notified once the update has been made on the
  /// platform side.
  ///
  /// The returned [Future] completes after listeners have been notified.
  Future<dynamic> updateLookAroundOptions(
    Map<String, dynamic> optionsUpdate, {
    required int viewId,
  }) {
    throw UnimplementedError(
        'updateLookAroundOptions() has not been implemented.');
  }

  bool isLookAroundAvailable({required int viewId}) {
    throw UnimplementedError(
        'isLookAroundAvailable() has not been implemented.');
  }

  /// Sets look around to allow moving to another panorama.
  ///
  /// Return [Future] while the change has been made on the platform side.
  Future<void> setUserNavigationEnabled(int viewId, bool enable) {
    throw UnimplementedError(
        'setUserNavigationEnabled() has not been implemented.');
  }

  /// Sets look around to show road labels.
  Future<void> setShowRoadLabels(int viewId, bool showRoadLabels) {
    throw UnimplementedError('setShowRoadLabels() has not been implemented.');
  }

  /// Sets look around badge position.
  Future<void> setBadgePosition(int viewId, BadgePosition badgePosition) {
    throw UnimplementedError('setBadgePosition() has not been implemented.');
  }

  /// Sets look around POIPointOfInterestFilter
  Future<void> setPOIPointOfInterestFilter(
      int viewId, POIPointOfInterestFilter poiPointOfInterestFilter) {
    throw UnimplementedError(
        'setPOIPointOfInterestFilter() has not been implemented.');
  }

  /// Returns a widget displaying the look around
  Widget buildView(
      Map<String, dynamic> creationParams,
      Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers,
      PlatformViewCreatedCallback onPlatformViewCreated,
      bool? ignoring,
      Widget? errorWidget,
      {int? viewId}) {
    throw UnimplementedError('buildView() has not been implemented.');
  }
}
