import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class WeatherMapCard extends StatefulWidget {
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
  State<WeatherMapCard> createState() => _WeatherMapCardState();
}

class _WeatherMapCardState extends State<WeatherMapCard> {
  // ✅ OPTIMASI: Lazy loading - map hanya di-load saat user expand
  bool _isExpanded = false;
  
  MapController? _mapController;
  LatLng? _selectedLocation;
  double _currentZoom = 10.0;
  
  // Mock data for major cities
  final List<Map<String, dynamic>> _majorCities = [
    {
      'name': 'Jakarta',
      'lat': -6.2088,
      'lon': 106.8456,
      'temp': 31.0,
      'condition': 'Clouds',
      'humidity': 75,
    },
    {
      'name': 'Surabaya',
      'lat': -7.2575,
      'lon': 112.7521,
      'temp': 28.0,
      'condition': 'Clear',
      'humidity': 68,
    },
    {
      'name': 'Bandung',
      'lat': -6.9175,
      'lon': 107.6191,
      'temp': 26.0,
      'condition': 'Rain',
      'humidity': 82,
    },
    {
      'name': 'Medan',
      'lat': 3.5952,
      'lon': 98.6722,
      'temp': 30.0,
      'condition': 'Clouds',
      'humidity': 78,
    },
    {
      'name': 'Semarang',
      'lat': -6.9667,
      'lon': 110.4167,
      'temp': 29.0,
      'condition': 'Mist',
      'humidity': 80,
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedLocation = LatLng(widget.lat, widget.lon);
  }

  // ✅ OPTIMASI: Dispose map controller
  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Color _getConditionColor(String condition) {
    const colors = {
      'Clear': Color(0xFFF59E0B),
      'Clouds': Color(0xFF6B7280),
      'Rain': Color(0xFF0EA5E9),
      'Thunderstorm': Color(0xFF8B5CF6),
      'Snow': Color(0xFF93C5FD),
      'Mist': Color(0xFFA5B4FC),
      'Drizzle': Color(0xFF60A5FA),
      'Haze': Color(0xFFD1D5DB),
      'Fog': Color(0xFF9CA3AF),
    };
    return colors[condition] ?? const Color(0xFF3B82F6);
  }

  String _getConditionIcon(String condition) {
    const icons = {
      'Clear': '☀️',
      'Clouds': '☁️',
      'Rain': '🌧️',
      'Thunderstorm': '⛈️',
      'Snow': '❄️',
      'Mist': '🌫️',
      'Drizzle': '🌦️',
      'Haze': '🌁',
      'Fog': '🌫️',
    };
    return icons[condition] ?? '🌤️';
  }

  // ✅ OPTIMASI: Simplified marker (no shadow untuk performa)
  Widget _buildCustomMarker(Color color, {bool isSelected = false}) {
    return Container(
      width: isSelected ? 24 : 20,
      height: isSelected ? 24 : 20,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Icon(
        Icons.location_on,
        color: Colors.white,
        size: isSelected ? 12 : 10,
      ),
    );
  }

  void _recenterMap() {
    if (_isExpanded && _mapController != null) {
      _mapController!.move(_selectedLocation!, _currentZoom);
    }
  }

  void _selectCity(Map<String, dynamic> city) {
    setState(() {
      _selectedLocation = LatLng(city['lat'], city['lon']);
      _currentZoom = 12.0;
    });
    if (_isExpanded && _mapController != null) {
      _mapController!.move(_selectedLocation!, _currentZoom);
    }
  }

  // ✅ OPTIMASI: Initialize map controller saat expand
  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded && _mapController == null) {
        _mapController = MapController();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isDarkMode ? const Color(0xFF242936) : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black87;
    final subtleColor = widget.isDarkMode ? Colors.white70 : Colors.grey.shade600;
    final cardBg = widget.isDarkMode ? const Color(0xFF1e293b) : const Color(0xFFF8F9FA);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3b82f6), Color(0xFF06b6d4)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.map,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Weather Map',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              // ✅ OPTIMASI: Toggle button untuk show/hide map
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _toggleExpand,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3b82f6).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _isExpanded ? 'Hide Map' : 'Show Map',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF3b82f6),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          _isExpanded ? Icons.expand_less : Icons.expand_more,
                          color: const Color(0xFF3b82f6),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 4),
          
          Text(
            _isExpanded 
                ? 'Interactive map showing weather across Indonesia'
                : 'Tap "Show Map" to view interactive weather map',
            style: TextStyle(
              fontSize: 13,
              color: subtleColor,
            ),
          ),

          const SizedBox(height: 20),

          // ✅ OPTIMASI: Cities List (always visible, lightweight)
          _buildCitiesList(textColor, subtleColor, cardBg),

          // ✅ OPTIMASI: Map (lazy loaded - only when expanded)
          if (_isExpanded && _mapController != null) ...[
            const SizedBox(height: 20),
            _buildMapContainer(bgColor, subtleColor),
          ],

          const SizedBox(height: 20),

          // Legend
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: widget.isDarkMode
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.05),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Weather Conditions',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  children: ['Clear', 'Clouds', 'Rain', 'Thunderstorm', 'Snow', 'Mist']
                      .map((condition) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: _getConditionColor(condition),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${_getConditionIcon(condition)} $condition',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: subtleColor,
                                ),
                              ),
                            ],
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ OPTIMASI: Map dengan RepaintBoundary
  Widget _buildMapContainer(Color bgColor, Color subtleColor) {
    return RepaintBoundary(
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.isDarkMode
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.05),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _selectedLocation!,
                  initialZoom: _currentZoom,
                  // ✅ OPTIMASI: Limit zoom untuk performa
                  minZoom: 5,
                  maxZoom: 15,
                  onPositionChanged: (position, hasGesture) {
                    if (hasGesture && mounted) {
                      setState(() {
                        _currentZoom = position.zoom ?? _currentZoom;
                      });
                    }
                  },
                ),
                children: [
                  // ✅ OPTIMASI: Tile layer dengan cache
                  TileLayer(
                    urlTemplate: widget.isDarkMode
                        ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                        : 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.weather_dashboard',
                    // ✅ OPTIMASI: Keep tiles in memory
                    keepBuffer: 2,
                    maxNativeZoom: 15,
                  ),
                  
                  // ✅ OPTIMASI: Simplified circle (no gradient)
                  CircleLayer(
                    circles: [
                      CircleMarker(
                        point: _selectedLocation!,
                        color: const Color(0xFF3B82F6).withOpacity(0.15),
                        borderColor: const Color(0xFF3B82F6).withOpacity(0.4),
                        borderStrokeWidth: 2,
                        radius: 5000,
                        useRadiusInMeter: true,
                      ),
                    ],
                  ),
                  
                  // ✅ OPTIMASI: Reduced markers
                  MarkerLayer(
                    markers: [
                      // Selected location marker
                      Marker(
                        point: _selectedLocation!,
                        width: 28,
                        height: 28,
                        child: _buildCustomMarker(
                          const Color(0xFF3B82F6),
                          isSelected: true,
                        ),
                      ),
                      // Other cities
                      ..._majorCities.map((city) {
                        final cityLatLng = LatLng(city['lat'], city['lon']);
                        if (cityLatLng == _selectedLocation) return null;
                        
                        return Marker(
                          point: cityLatLng,
                          width: 24,
                          height: 24,
                          child: GestureDetector(
                            onTap: () => _selectCity(city),
                            child: _buildCustomMarker(
                              _getConditionColor(city['condition']),
                            ),
                          ),
                        );
                      }).whereType<Marker>().toList(),
                    ],
                  ),
                ],
              ),
              
              // Location label overlay
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: bgColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: widget.isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : Colors.black.withOpacity(0.05),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('📍', style: TextStyle(fontSize: 12)),
                          const SizedBox(width: 6),
                          Text(
                            _majorCities.firstWhere(
                              (city) => LatLng(city['lat'], city['lon']) == _selectedLocation,
                              orElse: () => {'name': 'Current Location'},
                            )['name'],
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: widget.isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Indonesia (ID)',
                        style: TextStyle(
                          fontSize: 10,
                          color: subtleColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Recenter button
              Positioned(
                bottom: 16,
                right: 16,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _recenterMap,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: bgColor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: widget.isDarkMode
                              ? Colors.white.withOpacity(0.1)
                              : Colors.black.withOpacity(0.05),
                        ),
                      ),
                      child: Icon(
                        Icons.my_location,
                        size: 18,
                        color: subtleColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ OPTIMASI: Lightweight cities list (always visible)
  Widget _buildCitiesList(Color textColor, Color subtleColor, Color cardBg) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.location_city, color: const Color(0xFF3b82f6), size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Major Cities',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF3b82f6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_majorCities.length}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3b82f6),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // ✅ OPTIMASI: Use Column instead of ListView for better performance
        Column(
          children: _majorCities.map((city) {
            final cityLatLng = LatLng(city['lat'], city['lon']);
            final isSelected = cityLatLng == _selectedLocation;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _selectCity(city),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF3b82f6).withOpacity(0.1)
                          : cardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF3b82f6).withOpacity(0.3)
                            : widget.isDarkMode
                                ? Colors.white.withOpacity(0.05)
                                : Colors.black.withOpacity(0.05),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                city['name'],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    _getConditionIcon(city['condition']),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      city['condition'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: subtleColor,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${city['temp'].toStringAsFixed(1)}°C',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            Text(
                              '💧 ${city['humidity']}%',
                              style: TextStyle(
                                fontSize: 10,
                                color: subtleColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}