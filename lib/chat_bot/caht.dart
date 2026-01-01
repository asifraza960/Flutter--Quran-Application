import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_projects1/Constant/Constant.dart';
import '../Api_Data/Api_Services/ai_service.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late GeminiService _gemini;

  String? reply;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _gemini = GeminiService("AIzaSyDcfDs7L8cq6FvqWDytJnfOspnfSKdfqu0");
  }

  void sendPrompt() async {
    final text = _controller.text.trim();

    if (text.isEmpty) return;

    setState(() {
      isLoading = true;
      reply = null;
    });

    final result = await _gemini.generate(text);

    setState(() {
      reply = result;
      isLoading = false;
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Constants.kPrimary,
        title: Text("Gemini Chat"),
        centerTitle: true,
        elevation: 2,
      ),

      body: Column(
        children: [
          // ---------- OUTPUT AREA ----------
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: isLoading
                    ? Center(
                  child: CircularProgressIndicator(),
                )
                    : reply == null
                    ? Center(
                  child: Text(
                    "Ask anything...",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                )
                    : Text(
                  reply!,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),

          // ---------- INPUT FIELD ----------
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 6, offset: Offset(0, -2))
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Type your message...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 10),

                // SEND ARROW BUTTON
                GestureDetector(
                  onTap: sendPrompt,
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
