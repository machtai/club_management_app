import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  final String eventAddress;

  const MapScreen({Key? key, required this.eventAddress}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  LatLng? _currentPosition; // Vị trí hiện tại của người dùng
  late LatLng _destination;
  Set<Polyline> _polylines = {}; // Dữ liệu đường đi

  // Danh sách vị trí cố định
  final Map<String, LatLng> _locations = {
    "Cơ sở 1": LatLng(10.9530222, 106.8022549),
    "Cơ sở 2": LatLng(10.9550497, 106.8020956),
    "Cơ sở 3": LatLng(10.9636286, 106.7881806),
    "Cơ sở 4": LatLng(10.9559638, 106.7981037),
    "Cơ sở 5": LatLng(10.9571446, 106.7889922),
    "Cơ sở Dược": LatLng(10.9627201, 106.7895024),
  };

  @override
  void initState() {
    super.initState();
    _setDestinationFromAddress(widget.eventAddress);
    _getCurrentLocation();
  }

  // Lấy tọa độ vị trí đích từ địa chỉ event
  void _setDestinationFromAddress(String address) {
    if (_locations.containsKey(address)) {
      _destination = _locations[address]!;
    } else {
      _destination = _locations["Cơ sở 1"]!;
    }
  }

  // Lấy vị trí hiện tại của người dùng
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng bật dịch vụ vị trí!')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Quyền truy cập vị trí bị từ chối!')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quyền truy cập vị trí bị từ chối vĩnh viễn!')),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  // Mở Google Maps để chỉ đường
  Future<void> _launchGoogleMaps() async {
    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đang lấy vị trí hiện tại, vui lòng chờ...')),
      );
      return;
    }

    final Uri googleMapsUri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&origin=${_currentPosition!.latitude},${_currentPosition!.longitude}&destination=${_destination.latitude},${_destination.longitude}&travelmode=driving');

    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Không thể mở Google Maps';
    }
  }

  // Hiển thị chỉ đường trong ứng dụng
  void _showRoute() {
    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đang lấy vị trí hiện tại, vui lòng chờ...')),
      );
      return;
    }

    setState(() {
      _polylines = {
        Polyline(
          polylineId: const PolylineId('route'),
          points: [_currentPosition!, _destination],
          color: Colors.blue,
          width: 5,
        ),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉ đường đến ${widget.eventAddress}'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _destination,
                zoom: 15,
              ),
              markers: {
                if (_currentPosition != null)
                  Marker(
                    markerId: const MarkerId('origin'),
                    position: _currentPosition!,
                    infoWindow: const InfoWindow(title: 'Vị trí của bạn'),
                  ),
                Marker(
                  markerId: const MarkerId('destination'),
                  position: _destination,
                  infoWindow: InfoWindow(title: widget.eventAddress),
                ),
              },
              polylines: _polylines,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _launchGoogleMaps,
                    child: const Text('Mở Google Maps'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _showRoute,
                    child: const Text('Chỉ đường'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
