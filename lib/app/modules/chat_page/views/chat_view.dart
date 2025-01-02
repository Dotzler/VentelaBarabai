import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<String> messages = [];
  final TextEditingController _controller = TextEditingController();
  int? _editingIndex;

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  // Initialize Speech-to-Text functionality
  void _initSpeech() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        print("Speech-to-text is initialized and ready");
      });
    } else {
      setState(() {
        print("Speech-to-text initialization failed");
      });
    }
  }

  // Start or continue listening for speech
  void _startListening() async {
  if (!_isListening) {
    await _speech.listen(
      onResult: (result) {
        setState(() {
          _controller.text = result.recognizedWords;
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
        });
      },
      listenFor: const Duration(seconds: 30),
      partialResults: true,
    );
    setState(() {
      _isListening = _speech.isListening;
    });
  }
}

  // Stop listening to microphone input
  void _stopListening() async {
    await _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  // Toggle microphone state
  void _toggleListening() {
    if (_isListening) {
      _stopListening();  // Stop listening if already listening
    } else {
      _startListening(); // Start listening if not listening
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Chat'),
        backgroundColor: const Color(0xFFD3A335),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  bool isMe = index % 2 == 0;
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

  // Build the chat bubble for each message
  Widget _buildChatBubble(String message, bool isMe, int index) {
    return GestureDetector(
      onLongPress: () {
        _showEditDeleteOptions(index);
      },
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          decoration: BoxDecoration(
            color: isMe ? const Color(0xFFD3A335) : Colors.grey[200],
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

  // Build the message input field with mic button
  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Type your message...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: Icon(
            _isListening ? Icons.stop : Icons.mic,
            color: const Color(0xFFD3A335),
          ),
          onPressed: _toggleListening, // Toggle the microphone state
        ),
        IconButton(
          icon: const Icon(Icons.send, color: Color(0xFFD3A335)),
          onPressed: () {
            String message = _controller.text.trim();
            if (message.isNotEmpty) {
              setState(() {
                if (_editingIndex != null) {
                  messages[_editingIndex!] = message;
                  _editingIndex = null;
                } else {
                  messages.add(message);
                }
                _controller.clear();
              });
            }
          },
        ),
      ],
    );
  }

  // Show options to edit or delete message
  void _showEditDeleteOptions(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit or Delete'),
          content: const Text('Would you like to edit or delete this message?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _editingIndex = index;
                  _controller.text = messages[index];
                });
                Navigator.of(context).pop();
              },
              child: const Text('Edit'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  messages.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}