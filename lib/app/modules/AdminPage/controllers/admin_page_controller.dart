import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AdminPageController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxBool isLoading = false.obs;
  RxList<Map<String, dynamic>> usersList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> reportsList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> transactionsList = <Map<String, dynamic>>[].obs;
  
  // Dashboard statistics
  RxInt totalUsers = 0.obs;
  RxInt activeUsers = 0.obs;
  RxDouble totalRevenue = 0.0.obs;
  RxInt totalTransactions = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllUsers();
    fetchDashboardStats();
    fetchReports();
    fetchTransactions();
  }

  Future<void> fetchDashboardStats() async {
    try {
      isLoading.value = true;
      
      // Get total users
      QuerySnapshot usersSnapshot = await _firestore.collection('users').get();
      totalUsers.value = usersSnapshot.size;
      
      // Get active users (logged in within last 30 days)
      DateTime thirtyDaysAgo = DateTime.now().subtract(Duration(days: 30));
      QuerySnapshot activeUsersSnapshot = await _firestore
          .collection('users')
          .where('lastLogin', isGreaterThan: thirtyDaysAgo)
          .get();
      activeUsers.value = activeUsersSnapshot.size;
      
      // Calculate total revenue and transactions
      QuerySnapshot transactionsSnapshot = await _firestore.collection('transactions').get();
      totalTransactions.value = transactionsSnapshot.size;
      
      double revenue = 0;
      for (var doc in transactionsSnapshot.docs) {
        revenue += (doc.data() as Map<String, dynamic>)['amount'] ?? 0;
      }
      totalRevenue.value = revenue;
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat statistik: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAllUsers() async {
    try {
      isLoading.value = true;
      QuerySnapshot snapshot = await _firestore.collection('users').get();
      usersList.value = snapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data pengguna: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchReports() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('reports').get();
      reportsList.value = snapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat laporan: $e');
    }
  }

  Future<void> fetchTransactions() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('transactions').get();
      transactionsList.value = snapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat transaksi: $e');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      isLoading.value = true;
      await _firestore.collection('users').doc(userId).delete();
      usersList.removeWhere((user) => user['id'] == userId);
      Get.snackbar('Berhasil', 'Pengguna berhasil dihapus');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus pengguna: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUserStatus(String userId, bool isBlocked) async {
    try {
      isLoading.value = true;

      // Update status pengguna di database
      await _firestore.collection('users').doc(userId).update({'isBlocked': isBlocked});

      // Temukan pengguna di usersList dan perbarui statusnya
      final index = usersList.indexWhere((user) => user['id'] == userId);
      if (index != -1) {
        usersList[index]['isBlocked'] = isBlocked;
        usersList.refresh(); // Pastikan RxList diperbarui
      }

      Get.snackbar('Sukses', 'Status pengguna berhasil diperbarui.');
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui status pengguna: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resolveReport(String reportId) async {
    try {
      await _firestore.collection('reports').doc(reportId).update({
        'status': 'resolved',
        'resolvedAt': DateTime.now(),
      });
      fetchReports();
      Get.snackbar('Berhasil', 'Laporan telah diselesaikan');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menyelesaikan laporan: $e');
    }
  }

  Future<void> addReport(String title, String description) async {
    try {
      final newReport = {
        'title': title,
        'description': description,
        'status': 'pending',
      };
      final docRef = await _firestore.collection('reports').add(newReport);
      reportsList.add({'id': docRef.id, ...newReport});
      reportsList.refresh();
      Get.snackbar('Berhasil', 'Laporan berhasil ditambahkan.');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan laporan: $e');
    }
  }

  Future<void> updateReport(String id, String title, String description) async {
    try {
      await _firestore.collection('reports').doc(id).update({
        'title': title,
        'description': description,
      });
      final index = reportsList.indexWhere((report) => report['id'] == id);
      if (index != -1) {
        reportsList[index]['title'] = title;
        reportsList[index]['description'] = description;
        reportsList.refresh();
      }
      Get.snackbar('Berhasil', 'Laporan berhasil diperbarui.');
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui laporan: $e');
    }
  }

  Future<void> deleteReport(String id) async {
    try {
      await _firestore.collection('reports').doc(id).delete();
      reportsList.removeWhere((report) => report['id'] == id);
      reportsList.refresh();
      Get.snackbar('Berhasil', 'Laporan berhasil dihapus.');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus laporan: $e');
    }
  }
}