import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<String> messages = []; // List to store messages
  final TextEditingController _controller = TextEditingController(); // Controller for the input field
  int? _editingIndex; // Variable to keep track of the index being edited

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Chat'),
        backgroundColor: Color(0xFFD3A335),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Chat messages will be displayed here
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  bool isMe = index % 2 == 0; // Simulate the sender for demonstration
                  return _buildChatBubble(messages[index], isMe, index);
                },
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(String message, bool isMe, int index) {
    return GestureDetector(
      onLongPress: () {
        // Show options to edit or delete the message
        _showEditDeleteOptions(index);
      },
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.all(12.0),
          margin: EdgeInsets.symmetric(vertical: 5.0),
          decoration: BoxDecoration(
            color: isMe ? Color(0xFFD3A335) : Colors.grey[200],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Text(
            message,
            style: TextStyle(color: isMe ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller, // Set the controller
            decoration: InputDecoration(
              hintText: 'Type your message...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ),
        SizedBox(width: 8),
        IconButton(
          icon: Icon(Icons.send, color: Color(0xFFD3A335)),
          onPressed: () {
            // Get the text from the controller
            String message = _controller.text.trim();
            if (message.isNotEmpty) {
              setState(() {
                if (_editingIndex != null) {
                  // Update the existing message
                  messages[_editingIndex!] = message;
                  _editingIndex = null; // Reset editing index
                } else {
                  // Add the message to the list
                  messages.add(message);
                }
                _controller.clear(); // Clear the text field
              });
            }
          },
        ),
      ],
    );
  }

  void _showEditDeleteOptions(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit or Delete'),
          content: Text('Would you like to edit or delete this message?'),
          actions: [
            TextButton(
              onPressed: () {
                // Set the message for editing
                setState(() {
                  _editingIndex = index;
                  _controller.text = messages[index]; // Set the message in the input field for editing
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Edit'),
            ),
            TextButton(
              onPressed: () {
                // Delete the message
                setState(() {
                  messages.removeAt(index);
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}