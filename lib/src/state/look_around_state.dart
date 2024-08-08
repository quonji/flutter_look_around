import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_look_around/flutter_look_around.dart';
import 'package:flutter_look_around/src/state/base_state.dart';

class LookAroundState extends LookAroundBaseState {
  final FlutterLookAroundPlatform _flutterLookAroundPlatform =
      FlutterLookAroundPlatform.instance;

  get _onLookAroundCreated => widget.onLookAroundCreated;
  final Completer<LookAroundController> _controller =
      Completer<LookAroundController>();
  late CreationParams _lookAroundOptions;
  int? _viewId;
  bool _isAvailable = true;
  String message = '';
  StreamSubscription? _lookAroundSubscription;

  @override
  void initState() {
    super.initState();
    _lookAroundOptions = optionFromWidget;
    _lookAroundSubscription =
        _flutterLookAroundPlatform.lookAroundEventStreamController.listen(
      (event) {
        if (event.viewId == _viewId && event is LookAroundIsAvailableEvent) {
          setState(() {
            _isAvailable = event.isAvailable;
            message = event.message;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> creationParams = optionFromWidget.toMap();
    _isAvailable =
        _flutterLookAroundPlatform.isLookAroundAvailable(viewId: _viewId ?? -1);
    if (_isAvailable) {
      return _flutterLookAroundPlatform.buildView(
          creationParams,
          widget.gestureRecognizers,
          _onPlatformViewCreated,
          widget.ignoring,
          widget.errorWidget);
    } else {
      return widget.errorWidget ??
          Center(child: Text('LookAround not available: $message'));
    }
  }

  @override
  void didUpdateWidget(FlutterLookAround oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateOptions();
  }

  @override
  void deactivate() {
    if (_viewId != null) {
      _flutterLookAroundPlatform.deactivate(_viewId!);
    }

    super.deactivate();
  }

  @override
  void dispose() {
    _lookAroundSubscription?.cancel();
    super.dispose();
  }

  @override
  CreationParams get optionFromWidget => CreationParams(
        location: widget.initPosition,
        isNavigationEnabled: widget.isNavigationEnabled,
        showsRoadLabels: widget.showsRoadLabels,
        badgePosition: widget.badgePosition,
        poiPointOfInterestFilter: widget.poiPointOfInterestFilter,
      );

  void _updateOptions() async {
    final CreationParams newOptions = optionFromWidget;
    final Map<String, dynamic> updates =
        _lookAroundOptions.updatesMap(newOptions);
    if (updates.isEmpty) {
      return;
    }
    final controller = await _controller.future;
    controller.updateLookAround(updates);
    _lookAroundOptions = newOptions;
  }

  void _onPlatformViewCreated(int id) async {
    _viewId = id;
    final LookAroundController controller =
        await LookAroundController.init(id, this);
    _controller.complete(controller);
    if (_onLookAroundCreated != null) _onLookAroundCreated!(controller);
  }
}
