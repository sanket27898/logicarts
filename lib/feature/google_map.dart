import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  final CameraPosition _initialLocation = const CameraPosition(
    target: LatLng(39.2923, -146.9607),
    zoom: 0,
  );

  late GoogleMapController _controller;
  List<Marker>? markers;

  @override
  void initState() {
    initialMarker();
    super.initState();
  }

  List<Map<String, dynamic>> locationList = [
    {
      "name": "Hauckfurt23",
      "coordinates": {"latitude": 39.2923, "longitude": -146.9607}
    },
    {
      "name": "Schenectady16",
      "coordinates": {"latitude": 2.3379, "longitude": -157.6905}
    },
    {
      "name": "Wainobury34",
      "coordinates": {"latitude": 11.3691, "longitude": 6.8105}
    },
    {
      "name": "East Aricworth33",
      "coordinates": {"latitude": 65.6303, "longitude": 46.5948}
    },
    {
      "name": "Lake Meda15",
      "coordinates": {"latitude": 21.8865, "longitude": -111.1041}
    },
    {
      "name": "Bruenfort67",
      "coordinates": {"latitude": -73.0218, "longitude": -2.0304}
    },
    {
      "name": "Kaileyburgh36",
      "coordinates": {"latitude": -83.0314, "longitude": 118.9057}
    },
    {
      "name": "North Reedshire48",
      "coordinates": {"latitude": -5.754, "longitude": 162.9062}
    },
    {
      "name": "Kassulkestad68",
      "coordinates": {"latitude": 19.3117, "longitude": 19.442}
    },
    {
      "name": "Sonyafort16",
      "coordinates": {"latitude": -22.2875, "longitude": -109.5374}
    }
  ];
  late Iterable _markers;

  initialMarker() {
    _markers = Iterable.generate(locationList.length ?? 0, (index) {
      return Marker(
          markerId: MarkerId(locationList[index]['name']),
          position: LatLng(
            locationList[index]['coordinates']['latitude'],
            locationList[index]['coordinates']['longitude'],
          ),
          infoWindow: InfoWindow(title: locationList[index]["name"]));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google bar'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: _initialLocation,
              markers: Set.from(_markers),
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: locationList.length,
                itemBuilder: (BuildContext context, int index) {
                  return singleLocationContainer(index);
                }),
          )
        ],
      ),
    );
  }

  Widget singleLocationContainer(int index) {
    return InkWell(
      onTap: () => _add(index),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("${locationList[index]['name']} " ?? ''),
      ),
    );
  }

  void _add(int index) {
    _markers = Iterable.generate(1, (index) {
      return Marker(
          markerId: MarkerId(locationList[index]['name']),
          position: LatLng(
            locationList[index]['coordinates']['latitude'],
            locationList[index]['coordinates']['longitude'],
          ),
          infoWindow: InfoWindow(title: locationList[index]["name"]));
    });
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(
        locationList[index]['coordinates']['latitude'],
        locationList[index]['coordinates']['longitude'],
      ),
    )));
    setState(() {});

    return;
  }
}
