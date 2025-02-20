class ReservationModel {
  final String userId;
  final String eventId;
  final String eventName;
  final String reservationDate;
  final String ticketPrice;
  final String userName;
  final String userPhone;
  final String paymentMethod;
  final String paymentStatus;

  ReservationModel({
    required this.userId,
    required this.eventId,
    required this.eventName,
    required this.reservationDate,
    required this.ticketPrice,
    required this.userName,
    required this.userPhone,
    required this.paymentMethod,
    required this.paymentStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'eventId': eventId,
      'eventName': eventName,
      'reservationDate': reservationDate,
      'ticketPrice': ticketPrice,
      'userName': userName,
      'userPhone': userPhone,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
    };
  }

  factory ReservationModel.fromMap(Map<String, dynamic> map) {
    return ReservationModel(
      userId: map['userId'],
      eventId: map['eventId'],
      eventName: map['eventName'],
      reservationDate: map['reservationDate'],
      ticketPrice: map['ticketPrice'],
      userName: map['userName'],
      userPhone: map['userPhone'],
      paymentMethod: map['paymentMethod'],
      paymentStatus: map['paymentStatus'],
    );
  }
}
