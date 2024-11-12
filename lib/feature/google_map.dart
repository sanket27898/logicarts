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
  bool _showAllMarkers = true;

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

  Set<Marker> _allMarkers = {};
  Set<Marker> _singleMarker = {};

  @override
  void initState() {
    super.initState();
    _initializeMarkers();
  }

  void _initializeMarkers() {
    _allMarkers = locationList.map((location) {
      return Marker(
        markerId: MarkerId(location['name']),
        position: LatLng(
          location['coordinates']['latitude'],
          location['coordinates']['longitude'],
        ),
        infoWindow: InfoWindow(title: location["name"]),
      );
    }).toSet();
  }

  void _add(int index) {
    setState(() {
      _showAllMarkers = false;
      _singleMarker = {
        Marker(
          markerId: MarkerId(locationList[index]['name']),
          position: LatLng(
            locationList[index]['coordinates']['latitude'],
            locationList[index]['coordinates']['longitude'],
          ),
          infoWindow: InfoWindow(title: locationList[index]["name"]),
        ),
      };
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              locationList[index]['coordinates']['latitude'],
              locationList[index]['coordinates']['longitude'],
            ),
            zoom: 10,
          ),
        ),
      );
    });
  }

  void _resetMarkers() {
    setState(() {
      _showAllMarkers = true;
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(_initialLocation),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: _initialLocation,
              markers: _showAllMarkers ? _allMarkers : _singleMarker,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: locationList.length,
              itemBuilder: (BuildContext context, int index) {
                return singleLocationContainer(index);
              },
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _resetMarkers,
            child: const Text('Reset to Show All Markers'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget singleLocationContainer(int index) {
    return InkWell(
      onTap: () => _add(index),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(locationList[index]['name']),
      ),
    );
  }
}
