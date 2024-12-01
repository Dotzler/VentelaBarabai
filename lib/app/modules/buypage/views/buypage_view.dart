import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:SneakerSpace/app/modules/buypage/controllers/buypage_controller.dart';

class BuyPageView extends StatelessWidget {
  final BuyPageController controller = Get.put(BuyPageController());

  final String title;
  final int price;
  final String imagePath;
  final int size;

  BuyPageView({
    required this.title,
    required this.price,
    required this.imagePath,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Buy Page"),
        backgroundColor: Color(0xFFD3A335),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Product Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Image.asset(imagePath,
                    width: 100, height: 100, fit: BoxFit.cover),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text("Size: $size", style: TextStyle(fontSize: 14)),
                      SizedBox(height: 8),
                      Text("Price: Rp $price",
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700])),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Text(
              "Shipping Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Shipping Type",
              ),
              dropdownColor: Colors.white,
              items: ["Normal", "Express"]
                  .map((type) =>
                      DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) {
                controller.shippingType.value = value ?? "Normal";
              },
            ),
            SizedBox(height: 16),
            Text(
              "Payment Method",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Select Payment Method",
              ),
              dropdownColor: Colors.white,
              items: ["Cash", "Digital Money", "Debit Card"]
                  .map((method) =>
                      DropdownMenuItem(value: method, child: Text(method)))
                  .toList(),
              onChanged: (value) {
                controller.paymentMethod.value = value ?? "Cash";
              },
            ),
            SizedBox(height: 16),
            Obx(() {
              final paymentMethod = controller.paymentMethod.value;
              if (paymentMethod == "Digital Money" ||
                  paymentMethod == "Debit Card") {
                return TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: paymentMethod == "Digital Money"
                        ? "Digital Money Number"
                        : "Card Number",
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    controller.paymentNumber.value = value;
                  },
                );
              }
              return SizedBox.shrink();
            }),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Phone Number",
              ),
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                controller.phoneNumber.value = value;
              },
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Postal Code",
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                controller.postalCode.value = value;
              },
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Message for Seller",
              ),
              maxLines: 3,
              onChanged: (value) {
                controller.message.value = value;
              },
            ),
            SizedBox(height: 24),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              color: Colors.white,
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      final position = controller.userPosition.value;
                      return position != null
                          ? Text(
                              "Your Location:\nLatitude: ${position.latitude}\nLongitude: ${position.longitude}",
                              style: TextStyle(fontSize: 14),
                            )
                          : Text(
                              "Your Location: Not Available",
                              style: TextStyle(fontSize: 14),
                            );
                    }),
                    SizedBox(height: 8),
                    Obx(() {
                      final address = controller.address.value;
                      return Text(
                        "Address: $address",
                        style: TextStyle(fontSize: 14),
                      );
                    }),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: controller.getUserLocation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFD3A335),
                          ),
                          child: Text(
                            "Get Location",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: controller.openGoogleMaps,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFD3A335),
                          ),
                          child: Text(
                            "Open Maps",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await controller.getUserLocation();

                  final shippingType = controller.shippingType.value;
                  final paymentMethod = controller.paymentMethod.value;
                  final phoneNumber = controller.phoneNumber.value;
                  final postalCode = controller.postalCode.value;
                  final paymentNumber = controller.paymentNumber.value;

                  if (shippingType.isEmpty ||
                      phoneNumber.isEmpty ||
                      postalCode.isEmpty ||
                      (paymentMethod != "Cash" && paymentNumber.isEmpty)) {
                    Get.snackbar(
                      "Error",
                      "Please fill in all required fields.",
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.white,
                      colorText: Colors.black,
                    );
                    return;
                  }

                  controller.confirmPurchase(
                    title: title,
                    price: price,
                    size: size,
                    shippingType: shippingType,
                    phoneNumber: phoneNumber,
                    postalCode: postalCode,
                    message: controller.message.value,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD3A335),
                ),
                child: Text("Confirm Purchase", style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}