import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class WeatherMapCard extends StatelessWidget {
  final double lat;
  final double lon;
  final bool isDarkMode;

  const WeatherMapCard({
    super.key,
    required this.lat,
    required this.lon,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan judul dan tombol expand
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weather Map',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.open_in_full,
                    size: 20,
                    color: isDarkMode ? Colors.white70 : Colors.blue,
                  ),
                  onPressed: () {
                    // Opsional: Bisa ditambahkan modal sheet untuk expanded map
                    _showExpandedMap(context);
                  },
                ),
              ],
            ),
          ),

          // Peta dalam container dengan tinggi terbatas
          SizedBox(
            height: 200,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(lat, lon),
                  initialZoom: 10.0,
                  interactionOptions: const InteractionOptions(
                    flags: ~InteractiveFlag.doubleTapDragZoom,
                  ),
                ),
                children: [
                  // Layer peta dasar (dark/light mode)
                  TileLayer(
                    urlTemplate: isDarkMode
                        ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                        : 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.weather_dashboard',
                  ),
                  
                  // Marker lokasi saat ini
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(lat, lon),
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 36,
                        ),
                      ),
                    ],
                  ),
                  
                  // Circle untuk menunjukkan area
                  CircleLayer(
                    circles: [
                      CircleMarker(
                        point: LatLng(lat, lon),
                        color: Colors.blue.withOpacity(0.1),
                        borderColor: Colors.blue.withOpacity(0.3),
                        borderStrokeWidth: 1,
                        radius: 5000, // 5km radius
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Footer dengan informasi koordinat
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Coordinates',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? Colors.white70 : Colors.grey.shade600,
                  ),
                ),
                Text(
                  '${lat.toStringAsFixed(4)}, ${lon.toStringAsFixed(4)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showExpandedMap(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Header modal
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Detailed Map',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: isDarkMode ? Colors.white70 : Colors.grey),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              
              // Expanded map
              Expanded(
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(lat, lon),
                    initialZoom: 12.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: isDarkMode
                          ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                          : 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.weather_dashboard',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(lat, lon),
                          width: 50,
                          height: 50,
                          child: const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 44,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}