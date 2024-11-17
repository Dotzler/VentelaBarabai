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
    final removedItem = widget.wishlist[index];
    setState(() {
      widget.wishlist.removeAt(index);
    });

    // Menampilkan SnackBar setelah item dihapus
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${removedItem.name} telah dihapus dari wishlist'),
        duration: Duration(seconds: 2),
      ),
    );
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
      body: widget.wishlist.isEmpty
          ? Center(
              child: Text(
                'Wishlist kamu kosong!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: widget.wishlist.length,
              itemBuilder: (context, index) {
                final item = widget.wishlist[index];
                return Dismissible(
                  key: Key(item.name),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${item.name} telah dihapus dari wishlist'),
                        duration: Duration(seconds: 1),
                      ),
                    );

                    Future.delayed(Duration(milliseconds: 500), () {
                      if (mounted) {
                        setState(() {
                          widget.wishlist.removeAt(index);
                        });
                      }
                    });
                  },
                  background: Container(
                    padding: EdgeInsets.only(right: 20),
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    color: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              item.imagePath,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(Icons.favorite, color: Colors.red, size: 16),
                                    const SizedBox(width: 5),
                                    Text(
                                      "Favorite",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeFromWishlist(index),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
