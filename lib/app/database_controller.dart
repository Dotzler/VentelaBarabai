import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  
  final String uid;
  DatabaseService({ required this.uid });

  final CollectionReference  _usersCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference _ordersCollection = FirebaseFirestore.instance.collection('orders');

  Future updateUserData(String name, String username, String email, int age) async {
    return await _usersCollection.doc(uid).set({
      'name': name,
      'username': username,
      'email' : email,
      'age' : age,
    });
  }

  Future addOrder({
  required String productName,
  required int productPrice,
  required int productSize,
  required String shippingType,
  required String paymentMethod,
  required String? paymentNumber,
  required String phoneNumber,
  required String postalCode,
  String? message,
  required double latitude,
  required double longitude,
}) async {
  return await _ordersCollection.add({
    'uid': uid,
    'productName': productName,
    'productPrice': productPrice,
    'productSize': productSize,
    'shippingType': shippingType,
    'paymentMethod': paymentMethod,
    'paymentNumber': paymentNumber ?? '',
    'phoneNumber': phoneNumber,
    'postalCode': postalCode,
    'message': message ?? '',
    'latitude': latitude,
    'longitude': longitude,
    'orderDate': FieldValue.serverTimestamp(),
  });
}

}