import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart'; 

class MapSelectionScreen extends StatefulWidget {
  const MapSelectionScreen({super.key});

  @override
  State<MapSelectionScreen> createState() => _MapSelectionScreenState();
}

class _MapSelectionScreenState extends State<MapSelectionScreen> {
  LatLng _currentPosition = const LatLng(40.7128, -74.0060);
  String _draggedAddress = "Fetching your location...";
  bool _isLoading = true;
  GoogleMapController? _mapController; 

  @override
  void initState() {
    super.initState();
    _getUserCurrentLocation();
  }

 
  Future<void> _getUserCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showErrorDialog(
        'Location Services Disabled',
        'Please turn on your GPS to find your current address.',
      );
      setState(() => _isLoading = false);
      return;
    }

   
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showErrorDialog(
          'Permission Denied',
          'We need location permissions to find your address.',
        );
        setState(() => _isLoading = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showErrorDialog(
        'Permission Permanently Denied',
        'Please enable location permissions in your phone settings.',
      );
      setState(() => _isLoading = false);
      return;
    }

    
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    LatLng userLatLng = LatLng(position.latitude, position.longitude);

    setState(() {
      _currentPosition = userLatLng;
      _isLoading = false;
    });

    
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: userLatLng,
            zoom: 17,
          ), 
        ),
      );
    }

    
    _getAddressFromLatLng(userLatLng);
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Color(0xFFFF6B35))),
          ),
        ],
      ),
    );
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    setState(() => _isLoading = true);
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _draggedAddress =
              '${place.street}, ${place.locality}, ${place.administrativeArea}';
        });
      }
    } catch (e) {
      setState(() => _draggedAddress = "Could not find address");
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text(
          'Pin Your Location',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 16,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled:
                true, // Let them tap the crosshairs to re-center
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _mapController =
                  controller; 
            },
            onCameraMove: (CameraPosition position) {
              _currentPosition = position.target;
            },
            onCameraIdle: () {
              
              if (!_isLoading) {
                _getAddressFromLatLng(_currentPosition);
              }
            },
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 35.0),
            child: Icon(Icons.location_on, size: 40, color: Color(0xFFFF6B35)),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isLoading ? 'Fetching location...' : _draggedAddress,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: _isLoading
                          ? null
                          : () {
                              Navigator.pop(context, _draggedAddress);
                            },
                      child: const Text(
                        'Confirm Address',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
