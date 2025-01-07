import 'dart:math';

import 'package:flutter/material.dart';
import 'package:VentelaBarabai/app/auth_controller.dart';
import 'package:VentelaBarabai/app/modules/login_page/views/login_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/admin_page_controller.dart';

class AdminPage extends StatelessWidget {
  AdminPage({Key? key}) : super(key: key);

  final AdminPageController controller = Get.find<AdminPageController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFFD3A335),
          title: const Text(
            'Admin Dashboard',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black54,
            tabs: [
              Tab(icon: Icon(Icons.dashboard), text: 'Dashboard'),
              Tab(icon: Icon(Icons.people), text: 'Users'),
              Tab(icon: Icon(Icons.report_problem), text: 'Reports'),
              Tab(icon: Icon(Icons.receipt_long), text: 'Transactions'),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () => controller.fetchAllUsers(),
              icon: const Icon(Icons.refresh, color: Colors.black),
              tooltip: 'Refresh Data',
            ),
            IconButton(
              onPressed: () async {
                await authController.logout();
                Get.offAll(() => LoginPage());
              },
              icon: const Icon(Icons.logout, color: Colors.black),
              tooltip: 'Logout',
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _buildDashboard(),
            _buildUsersTab(),
            _buildReportsTab(),
            _buildTransactionsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard Overview',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFD3A335),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildStatCard(
                  'Total Users',
                  '${controller.totalUsers}',
                  Icons.people,
                  const Color(0xFFD3A335),
                ),
                const SizedBox(width: 16),
                _buildStatCard(
                  'Active Users',
                  '${controller.activeUsers}',
                  Icons.person_outline,
                  Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatCard(
                  'Total Revenue',
                  'Rp ${NumberFormat('#,##0').format(controller.totalRevenue.value)}',
                  Icons.monetization_on,
                  Colors.orange,
                ),
                const SizedBox(width: 16),
                _buildStatCard(
                  'Transactions',
                  '${controller.totalTransactions}',
                  Icons.receipt,
                  Colors.purple,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 36),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsersTab() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.usersList.isEmpty) {
        return Center(
          child: Text(
            'Tidak ada pengguna',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: controller.usersList.length,
        itemBuilder: (context, index) {
          final user = controller.usersList[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFFD3A335),
                child: Text(
                  (user['name'] as String?)?.characters.first.toUpperCase() ?? 
                  '?',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(user['name'] ?? 'No Name'),
              subtitle: Text(user['email'] ?? 'No Email'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch(
                    value: !(user['isBlocked'] ?? false),
                    onChanged: (value) {
                      controller.updateUserStatus(user['id'], !value);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Konfirmasi Hapus'),
                          content: Text(
                            'Apakah Anda yakin ingin menghapus pengguna ${user['name'] ?? 'ini'}?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Batal'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('Hapus'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await controller.deleteUser(user['id']);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildReportsTab() {
    return Column(
      children: [
        // Tombol Tambah Laporan
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () => _showReportFormDialog(),
            icon: const Icon(Icons.add),
            label: const Text('Tambah Laporan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        // Daftar laporan atau teks kosong
        Expanded(
          child: Obx(() {
            if (controller.reportsList.isEmpty) {
              return Center(
                child: Text(
                  'Tidak ada laporan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
              );
            }

            // List laporan
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: controller.reportsList.length,
              itemBuilder: (context, index) {
                final report = controller.reportsList[index];
                final isResolved = report['status'] == 'resolved';

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isResolved ? Icons.check_circle : Icons.error,
                              color: isResolved ? Colors.green : Colors.orange,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                report['title'] ?? 'Tidak ada judul',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _showReportFormDialog(report: report);
                                } else if (value == 'delete') {
                                  controller.deleteReport(report['id']);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Hapus'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          report['description'] ?? 'Tidak ada deskripsi',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: isResolved
                              ? Chip(
                                  label: const Text(
                                    'Resolved',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: Colors.green[100],
                                )
                              : ElevatedButton(
                                  onPressed: () =>
                                      controller.resolveReport(report['id']),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Resolve',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
  
  void _showReportFormDialog({Map<String, dynamic>? report}) {
    final titleController = TextEditingController(text: report?['title'] ?? '');
    final descriptionController =
        TextEditingController(text: report?['description'] ?? '');

    Get.defaultDialog(
      title: report == null ? 'Tambah Laporan' : 'Edit Laporan',
      content: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Judul',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Deskripsi',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      textConfirm: report == null ? 'Tambah' : 'Simpan',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      onConfirm: () {
        if (report == null) {
          controller.addReport(
            titleController.text,
            descriptionController.text,
          );
        } else {
          controller.updateReport(
            report['id'],
            titleController.text,
            descriptionController.text,
          );
        }
        Get.back();
      },
    );
  }

  Widget _buildTransactionsTab() {
    return Obx(() {
      if (controller.transactionsList.isEmpty) {
        return Center(
          child: Text(
            'Tidak ada transaksi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: controller.transactionsList.length,
        itemBuilder: (context, index) {
          final transaction = controller.transactionsList[index];
          final amount = transaction['amount'] ?? 0.0;

          // Safe date formatting with null check
          String transactionDate = 'No date';
          if (transaction['date'] != null) {
            try {
              final timestamp = transaction['date'] as Timestamp;
              transactionDate = DateFormat('dd MMM yyyy HH:mm').format(
                timestamp.toDate(),
              );
            } catch (e) {
              transactionDate = 'Invalid date';
            }
          }

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.payment,
                    color: Colors.blue,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Transaction #${transaction['id'].toString().substring(0, min(8, transaction['id'].toString().length))}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          transactionDate,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Rp ${NumberFormat('#,##0').format(amount)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
