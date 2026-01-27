import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_data.dart';

class StorageService {
  static const String _savedLocationsKey = 'saved_locations';
  static const String _darkModeKey = 'dark_mode';
  static const String _lastLocationKey = 'last_location';

  // Save locations
  Future<void> saveLocations(List<SavedLocation> locations) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = locations.map((loc) => json.encode(loc.toJson())).toList();
    await prefs.setStringList(_savedLocationsKey, jsonList);
  }

  // Get saved locations
  Future<List<SavedLocation>> getSavedLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_savedLocationsKey) ?? [];
    return jsonList
        .map((jsonStr) => SavedLocation.fromJson(json.decode(jsonStr)))
        .toList();
  }

  // Add location
  Future<void> addLocation(SavedLocation location) async {
    final locations = await getSavedLocations();
    
    // Check if location already exists
    final exists = locations.any((loc) =>
        loc.lat == location.lat && loc.lon == location.lon);
    
    if (!exists) {
      locations.add(location);
      await saveLocations(locations);
    }
  }

  // Remove location
  Future<void> removeLocation(SavedLocation location) async {
    final locations = await getSavedLocations();
    locations.removeWhere((loc) =>
        loc.lat == location.lat && loc.lon == location.lon);
    await saveLocations(locations);
  }

  // Check if location is saved
  Future<bool> isLocationSaved(double lat, double lon) async {
    final locations = await getSavedLocations();
    return locations.any((loc) => loc.lat == lat && loc.lon == lon);
  }

  // Dark mode
  Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, value);
  }

  Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeKey) ?? false;
  }

  // Last location
  Future<void> saveLastLocation(double lat, double lon) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastLocationKey, '$lat,$lon');
  }

  Future<Map<String, double>?> getLastLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final lastLoc = prefs.getString(_lastLocationKey);
    
    if (lastLoc != null) {
      final coords = lastLoc.split(',');
      if (coords.length == 2) {
        return {
          'lat': double.parse(coords[0]),
          'lon': double.parse(coords[1]),
        };
      }
    }
    return null;
  }
}