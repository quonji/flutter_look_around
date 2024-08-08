import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_look_around/flutter_look_around.dart';

class LookAroundBaseState extends State<FlutterLookAround> {
  @override
  Widget build(BuildContext context) => throw UnimplementedError();

  CreationParams get optionFromWidget => throw UnimplementedError();

  @visibleForOverriding
  void updateOptions() async {
    throw UnimplementedError();
  }

  @visibleForOverriding
  void onPlatformViewCreated(int id) async {}

}
