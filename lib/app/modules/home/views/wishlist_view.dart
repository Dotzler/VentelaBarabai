import 'package:flutter/material.dart';

class WishlistItem {
  final String name;
  final String imagePath;

  WishlistItem({required this.name, required this.imagePath});
}

class WishlistPage extends StatefulWidget {
  final List<WishlistItem> wishlist;

  WishlistPage({required this.wishlist});

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  void _removeFromWishlist(int index) {
    setState(() {
      widget.wishlist.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFD3A335),
        centerTitle: true,
        title: Text(
          "Wishlist",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.wishlist.length,
        itemBuilder: (context, index) {
          final item = widget.wishlist[index];
          return ListTile(
            leading: Image.asset(item.imagePath, width: 50, height: 50),
            title: Text(item.name),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeFromWishlist(index),
            ),
          );
        },
      ),
    );
  }
}
