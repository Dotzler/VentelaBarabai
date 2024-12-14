import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  
  final String uid;
  DatabaseService({ required this.uid });

  final CollectionReference  _usersCollection = FirebaseFirestore.instance.collection('users');

  Future updateUserData(String name, String username, String email, int age) async {
    return await _usersCollection.doc(uid).set({
      'name': name,
      'username': username,
      'email' : email,
      'age' : age,
    });
  }
}