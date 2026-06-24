import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AIAssistantPage extends StatefulWidget {
  const AIAssistantPage({super.key});

  @override
  State<AIAssistantPage> createState() => _AIAssistantPageState();
}

class _AIAssistantPageState extends State<AIAssistantPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _messages.add(
      ChatMessage(
        text: 'আসসালামু আলাইকুম! আমি আপনার ইসলামিক সহায়ক। আপনি আমাকে নামাজ, রোজা, হজ্জ, যাকাত এবং অন্যান্য ইসলামিক বিষয়ে প্রশ্ন করতে পারেন।',
        isUser: false,
        time: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: _messageController.text,
          isUser: true,
          time: DateTime.now(),
        ),
      );

      // Simulate AI response (in real app, this would call an API)
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _messages.add(
              ChatMessage(
                text: _getAutoResponse(_messageController.text),
                isUser: false,
                time: DateTime.now(),
              ),
            );
          });
          _scrollToBottom();
        }
      });
    });

    _messageController.clear();
    _scrollToBottom();
  }

  String _getAutoResponse(String question) {
    final q = question.toLowerCase();
    
    if (q.contains('নামাজ') || q.contains('সালাত')) {
      return 'নামাজ সম্পর্কে আপনার প্রশ্নের জন্য ধন্যবাদ। নামাজ ইসলামের পাঁচটি স্তম্ভের একটি এবং এটি দিনে পাঁচ বার আদায় করা ফরজ। আপনি কি নামাজের সময়, নিয়ম, বা অন্য কিছু জানতে চান?';
    } else if (q.contains('রোজা') || q.contains('সিয়াম')) {
      return 'রোজা বা সিয়াম রমজান মাসে মুসলমানদের জন্য ফরজ ইবাদত। সুবহে সাদিক থেকে সূর্যাস্ত পর্যন্ত পানাহার ও অন্যান্য নিষিদ্ধ বিষয় থেকে বিরত থাকতে হয়।';
    } else if (q.contains('যাকাত')) {
      return 'যাকাত ইসলামের পাঁচটি স্তম্ভের একটি। নিসাব পরিমাণ সম্পদের মালিক হলে বছরে ২.৫% যাকাত প্রদান করা ফরজ।';
    } else if (q.contains('হজ্জ') || q.contains('হজ')) {
      return 'হজ্জ ইসলামের পাঁচটি স্তম্ভের একটি। সক্ষম মুসলমানদের জন্য জীবনে একবার হজ্জ করা ফরজ। এটি যিলহজ্জ মাসে সম্পন্ন করা হয়।';
    } else if (q.contains('দুআ') || q.contains('দোয়া')) {
      return 'দুআ আল্লাহর কাছে প্রার্থনা করার একটি গুরুত্বপূর্ণ উপায়। আপনি যে কোন সময় যে কোন ভাষায় দুআ করতে পারেন। তবে কিছু বিশেষ দুআ আছে যা নবী (সা.) শিখিয়েছেন।';
    } else if (q.contains('কুরআন') || q.contains('কোরআন')) {
      return 'কুরআন আল্লাহর বাণী যা নবী মুহাম্মদ (সা.) এর উপর নাজিল হয়েছে। এটি পড়া, বুঝা এবং অনুসরণ করা প্রতিটি মুসলমানের দায়িত্ব। আপনি অ্যাপের কুরআন সেকশন থেকে বাংলা অনুবাদসহ পড়তে পারেন।';
    } else {
      return 'আপনার প্রশ্নের জন্য ধন্যবাদ। আমি এখনও শিখছি। আপনি নামাজ, রোজা, যাকাত, হজ্জ, দুআ বা কুরআন সম্পর্কে আরও নির্দিষ্ট প্রশ্ন করতে পারেন। অথবা আপনার স্থানীয় আলেম/ইমামের সাথে পরামর্শ করুন।';
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.psychology, size: 24),
            ),
            const SizedBox(width: 12),
            Text(
              'AI সহায়ক',
              style: GoogleFonts.notoSansBengali(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1D9375),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              setState(() {
                _messages.clear();
                _messages.add(
                  ChatMessage(
                    text: 'আসসালামু আলাইকুম! আমি আপনার ইসলামিক সহায়ক। আপনি আমাকে নামাজ, রোজা, হজ্জ, যাকাত এবং অন্যান্য ইসলামিক বিষয়ে প্রশ্ন করতে পারেন।',
                    isUser: false,
                    time: DateTime.now(),
                  ),
                );
              });
            },
            tooltip: 'Clear Chat',
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick suggestions
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            color: Colors.grey.shade100,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickChip('নামাজের সময়'),
                  _buildQuickChip('রোজার নিয়ম'),
                  _buildQuickChip('যাকাত কীভাবে দিব'),
                  _buildQuickChip('দুআ শিখুন'),
                ],
              ),
            ),
          ),
          // Messages list
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.grey.shade50,
                    Colors.white,
                  ],
                ),
              ),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageBubble(_messages[index]);
                },
              ),
            ),
          ),
          // Input field
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: 'আপনার প্রশ্ন লিখুন...',
                                hintStyle: GoogleFonts.notoSansBengali(
                                  color: Colors.grey,
                                ),
                                border: InputBorder.none,
                              ),
                              maxLines: null,
                              textInputAction: TextInputAction.send,
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF1D9375),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(
          label,
          style: GoogleFonts.notoSansBengali(fontSize: 12),
        ),
        onPressed: () {
          _messageController.text = label;
          _sendMessage();
        },
        backgroundColor: Colors.white,
        side: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser) ...[
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF1D9375),
              child: Icon(Icons.psychology, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? const Color(0xFF1D9375)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft:
                      Radius.circular(message.isUser ? 16 : 4),
                  bottomRight:
                      Radius.circular(message.isUser ? 4 : 16),
                ),
                border: Border.all(
                  color: message.isUser
                      ? const Color(0xFF1D9375)
                      : Colors.grey.shade300,
                  width: 1,
                ),
              ),
              child: Text(
                message.text,
                style: GoogleFonts.notoSansBengali(
                  fontSize: 14,
                  color: message.isUser ? Colors.white : Colors.black87,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey.shade300,
              child: Icon(Icons.person, size: 18, color: Colors.grey.shade700),
            ),
          ],
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
  });
}
