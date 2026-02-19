import 'package:flutter/material.dart';
import '../models/package.dart';
import '../services/api_service.dart';

class PackageProvider with ChangeNotifier {
  final ApiService _apiService;
  List<Package> _packages = [];
  bool _isLoading = false;

  PackageProvider(this._apiService);

  List<Package> get packages => _packages;
  bool get isLoading => _isLoading;

  Future<void> fetchPackages() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.client.get('/packages');
      if (response.statusCode == 200 && response.data != null) {
          final List<dynamic> list = (response.data is List) ? response.data : (response.data['data'] ?? response.data['packages'] ?? []);
          _packages = list.map((e) => Package.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error fetching packages: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<List<dynamic>> fetchPackageHistory(int packageId) async {
    try {
      // Primary: Use the specialized history endpoint
      final response = await _apiService.client.get('/packages/history/$packageId');
      if (response.statusCode == 200 && response.data != null) {
          return (response.data is List) ? response.data : [];
      }
      
      // Fallback: Fetch all recent package bookings and filter client-side 
      // (in case the route is not available on some environments)
      final fallbackResponse = await _apiService.client.get('/packages/bookingsall', queryParameters: {'limit': 100});
      if (fallbackResponse.statusCode == 200 && fallbackResponse.data != null) {
        final List<dynamic> allBookings = (fallbackResponse.data is List) ? fallbackResponse.data : [];
        final filtered = allBookings.where((b) {
            final pId = b['package_id'] ?? (b['package'] != null ? b['package']['id'] : null);
            return pId.toString() == packageId.toString();
        }).toList();
        return filtered;
      }
    } catch (e) {
      print("Error fetching package history: $e");
    }
    return [];
  }
}
