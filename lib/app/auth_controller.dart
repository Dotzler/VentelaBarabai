import 'package:VentelaBarabai/app/modules/AdminPage/views/admin_page_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:VentelaBarabai/app/modules/login_page/views/login_view.dart';
import 'package:VentelaBarabai/app/modules/store_page/views/store_view.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final storage = GetStorage();
  RxBool isLoading = false.obs;
  RxMap<String, dynamic> userProfile = <String, dynamic>{}.obs;

  // State untuk visibilitas password
  RxBool isPasswordHidden = true.obs;

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Check login status
  Future<void> checkLoginStatus() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      if (isLoggedIn) {
        await fetchUserProfile();
        Get.offAll(() => StorePage());
      } else {
        Get.offAll(() => LoginPage());
      }
    });
  }

  // Login function
Future<void> loginUser(String email, String password) async {
  try {
    isLoading.value = true;

    // Attempt to sign in the user
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;

    if (user != null) {
        // Jika email adalah email admin
        if (email == "adminbarabai@sneakers.zone" && password == "admin123") {
          Get.snackbar(
            'Berhasil',
            'Login sebagai Admin berhasil!',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          Get.offAll(() => AdminPage());
        } else {
          // Ambil data profil pengguna dari Firestore
          DocumentSnapshot userData = await _firestore.collection('users').doc(user.uid).get();
          userProfile.value = userData.data() as Map<String, dynamic>;

          Get.snackbar(
            'Berhasil',
            'Login sebagai Pengguna berhasil!',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          Get.offAll(() => StorePage());
        }
      }
  } on FirebaseAuthException catch (e) {
    String errorMessage;

    // Handle specific Firebase Auth exceptions
    switch (e.code) {
      case "user-not-found":
        errorMessage = "User not found. Please register or check your credentials.";
        break;
      case "wrong-password":
        errorMessage = "Incorrect password. Please try again.";
        break;
      case "invalid-email":
        errorMessage = "Invalid email format.";
        break;
      case "user-disabled":
        errorMessage = "This account has been disabled. Contact support.";
        break;
      default:
        errorMessage = "An unexpected error occurred. Please try again.";
        storage.write('pendingLogin', {'email': email, 'password': password});
    }

    Get.snackbar(
      'Login Failed',
      errorMessage,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );

  } finally {
    isLoading.value = false;
  }
}

// Reset Password
  Future<void> sendPasswordResetEmail(String email) async {
    if (email.isEmpty) {
      Get.snackbar(
        'Error',
        'Email tidak boleh kosong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar(
        'Success',
        'Link reset password telah dikirim ke email Anda',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.back(); // Kembali ke halaman login setelah berhasil
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengirim email reset password. Silakan coba lagi.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Register function
  Future<void> registerUser(String email, String password) async {
    try {
      isLoading.value = true;
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': 'none',
          'username': 'none',
          'email': email,
          'age': 0,
        });
        Get.snackbar('Berhasil', 'Pendaftaran berhasil!', backgroundColor: Colors.green, colorText: Colors.white);
        Get.offAll(() => LoginPage());
      }
    } on FirebaseAuthException catch (e) {
      // Save registration data locally if there's no internet
      storage.write('pendingRegister', {'email': email, 'password': password});
      String errorMessage;
      switch (e.code) {
        case "email-already-in-use":
          errorMessage = "Email sudah digunakan. Gunakan email lain.";
          break;
        case "weak-password":
          errorMessage = "Kata sandi terlalu lemah.";
          break;
        case "invalid-email":
          errorMessage = "Format email tidak valid.";
          break;
        default:
          errorMessage = "Terjadi kesalahan. Silakan coba lagi.";
      }
      Get.snackbar('Error', errorMessage, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch user profile data
  Future<void> fetchUserProfile() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        userProfile.value = userDoc.data() as Map<String, dynamic>;
      }
    } catch (error) {
      Get.snackbar('Error', 'Gagal memuat data profil: $error', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Update user profile
  Future<void> updateUserProfile(String name, String username, String email, int age) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'name': name,
          'username': username,
          'email': email,
          'age': age,
        });
        userProfile['name'] = name;
        userProfile['username'] = username;
        userProfile['email'] = email;
        userProfile['age'] = age;
        Get.snackbar('Berhasil', 'Profil berhasil diperbarui!', backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (error) {
      Get.snackbar('Error', 'Gagal memperbarui profil: $error', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    Get.offAll(() => LoginPage());
  }

  // Relogin function
  Future<void> relogin() async {
    try {
      final storedLogin = storage.read('pendingLogin');
      if (storedLogin != null) {
        final storedEmail = storedLogin['email'];
        final storedPassword = storedLogin['password'];

        if (storedEmail != null && storedPassword != null) {
          await _auth.signInWithEmailAndPassword(
              email: storedEmail, password: storedPassword);

          await fetchUserProfile(); // Memuat ulang data pengguna

          storage.remove('pendingLogin');
          print("Relogin berhasil untuk email: $storedEmail");
          Get.offAll(StorePage());
        } else {
          print("Data login tidak lengkap, relogin dibatalkan.");
        }
      } else {
        print("Data relogin kosong.");
      }
    } catch (e) {
      Get.snackbar('Relogin', 'Relogin gagal: ${e.toString()}');
      print(e);
      print(storage.read('pendingLogin'));
    }
  }

  // Reregister function
  Future<void> reregisterUser() async {
    try {
      final pendingRegister = storage.read('pendingRegister');
      if (pendingRegister != null) {
        final email = pendingRegister['email'];
        final password = pendingRegister['password'];

        if (email != null && password != null) {
          UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          User? user = userCredential.user;
          if (user != null) {
            await _firestore.collection('users').doc(user.uid).set({
              'name': 'none',
              'username': 'none',
              'email': email,
              'age': 0,
            });

            storage.remove('pendingRegister');
            print("Reregister berhasil untuk email: $email");
            Get.offAll(LoginPage());
          }
        } else {
          print("Data registrasi tidak lengkap, reregister dibatalkan.");
        }
      } else {
        print("Tidak ada data reregister.");
      }
    } catch (e) {
      Get.snackbar('Reregister', 'Reregister gagal: ${e.toString()}');
      print(e);
    }
  }

  // Get current user
  User? get currentUser => _auth.currentUser;
}