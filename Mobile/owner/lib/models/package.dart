class Package {
  final int id;
  final String title;
  final String? description;
  final double price;
  final String? theme;
  final int maxStayDays;
  final List<String> imageUrls;
  final String? foodIncluded;
  final String? complimentary;
  final String? bookingType;
  final String? roomTypes;
  final int defaultAdults;
  final int defaultChildren;
  final String? foodTiming;

  Package({
    required this.id,
    required this.title,
    this.description,
    required this.price,
    this.theme,
    this.maxStayDays = 1,
    required this.imageUrls,
    this.foodIncluded,
    this.complimentary,
    this.bookingType,
    this.roomTypes,
    this.defaultAdults = 2,
    this.defaultChildren = 0,
    this.foodTiming,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'],
      price: (json['price'] ?? 0).toDouble(),
      theme: json['theme'],
      maxStayDays: json['max_stay_days'] ?? 1,
      imageUrls: (json['images'] as List? ?? []).map((e) => e['image_url'].toString()).toList(),
      foodIncluded: json['food_included'],
      complimentary: json['complimentary'],
      bookingType: json['booking_type'],
      roomTypes: json['room_types'],
      defaultAdults: json['default_adults'] ?? 2,
      defaultChildren: json['default_children'] ?? 0,
      foodTiming: json['food_timing'],
    );
  }
}
