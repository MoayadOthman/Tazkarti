// ignore_for_file: file_names

class EventModel {
  final String eventId;
  final String categoryId;
  final String eventName;
  final String categoryName;
  final String salePrice;
  final String fullPrice;
  final List<String> eventImages;
  final bool isSale;
  final String productDescription;
  final double latitude; // خط العرض
  final double longitude; // خط الطول
  final String eventDate; // تاريخ الحفل
  final String eventDay; // يوم الحفل
  final String eventTime; // ساعة الحفل
  final String notes; // ملاحظات
  final dynamic createdAt;
  final dynamic updatedAt;

  EventModel({
    required this.eventId,
    required this.categoryId,
    required this.eventName,
    required this.categoryName,
    required this.salePrice,
    required this.fullPrice,
    required this.eventImages,
    required this.isSale,
    required this.productDescription,
    required this.latitude,
    required this.longitude,
    required this.eventDate,
    required this.eventDay,
    required this.eventTime,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  // تحويل كائن EventModel إلى Map (للتخزين في Firestore)
  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'categoryId': categoryId,
      'eventName': eventName,
      'categoryName': categoryName,
      'salePrice': salePrice,
      'fullPrice': fullPrice,
      'eventImages': eventImages,
      'isSale': isSale,
      'productDescription': productDescription,
      'latitude': latitude,
      'longitude': longitude,
      'eventDate': eventDate,
      'eventDay': eventDay,
      'eventTime': eventTime,
      'notes': notes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // إنشاء كائن EventModel من Map
  factory EventModel.fromMap(Map<String, dynamic> json) {
    return EventModel(
      eventId: json['eventId'] ?? '',  // تأكد من إضافة قيمة افتراضية إن لم توجد
      categoryId: json['categoryId'] ?? '',
      eventName: json['eventName'] ?? '',
      categoryName: json['categoryName'] ?? '',
      salePrice: json['salePrice'] ?? '',
      fullPrice: json['fullPrice'] ?? '',
      eventImages: List<String>.from(json['eventImages'] ?? []),  // معالجة القيم null
      isSale: json['isSale'] ?? false,
      productDescription: json['productDescription'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      eventDate: json['eventDate'] ?? '',
      eventDay: json['eventDay'] ?? '',
      eventTime: json['eventTime'] ?? '',
      notes: json['notes'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
