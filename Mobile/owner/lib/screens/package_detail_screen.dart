import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/package.dart';
import '../providers/package_provider.dart';
import '../config/constants.dart';

class PackageDetailScreen extends StatefulWidget {
  final Package package;

  const PackageDetailScreen({super.key, required this.package});

  @override
  State<PackageDetailScreen> createState() => _PackageDetailScreenState();
}

class _PackageDetailScreenState extends State<PackageDetailScreen> {
  List<dynamic> _history = [];
  bool _isLoadingHistory = true;
  final NumberFormat _currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0, locale: 'en_IN');
  final DateFormat _dateFormat = DateFormat('dd MMM yyyy');

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    final provider = Provider.of<PackageProvider>(context, listen: false);
    final data = await provider.fetchPackageHistory(widget.package.id);
    if (mounted) {
      setState(() {
        _history = data;
        _isLoadingHistory = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final package = widget.package;
    return Scaffold(
      appBar: AppBar(
        title: Text(package.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Slider or Single Image
            if (package.imageUrls.isNotEmpty)
              SizedBox(
                height: 250,
                child: PageView.builder(
                  itemCount: package.imageUrls.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      _getImageUrl(package.imageUrls[index]),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey)),
                    );
                  },
                ),
              )
            else
              Container(
                height: 200,
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.card_giftcard, size: 64, color: Colors.white)),
              ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          package.title,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _currencyFormat.format(package.price),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                        if (package.theme != null)
                            Chip(
                            label: Text(package.theme!),
                            backgroundColor: Colors.purple.shade50,
                            labelStyle: const TextStyle(color: Colors.purple),
                            ),
                        Chip(
                            label: Text(package.bookingType == 'whole_property' ? 'Whole Property' : (package.roomTypes ?? 'Room Based')),
                            backgroundColor: Colors.blue.shade50,
                            labelStyle: const TextStyle(color: Colors.blue),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  const Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(package.description ?? "No description available.", style: const TextStyle(color: Colors.black87, height: 1.4)),
                  
                  const SizedBox(height: 16),
                  
                  // Details Grid
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                         _buildDetailRow(Icons.calendar_today, "Max Stay", "${package.maxStayDays} Days"),
                         _buildDetailRow(Icons.people, "Occupancy", "${package.defaultAdults} Adl, ${package.defaultChildren} Chd"),
                         if (package.foodIncluded != null) _buildDetailRow(Icons.restaurant, "Food Included", _formatFoodInfo(package.foodIncluded!, package.foodTiming)),
                         if (package.complimentary != null) _buildDetailRow(Icons.redeem, "Complimentary", package.complimentary!),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text("Booking History", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  _buildHistorySection(),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorySection() {
    if (_isLoadingHistory) {
        return const Center(child: CircularProgressIndicator());
    }
    if (_history.isEmpty) {
        return Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
            child: const Text("No booking history for this package", style: TextStyle(color: Colors.grey)),
        );
    }
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _history.length,
        itemBuilder: (context, index) {
            final booking = _history[index];
            final status = booking['status'] ?? 'Unknown';
            final color = _getStatusColor(status);
            return Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                        backgroundColor: color.withOpacity(0.1),
                        child: Icon(Icons.bookmark, color: color, size: 20),
                    ),
                    title: Text(booking['guest_name'] ?? 'Guest', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                             Text("${booking['check_in']}  →  ${booking['check_out']}", style: const TextStyle(fontSize: 12)),
                             Text("Ref: ${booking['display_id'] ?? booking['id']}", style: TextStyle(fontSize: 11, color: Colors.grey.shade600))
                        ],
                    ),
                    trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                            Text(_currencyFormat.format(booking['total_amount'] ?? 0), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            Text(status, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold)),
                        ],
                    ),
                ),
            );
        },
    );
  }

  Color _getStatusColor(String status) {
      switch (status.toLowerCase()) {
          case 'checked-in': return Colors.green;
          case 'booked': return Colors.blue;
          case 'cancelled': return Colors.red;
          case 'checked-out': return Colors.grey;
          default: return Colors.orange;
      }
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    String baseUrl = AppConstants.baseUrl;
    if (baseUrl.endsWith('/api')) baseUrl = baseUrl.replaceAll('/api', '');
    if (path.startsWith('/')) return '$baseUrl$path';
    return '$baseUrl/$path';
  }

  String _formatFoodInfo(String included, String? timingJson) {
    if (timingJson == null || timingJson.isEmpty) return included;
    try {
       final Map<String, dynamic> timings = jsonDecode(timingJson);
       List<String> parts = [];
       List<String> includedList = included.split(',').map((e) => e.trim()).toList();
       
       for (var meal in includedList) {
           var key = meal;
           if (!timings.containsKey(key)) {
               for (var k in timings.keys) {
                   if (k.toLowerCase() == meal.toLowerCase()) {
                       key = k;
                       break;
                   }
               }
           }
           
           if (timings.containsKey(key) && timings[key] is Map) {
               String time = timings[key]['time'] ?? '';
               if (time.isNotEmpty) {
                   parts.add("$meal ($time)");
               } else {
                   parts.add(meal);
               }
           } else {
               parts.add(meal);
           }
       }
       if (parts.isEmpty) return included;
       return parts.join(', ');
    } catch (e) {
       return included; 
    }
  }
}
