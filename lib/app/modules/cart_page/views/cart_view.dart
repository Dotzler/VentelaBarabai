import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Simulating quantities and prices for each cart item
  List<int> quantities = [ 1, 1, 1];
  List<double> prices = [2100000, 3000000, 1500000];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFD3A335),
        centerTitle: true,
        title: Text(
          "Cart",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: List.generate(
                quantities.length,
                (index) => _buildCartItem(index),
              ),
            ),
          ),
          _buildTotalSection(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Handle checkout
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFD3A335),
            padding: EdgeInsets.symmetric(vertical: 8.0),
          ),
          child: Text(
            'CHECK OUT',
            style: TextStyle(fontSize: 18),
            selectionColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildCartItem(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200]!,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Placeholder(
            fallbackHeight: 60,
            fallbackWidth: 60,
          ), // Replace with Image widget for the product image
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sneakers', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('\IDR${prices[index]}'),
                Text('Size: US 7'),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                if (quantities[index] > 1) {
                  quantities[index]--;
                }
              });
            },
            icon: Icon(Icons.remove),
          ),
          Text('${quantities[index]}'), // Quantity
          IconButton(
            onPressed: () {
              setState(() {
                quantities[index]++;
              });
            },
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                quantities.removeAt(index);
                prices.removeAt(index); // Remove the item from cart
              });
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSection() {
    double totalPrice = 0;
    for (int i = 0; i < quantities.length; i++) {
      totalPrice += quantities[i] * prices[i];
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            '\IDR${totalPrice.toStringAsFixed(1)}', // Dynamically display total price
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}