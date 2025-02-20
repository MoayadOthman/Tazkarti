class UserModel {
  final String uId;
  final String username;
  final String email;
  final String phone;
  final String userImg;
  final String country;
  final String userAddress;
  final String city;
  final String street;
  final bool isAdmin;
  final bool isActive;
  final dynamic createdOn;
  final String carModel;
  final String carColor;
  final String carNumber;


  UserModel( {
    required this.uId,
    required this.username,
    required this.email,
    required this.phone,
    required this.userImg,
    required this.country,
    required this.userAddress,
    required this.city,
    required this.street,
    required this.isAdmin,
    required this.isActive,
    required this.createdOn,
    required  this.carModel,
    required this.carColor,
    required this.carNumber,
  });

  // Factory method to create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uId: json['uId'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      userImg: json['userImg'] as String,
      country: json['country'] as String,
      userAddress: json['userAddress'] as String,
      city: json['city'] as String,
      street: json['street'] as String,
      isAdmin: json['isAdmin'] as bool,
      isActive: json['isActive'] as bool, // تصحيح هنا أيضًا
      createdOn: json['createdOn'],
      carModel: json['carModel'] as String,
      carColor:  json['carColor'] as String,
      carNumber:  json['carNumber'] as String, // dynamic, could be a DateTime or other type
    );
  }

  // Method to convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
       'uId': uId,
      'username': username,
      'email': email,
      'phone': phone,
      'userImg': userImg,
      'country': country,
      'userAddress': userAddress,
      'city':city,
      'street': street,
      'isAdmin': isAdmin,
      'isActive': isActive, // تصحيح هنا أيضًا
      'createdOn': createdOn,
      'carModel':carModel,
      'carColor':carColor,
      'carNumber':carNumber

    };
  }
}
