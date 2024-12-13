import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _ordersCollection =
      FirebaseFirestore.instance.collection('orders');

  Future updateUserData(String name, String username, String email, int age) async {
    return await _usersCollection.doc(uid).set({
      'name': name,
      'username': username,
      'email': email,
      'age': age,
    });
  }

  Future<String> addOrder({
  required String productName,
  required int productPrice,
  required int productSize,
  required String shippingType,
  required String paymentMethod,
  required String? paymentNumber,
  required String phoneNumber,
  required String postalCode,
  String? message,
  required String address, // Accept address as a parameter
}) async {
  // Add the order document and get its ID
  DocumentReference orderRef = await _ordersCollection.add({
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
    'address': address, // Store address in Firestore
    'orderDate': FieldValue.serverTimestamp(),
  });

  String orderId = orderRef.id;

  // Update the user's document to include this order ID
  await _usersCollection.doc(uid).update({
    'orderIds': FieldValue.arrayUnion([orderId]), // Add orderId to an array
  });

  return orderId;
}

}