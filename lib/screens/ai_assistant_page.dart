import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIAssistantPage extends StatefulWidget {
  const AIAssistantPage({super.key});

  @override
  State<AIAssistantPage> createState() => _AIAssistantPageState();
}

class _AIAssistantPageState extends State<AIAssistantPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  
  bool _isLoading = false; // লোডিং স্টেট ট্র্যাক করার জন্য
  late final ChatSession _chatSession; // আগের কথোপকথন মনে রাখার জন্য

  @override
  void initState() {
    super.initState();
    _initializeAI();
  }

  void _initializeAI() {
    // Gemini API সেটআপ এবং ইসলামিক ক্যারেক্টারিস্টিকস (System Instruction)
    final model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: 'AIzaSyDG3Lufa5URwzFAlQ24ZPLvfgWXISjMpyQ',
      systemInstruction: Content.system(
        'আপনি একজন জ্ঞানী, বিনয়ী এবং নির্ভরযোগ্য ইসলামিক এআই সহকারী। '
        'ব্যবহারকারীকে সালামের উত্তর দেবেন। সর্বদা কুরআন এবং সহীহ হাদিসের আলোকে সঠিক তথ্য প্রদান করবেন। '
        'জটিল ফিকহ বা ফতোয়ার ক্ষেত্রে ব্যবহারকারীকে স্থানীয় আলেম বা মুফতির সাথে পরামর্শ করার বিনীত উপদেশ দেবেন। '
        'উত্তরগুলো হবে সংক্ষিপ্ত, পয়েন্ট-আকারে (প্রয়োজন হলে), এবং সুন্দর মার্জিত বাংলায়। '
        'অপ্রাসঙ্গিক বা ইসলাম বহির্ভূত কোনো প্রশ্নের উত্তর এড়িয়ে যাবেন।'
      ),
    );
    _chatSession = model.startChat(history: []);

    // ওয়েলকাম মেসেজ যুক্ত করা
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

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true, time: DateTime.now()));
      _isLoading = true; // AI-এর জন্য অপেক্ষা করা হচ্ছে
    });
    
    _messageController.clear();
    _scrollToBottom();

    try {
      // Gemini API-তে মেসেজ পাঠানো হচ্ছে
      final response = await _chatSession.sendMessage(Content.text(text));

      if (mounted) {
        setState(() {
          _isLoading = false;
          _messages.add(ChatMessage(
            text: response.text?.trim() ?? 'দুঃখিত, কোনো উত্তর পাওয়া যায়নি।',
            isUser: false,
            time: DateTime.now(),
          ));
        });
        _scrollToBottom();
      }
    } catch (e) {
      print('Gemini API Error: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _messages.add(ChatMessage(
            text: 'দুঃখিত, নেটওয়ার্ক বা সার্ভারে সমস্যা হয়েছে। অনুগ্রহ করে আপনার ইন্টারনেট কানেকশন চেক করে আবার চেষ্টা করুন।',
            isUser: false,
            time: DateTime.now(),
          ));
        });
        _scrollToBottom();
      }
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
    // গ্লোবাল থিম থেকে কালার নেওয়া হচ্ছে
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // প্রফেশনাল হালকা ব্যাকগ্রাউন্ড
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.psychology, size: 22, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Text(
              'AI সহায়ক',
              style: GoogleFonts.notoSansBengali(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'নতুন চ্যাট শুরু করুন',
            onPressed: () {
              setState(() {
                _messages.clear();
                _initializeAI(); // চ্যাট হিস্ট্রি রিসেট করে নতুন সেশন শুরু
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // কুইক সাজেশান চিপস
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickChip('নামাজের সময়', primaryColor),
                  _buildQuickChip('রোজার নিয়ম', primaryColor),
                  _buildQuickChip('যাকাত কীভাবে দিব', primaryColor),
                  _buildQuickChip('দুআ শিখুন', primaryColor),
                ],
              ),
            ),
          ),
          
          // চ্যাট মেসেজ লিস্ট
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index], primaryColor);
              },
            ),
          ),
          
          // লোডিং ইন্ডিকেটর (AI টাইপ করার সময়)
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'অপেক্ষা করুন...',
                      style: GoogleFonts.notoSansBengali(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
          // ইনপুট ফিল্ড (মেসেজ বক্স)
          Container(
            padding: EdgeInsets.only(
              left: 12,
              right: 12,
              top: 12,
              bottom: MediaQuery.of(context).padding.bottom + 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'আপনার প্রশ্ন লিখুন...',
                      hintStyle: GoogleFonts.notoSansBengali(color: Colors.grey.shade500),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _isLoading ? null : _sendMessage, // লোডিং চলাকালীন ক্লিক বন্ধ
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _isLoading ? Colors.grey : primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickChip(String label, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(
          label,
          style: GoogleFonts.notoSansBengali(
            fontSize: 13,
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w500,
          ),
        ),
        onPressed: () {
          _messageController.text = label;
          _sendMessage();
        },
        backgroundColor: Colors.grey.shade50,
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: primaryColor.withValues(alpha: 0.1),
              child: Icon(Icons.psychology, size: 20, color: primaryColor),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: message.isUser ? primaryColor : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(message.isUser ? 20 : 4),
                  bottomRight: Radius.circular(message.isUser ? 4 : 20),
                ),
                boxShadow: [
                  if (!message.isUser)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: Text(
                message.text,
                style: GoogleFonts.notoSansBengali(
                  fontSize: 15,
                  color: message.isUser ? Colors.white : Colors.black87,
                  height: 1.5,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey.shade200,
              child: Icon(Icons.person, size: 20, color: Colors.grey.shade600),
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