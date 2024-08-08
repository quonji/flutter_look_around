# flutter_look_around

A flutter plugin of MKLookaround for [iOS][ios].

[ios]:https://developer.apple.com/documentation/mapkit

## Install

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  flutter_look_around: <latest_version>
```

In your library add the following import:

```dart
import 'package:flutter_look_around/flutter_look_around.dart';
```
## Getting Started

Look Around is available starting from iOS 16 and above.
## Control look around widget

Add FlutterLookAround widget to your widget tree.

You can control look around by `LookAroundController` that is received at `onLookAroundCreated` callback. 

## Sample Usage

```dart
class _LookAroundExampleState extends State<LookAroundExample> {
  final bool _isNavigationEnabled = true;
  final bool _showsRoadLabels = true;
  final BadgePosition _badgePosition = BadgePosition.topLeading;
  final POIPointOfInterestFilter _poiPointOfInterestFilter =
      POIPointOfInterestFilter.includingAll;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LookAround Example'),
      ),
      body: Container(
        padding: const EdgeInsets.all(40),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            width: 400,
            height: 200,
            child: FlutterLookAround(
              initPosition: const LatLng(
                35.687216,
                139.741844,
              ),
              onLookAroundCreated: (LookAroundController controller) {
                lkController = controller;
              },
              isNavigationEnabled: _isNavigationEnabled,
              showsRoadLabels: _showsRoadLabels,
              badgePosition: _badgePosition,
              poiPointOfInterestFilter: _poiPointOfInterestFilter,
              errorWidget: const Center(
                child: Text('LookAround not available'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

```
