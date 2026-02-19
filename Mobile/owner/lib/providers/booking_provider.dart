import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/booking.dart';
import '../models/booking_details.dart';
import '../models/guest_history.dart';

class BookingProvider with ChangeNotifier {
  final ApiService _apiService;
  List<Booking> _bookings = [];
  bool _isLoading = false;

  BookingProvider(this._apiService);

  List<Booking> get bookings => _bookings;
  bool get isLoading => _isLoading;

  BookingDetails? _selectedBookingDetails;
  BookingDetails? get selectedBookingDetails => _selectedBookingDetails;

  Future<void> fetchBookingDetails(int id, bool isPackage) async {
    _isLoading = true;
    _selectedBookingDetails = null;
    notifyListeners();

    try {
      final response = await _apiService.client.get('/bookings/details/$id', queryParameters: {'is_package': isPackage});
      if (response.statusCode == 200 && response.data != null) {
        _selectedBookingDetails = BookingDetails.fromJson(response.data);
      }
    } catch (e) {
      print("Error fetching booking details: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBookings() async {
    _isLoading = true;
    notifyListeners();

    try {
      List<Booking> allBookings = [];

      // 1. Fetch Regular Bookings
      try {
        final response = await _apiService.client.get('/bookings', queryParameters: {'limit': 50});
        if (response.statusCode == 200 && response.data != null) {
          final List<dynamic> list = (response.data is List) 
              ? response.data 
              : (response.data['bookings'] ?? []);
          allBookings.addAll(list.map((e) => Booking.fromJson(e)).toList());
        }
      } catch (e) {
        print("Error fetching regular bookings: $e");
      }

      // 2. Fetch Package Bookings
      try {
        final pkgResponse = await _apiService.client.get('/packages/bookingsall', queryParameters: {'limit': 50});
        if (pkgResponse.statusCode == 200 && pkgResponse.data != null) {
          final List<dynamic> list = (pkgResponse.data is List) ? pkgResponse.data : [];
          allBookings.addAll(list.map((e) {
            // Ensure is_package flag is true for package bookings
            if (e is Map<String, dynamic>) {
              e['is_package'] = true;
              
              // Flatten nested package rooms structure: PackageBookingRoom -> Room
              if (e['rooms'] != null && e['rooms'] is List) {
                try {
                  final rawList = e['rooms'] as List;
                  final flattened = rawList.map((r) {
                    if (r is Map && r['room'] != null && r['room'] is Map) {
                       return r['room'];
                    }
                    return r;
                  }).toList();
                  e['rooms'] = flattened;
                } catch (err) {
                  print("Error flattening package rooms: $err");
                }
              }
            }
            return Booking.fromJson(e);
          }).toList());
        }
      } catch (e) {
        print("Error fetching package bookings: $e");
      }

      // 3. Merge and Sort (Newest First by ID)
      // 3. Merge and Sort (Newest First by CreatedAt, then ID)
      allBookings.sort((a, b) {
        if (a.createdAt != null && b.createdAt != null) {
          return b.createdAt!.compareTo(a.createdAt!);
        } else if (a.createdAt != null) {
          return -1; 
        } else if (b.createdAt != null) {
          return 1;
        }
        return b.id.compareTo(a.id);
      });
      _bookings = allBookings;
      
    } catch (e) {
      print("Error in fetchBookings flow: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Booking>> fetchRoomHistory(int roomId) async {
    try {
      final response = await _apiService.client.get('/bookings', queryParameters: {'room_id': roomId, 'limit': 20});
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> list = (response.data is List) ? response.data : (response.data['bookings'] ?? []);
        return list.map((e) => Booking.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error fetching room history: $e");
    }
    return [];
  }

  Future<GuestProfile?> fetchGuestProfile({String? mobile, String? email, String? name}) async {
    try {
      final Map<String, dynamic> params = {};
      if (mobile != null && mobile.isNotEmpty) params['guest_mobile'] = mobile;
      if (email != null && email.isNotEmpty) params['guest_email'] = email;
      if (name != null && name.isNotEmpty) params['guest_name'] = name;

      if (params.isEmpty) return null;

      final response = await _apiService.client.get('/reports/guest-profile', queryParameters: params);
      if (response.statusCode == 200 && response.data != null) {
        return GuestProfile.fromJson(response.data);
      }
    } catch (e) {
      print("Error fetching guest profile: $e");
    }
    return null;
  }
}
