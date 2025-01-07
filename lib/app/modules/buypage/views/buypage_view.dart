import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:VentelaBarabai/app/modules/buypage/controllers/buypage_controller.dart';

class BuyPageView extends StatelessWidget {
  final BuyPageController controller = Get.put(BuyPageController());

  final String title;
  final int price;
  final String imagePath;
  final int size;
  final String? cartItemId;


  BuyPageView({
    required this.title,
    required this.price,
    required this.imagePath,
    required this.size,
    this.cartItemId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Checkout",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Color(0xFFD3A335),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            // Product Card with Side-by-Side Layout
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      imagePath,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 16),
                  // Product Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Size: $size",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFD3A335),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Shipping Section
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.local_shipping, color: Color(0xFFD3A335)),
                      SizedBox(width: 8),
                      Text(
                        "Shipping Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildDropdownField(
                    hint: "Select Shipping Type",
                    items: ["Normal", "Express"],
                    onChanged: (value) {
                      controller.shippingType.value = value ?? "Normal";
                    },
                    icon: Icons.delivery_dining,
                  ),
                ],
              ),
            ),

            // Payment Section
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.payment, color: Color(0xFFD3A335)),
                      SizedBox(width: 8),
                      Text(
                        "Payment Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildDropdownField(
                    hint: "Select Payment Method",
                    items: ["Cash", "Digital Money", "Debit Card"],
                    onChanged: (value) {
                      controller.paymentMethod.value = value ?? "Cash";
                    },
                    icon: Icons.account_balance_wallet,
                  ),
                  SizedBox(height: 16),
                  Obx(() {
                    final paymentMethod = controller.paymentMethod.value;
                    if (paymentMethod == "Digital Money" ||
                        paymentMethod == "Debit Card") {
                      return _buildTextField(
                        label: paymentMethod == "Digital Money"
                            ? "Digital Money Number"
                            : "Card Number",
                        icon: Icons.credit_card,
                        onChanged: (value) {
                          controller.paymentNumber.value = value;
                        },
                      );
                    }
                    return SizedBox.shrink();
                  }),
                ],
              ),
            ),

            // Contact Information
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.contact_mail, color: Color(0xFFD3A335)),
                      SizedBox(width: 8),
                      Text(
                        "Contact Information",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    label: "Phone Number",
                    icon: Icons.phone,
                    onChanged: (value) {
                      controller.phoneNumber.value = value;
                    },
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    label: "Postal Code",
                    icon: Icons.location_on,
                    onChanged: (value) {
                      controller.postalCode.value = value;
                    },
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    label: "Message for Seller",
                    icon: Icons.message,
                    maxLines: 3,
                    onChanged: (value) {
                      controller.message.value = value;
                    },
                  ),
                ],
              ),
            ),

            // Location Section
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Color(0xFFD3A335)),
                      SizedBox(width: 8),
                      Text(
                        "Location",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
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
                    children: [
                      Expanded(
                        child: _buildButton(
                          "Get Location",
                          Icons.my_location,
                          controller.getUserLocation,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildButton(
                          "Open Maps",
                          Icons.map,
                          controller.openGoogleMaps,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Confirm Purchase Button
            Container(
              margin: EdgeInsets.all(16),
              width: double.infinity,
              height: 54,
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
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
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
                    cartItemId: cartItemId,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD3A335),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(27),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  "Confirm Purchase",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required Function(String) onChanged,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Color(0xFFD3A335)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDropdownField({
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Color(0xFFD3A335)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        hint: Text(hint),
        dropdownColor: Colors.white,
        items: items
            .map((type) => DropdownMenuItem(value: type, child: Text(type)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildButton(String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFD3A335),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }
}