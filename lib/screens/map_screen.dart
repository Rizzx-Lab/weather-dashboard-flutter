import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapScreen extends StatefulWidget {
  final double lat;
  final double lon;

  const MapScreen({
    super.key,
    required this.lat,
    required this.lon,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  String _currentLayer = 'street';
  bool _showWeatherLayer = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Map'),
        actions: [
          IconButton(
            icon: Icon(_showWeatherLayer ? Icons.cloud : Icons.cloud_off),
            onPressed: () {
              setState(() {
                _showWeatherLayer = !_showWeatherLayer;
              });
            },
            tooltip: 'Toggle Weather Layer',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.layers),
            onSelected: (value) {
              setState(() {
                _currentLayer = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'street',
                child: Row(
                  children: [
                    Icon(Icons.map),
                    SizedBox(width: 8),
                    Text('Street Map'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'satellite',
                child: Row(
                  children: [
                    Icon(Icons.satellite),
                    SizedBox(width: 8),
                    Text('Satellite'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'dark',
                child: Row(
                  children: [
                    Icon(Icons.dark_mode),
                    SizedBox(width: 8),
                    Text('Dark Mode'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(widget.lat, widget.lon),
          initialZoom: 11.0,
          minZoom: 3.0,
          maxZoom: 18.0,
        ),
        children: [
          // Base map layer
          TileLayer(
            urlTemplate: _getMapUrl(),
            userAgentPackageName: 'com.example.weather_dashboard',
            maxNativeZoom: 19,
            maxZoom: 19,
          ),
          // Weather overlay layer (optional)
          if (_showWeatherLayer)
            TileLayer(
              urlTemplate:
                  'https://tile.openweathermap.org/map/temp_new/{z}/{x}/{y}.png?appid=${_getWeatherApiKey()}',
              userAgentPackageName: 'com.example.weather_dashboard',
              maxNativeZoom: 19,
              maxZoom: 19,
              tileBuilder: (context, widget, tile) {
                return Opacity(
                  opacity: 0.6,
                  child: widget,
                );
              },
            ),
          // Location marker
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(widget.lat, widget.lon),
                width: 80,
                height: 80,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 32,
                      ),
                    ),
                    Container(
                      width: 2,
                      height: 10,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: 'zoom_in',
            onPressed: () {
              _mapController.move(
                _mapController.camera.center,
                _mapController.camera.zoom + 1,
              );
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'zoom_out',
            onPressed: () {
              _mapController.move(
                _mapController.camera.center,
                _mapController.camera.zoom - 1,
              );
            },
            child: const Icon(Icons.remove),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'my_location',
            onPressed: () {
              _mapController.move(
                LatLng(widget.lat, widget.lon),
                11.0,
              );
            },
            child: const Icon(Icons.my_location),
          ),
        ],
      ),
    );
  }

  String _getMapUrl() {
    switch (_currentLayer) {
      case 'satellite':
        return 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';
      case 'dark':
        return 'https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png';
      default:
        return 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
    }
  }

  String _getWeatherApiKey() {
    return dotenv.env['WEATHER_API_KEY'] ?? '';
  }
}