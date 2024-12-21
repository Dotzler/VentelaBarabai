import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/connection_controller.dart';

class ConnectionView extends GetView<NetworkController> {
  const ConnectionView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ConnectionView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ConnectionView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
