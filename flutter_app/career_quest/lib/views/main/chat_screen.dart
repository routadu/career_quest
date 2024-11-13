import 'package:career_quest/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';

class ChatBubbleData {
  final String message;
  final bool isUser;
  final bool isLoading;

  ChatBubbleData({
    this.message = "",
    required this.isUser,
    this.isLoading = false,
  });
}

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen>
    with AutomaticKeepAliveClientMixin {
  List<ChatBubbleData> messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      messages.add(ChatBubbleData(message: _controller.text, isUser: true));
      messages.add(ChatBubbleData(
        isUser: false,
        isLoading: true,
      ));
    });

    final response =
        await ref.read(geminiServiceProvider).getResponse(_controller.text);

    setState(() {
      messages.removeLast();
      messages.add(ChatBubbleData(
        message: response,
        isUser: false,
      ));

      _controller.clear();
    });

    // Scroll to the bottom of the chat
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController, // Attach the scroll controller
            padding: const EdgeInsets.all(10),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return ChatBubble(data: message);
            },
          ),
        ),
        ChatTextField(
          controller: _controller,
          onPressed: _sendMessage,
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ChatTextField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onPressed;

  const ChatTextField(
      {super.key, required this.controller, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              FocusScope.of(context).unfocus();
              onPressed();
            },
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final ChatBubbleData data;

  const ChatBubble({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: data.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: data.isUser ? 50 : 0,
          right: data.isUser ? 0 : 50,
          bottom: 20,
        ),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: data.isUser ? const Color(0xFF373737) : Colors.transparent,
          // ? const Color.fromARGB(255, 82, 80, 80)
          // : const Color(0xFF1F1F1F),
          borderRadius: BorderRadius.circular(10),
        ),
        child: data.isLoading
            ? SizedBox(
                height: 30,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballPulse,
                  colors: [Theme.of(context).indicatorColor],
                ),
              )
            : Text(
                data.message,
                style: TextStyle(
                  color: data.isUser
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
      ),
    );
  }
}
