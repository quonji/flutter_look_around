import 'package:flutter/material.dart';
import 'package:flutter_look_around/flutter_look_around.dart';

void main() => runApp(const MyApp());
LookAroundController? lkController;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LookAroundExample(),
    );
  }
}

class LookAroundExample extends StatefulWidget {
  const LookAroundExample({super.key});

  @override
  State<LookAroundExample> createState() => _LookAroundExampleState();
}

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
