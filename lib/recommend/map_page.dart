import 'dart:convert';

import 'package:eco_path/data/string.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final logger = Logger();

class ShowMapPage extends StatefulWidget {
  final Map<String, List<String>> placesList;
  const ShowMapPage({super.key, required this.placesList});

  @override
  State<ShowMapPage> createState() => _ShowMapPageState();
}

class _ShowMapPageState extends State<ShowMapPage> {
  GoogleMapController? mapController;

  final Set<Marker> _markers = {};
  late LatLng? startmarker;
  late String route;
  bool loading = true;

  Future<void> postSelectedPlaces() async {
    const url = '$BASE_URL/eco_routes_dynamic';

    final body = widget.placesList;

    final headers = {
      'Content-Type': 'application/json',
    };
    if (!mounted) return;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      logger.d(response.body);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final result = RecommendedRouteResponse.fromJson(json);

        route = result.transportationGuide;
        late LatLng start;

        Set<Marker> marker = {};
        for (var i in result.route) {
          start = LatLng(i.location.lat, i.location.lng);
          marker.add(Marker(
              markerId: MarkerId(i.location.name),
              position: LatLng(i.location.lat, i.location.lng),
              infoWindow: InfoWindow(title: i.location.name)));
        }
        setState(() {
          startmarker = start;
          _markers.addAll(marker);
        });
        mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(start, 13),
        );
      } else {
        logger.e("통신 실패: ${response.statusCode}");
      }
      loading = false;
    } catch (e) {
      logger.e("에러 발생: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    postSelectedPlaces();
  }

  @override
  Widget build(BuildContext context) {
    if (loading || startmarker == null) {
      return const Center(child: CircularProgressIndicator());
    }
    logger.f("마커개수: ${_markers.length}\n$_markers, $startmarker");

    return Scaffold(
        appBar: AppBar(title: const Text('MAP')),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: GoogleMap(
                  onMapCreated: (controller) {
                    mapController = controller;
                    if (startmarker != null) {
                      mapController?.animateCamera(
                          CameraUpdate.newLatLngZoom(startmarker!, 13));
                    }
                  },
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(37.5665, 126.9780),
                    zoom: 12.0,
                  ),
                  markers: _markers,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(16), child: Text("경로:\n$route"))
            ]));
  }
}

class Location {
  final String name;
  final double lat;
  final double lng;

  Location({required this.name, required this.lat, required this.lng});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      lat: json['lat'].toDouble(),
      lng: json['lng'].toDouble(),
    );
  }
}

class RecommendedPlace {
  final String category;
  final Location location;

  RecommendedPlace({required this.category, required this.location});

  factory RecommendedPlace.fromJson(Map<String, dynamic> json) {
    return RecommendedPlace(
      category: json['category'],
      location: Location.fromJson(json['location']),
    );
  }
}

class RecommendedRouteResponse {
  final List<RecommendedPlace> route;
  final String transportationGuide;

  RecommendedRouteResponse(
      {required this.route, required this.transportationGuide});

  factory RecommendedRouteResponse.fromJson(Map<String, dynamic> json) {
    return RecommendedRouteResponse(
      route: (json['recommended_route'] as List)
          .map((e) => RecommendedPlace.fromJson(e))
          .toList(),
      transportationGuide: json['transportation_guide'],
    );
  }
}
