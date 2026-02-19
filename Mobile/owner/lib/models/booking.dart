class Booking {
  final int id;
  final String bookingReference;
  final String guestName;
  final String checkInDate;
  final String checkOutDate;
  final String status;
  final String amount;
  final String roomNumber;
  final bool isPackage; 
  final DateTime? createdAt; // Added

  final String roomType;
  final int adults;
  final int children;
  final String source;
  final String packageName;

  Booking({
    required this.id,
    required this.bookingReference,
    required this.guestName,
    required this.checkInDate,
    required this.checkOutDate,
    required this.status,
    required this.amount,
    required this.roomNumber,
    required this.isPackage,
    this.createdAt,
    this.roomType = 'Standard',
    this.adults = 2,
    this.children = 0,
    this.source = 'Direct',
    this.packageName = '',
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    // Calculate amount from total_amount or fallback to room prices
    double calculatedAmount = 0.0;
    
    if (json['total_amount'] != null && json['total_amount'] > 0) {
      if (json['total_amount'] is String) {
        calculatedAmount = double.tryParse(json['total_amount']) ?? 0.0;
      } else {
        calculatedAmount = (json['total_amount'] as num).toDouble();
      }
    } else if (json['rooms'] != null && (json['rooms'] is List) && (json['rooms'] as List).isNotEmpty) {
      // Fallback: Calculate from room prices and stay duration
      try {
        final rooms = json['rooms'] as List;
        DateTime? checkIn;
        DateTime? checkOut;
        
        try {
          checkIn = DateTime.tryParse(json['check_in'] ?? '');
          checkOut = DateTime.tryParse(json['check_out'] ?? '');
        } catch (e) {
             print("Date parsing error: $e");
        }
        
        if (checkIn != null && checkOut != null) {
          final nights = checkOut.difference(checkIn).inDays;
          for (var room in rooms) {
            final roomPrice = (room['price'] ?? 0) as num;
            calculatedAmount += roomPrice.toDouble() * nights;
          }
        }
      } catch (e) {
        print('Error calculating booking amount: $e');
      }
    }

    String rType = 'Standard';
    if (json['rooms'] != null && (json['rooms'] is List) && (json['rooms'] as List).isNotEmpty) {
        // Safe access
        if (json['rooms'][0] is Map) {
             rType = json['rooms'][0]['type'] ?? 'Standard';
        }
    }
    
    // Extract Package Name
    String pkgName = json['package_name'] ?? '';
    if (json['package'] != null) {
      if (json['package'] is Map) {
         pkgName = json['package']['title'] ?? json['package']['name'] ?? pkgName;
      } else if (json['package'] is String) {
         pkgName = json['package'];
      }
    }

    return Booking(
      id: json['id'] ?? 0,
      bookingReference: json['display_id'] ?? 'Ref: ${json['id']}',
      guestName: json['guest_name'] ?? 'Unknown',
      checkInDate: json['check_in'] != null ? json['check_in'].toString() : '',
      checkOutDate: json['check_out'] != null ? json['check_out'].toString() : '',
      status: json['status'] ?? 'Pending',
      amount: calculatedAmount > 0 ? calculatedAmount.toStringAsFixed(2) : '0',
      roomNumber: (json['rooms'] != null && (json['rooms'] is List) && (json['rooms'] as List).isNotEmpty && json['rooms'][0] is Map && json['rooms'][0]['number'] != null) 
          ? json['rooms'][0]['number'].toString() 
          : '-',
      isPackage: json['is_package'] ?? (json['package_id'] != null) ?? false,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      roomType: rType,
      adults: json['adults'] ?? 2,
      children: json['children'] ?? 0,
      source: json['source'] ?? 'Direct',
      packageName: pkgName,
    );
  }
}
