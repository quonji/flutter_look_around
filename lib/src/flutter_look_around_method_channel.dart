import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_look_around/flutter_look_around.dart';

class MethodChannelFlutterLookAround extends FlutterLookAroundPlatform {
  final Map<int, MethodChannel?> _channels = {};
  final Map<int, bool> _isAvailable = {};

  /// Accesses the MethodChannel associated to the passed viewId.
  MethodChannel? channel(int viewId) {
    return _channels[viewId];
  }

  /// Initializes the platform interface with [id].
  ///
  /// This method is called when the plugin is first initialized.
  @override
  Future<dynamic> init(int viewId) async {
    MethodChannel? channel;
    if (!_channels.containsKey(viewId)) {
      channel = MethodChannel('lookaround_view_$viewId');
      channel.setMethodCallHandler(
          (MethodCall call) => _handleMethodCall(call, viewId));
      _channels[viewId] = channel;
    } else {
      channel = _channels[viewId];
    }
  }

  // The controller we need to broadcast the different events coming
  // from handleMethodCall.
  //
  // It is a `broadcast` because multiple controllers will connect to
  // different stream views of this Controller.
  final StreamController<LookAroundEvent> _lookAroundEventStreamController =
      StreamController<LookAroundEvent>.broadcast();

  /// The stream controller that will broadcast the different events
  @override
  Stream<LookAroundEvent> get lookAroundEventStreamController =>
      _lookAroundEventStreamController.stream;

  /// FlutterLookAround is deactivated
  @override
  void deactivate(int viewId) {
    _channels[viewId]?.invokeMethod<void>('deactivate');
  }

  /// Returns whether the look around is available or not.
  @override
  bool isLookAroundAvailable({required int viewId}) {
    if (!_isAvailable.containsKey(viewId)) {
      return true;
    }
    return _isAvailable[viewId] ?? true;
  }

  /// Updates configuration options of the look around user interface.
  ///
  /// Change listeners are notified once the update has been made on the
  /// platform side.
  ///
  /// The returned [Future] completes after listeners have been notified.
  @override
  Future<dynamic> updateLookAroundOptions(
    Map<String, dynamic> optionsUpdate, {
    required int viewId,
  }) {
    return channel(viewId)!
        .invokeMethod("LookAround#updateOptions", optionsUpdate);
  }

  /// Sets look around to allow moving to another panorama.
  @override
  Future<void> setUserNavigationEnabled(int viewId, bool enable) {
    return channel(viewId)!
        .invokeMethod("LookAround#setNavigationEnabled", enable);
  }

  /// Sets look around to show road labels.
  @override
  Future<void> setShowRoadLabels(int viewId, bool showRoadLabels) {
    return channel(viewId)!
        .invokeMethod("LookAround#setShowRoadLabels", showRoadLabels);
  }

  /// Sets look around badge position.
  @override
  Future<void> setBadgePosition(int viewId, BadgePosition badgePosition) {
    return channel(viewId)!
        .invokeMethod("LookAround#setBadgePosition", badgePosition.name);
  }

  /// Sets look around POIPointOfInterestFilter
  @override
  Future<void> setPOIPointOfInterestFilter(
      int viewId, POIPointOfInterestFilter poiPointOfInterestFilter) {
    return channel(viewId)!.invokeMethod(
        "LookAround#setPOIPointOfInterestFilter",
        poiPointOfInterestFilter.toMap());
  }

  /// This method handles the different method calls coming from the platform
  Future<dynamic> _handleMethodCall(MethodCall call, int viewId) async {
    switch (call.method) {
      case 'LookAround#onError':
        throw PlatformException(
          code: call.arguments['code'],
          message: call.arguments['message'],
          details: call.arguments['details'],
        );
      case 'LookAround#onEvent':
        _lookAroundEventStreamController
            .add(LookAroundEvent(viewId, call.arguments['value']));
        break;

      case "LookAround#availability":
        _isAvailable[viewId] = call.arguments['isAvailable'] as bool;
        _lookAroundEventStreamController.add(
          LookAroundIsAvailableEvent(
            viewId,
            call.arguments['isAvailable'] as bool,
            call.arguments['message'] as String,
          ),
        );

        break;

      default:
        throw MissingPluginException();
    }
  }

  /// This method builds the appropriate platform view where the look around
  /// can be rendered.
  /// The `viewId` is passed as a parameter from the framework on the
  /// `onPlatformViewCreated` callback.
  @override
  Widget buildView(
      Map<String, dynamic> creationParams,
      Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers,
      PlatformViewCreatedCallback onPlatformViewCreated,
      bool? ignoring,
      Widget? errorWidget,
      {int? viewId}) {
    const String viewType = 'lookaround_view';
    if (Platform.isIOS) {
      return IgnorePointer(
        ignoring: ignoring ?? false,
        child: UiKitView(
            viewType: viewType,
            onPlatformViewCreated: onPlatformViewCreated,
            creationParams: creationParams,
            gestureRecognizers: gestureRecognizers,
            creationParamsCodec: const StandardMessageCodec()),
      );
    } else {
      return errorWidget ?? Center(
        child: Text('LookAround not supported on ${Platform.operatingSystem}'),
      );
    }
  }
}
