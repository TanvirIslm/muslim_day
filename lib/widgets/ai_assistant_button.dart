import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AIAssistantButton extends StatefulWidget {
  const AIAssistantButton({super.key});

  @override
  State<AIAssistantButton> createState() => _AIAssistantButtonState();
}

class _AIAssistantButtonState extends State<AIAssistantButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 80,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FloatingActionButton.extended(
          onPressed: () {
            _showAIAssistant(context);
          },
          backgroundColor: const Color(0xFF1D9375),
          icon: const Icon(Icons.auto_awesome, color: Colors.white),
          label: Text(
            'AI Fiqh Assistant',
            style: GoogleFonts.notoSansBengali(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  void _showAIAssistant(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1D9375), Color(0xFF1A4D4D)],
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ইসলামিক AI সহায়ক',
                          style: GoogleFonts.notoSansBengali(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'আপনার ইসলামিক প্রশ্নের উত্তর পান',
                          style: GoogleFonts.notoSansBengali(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Quick Questions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'দ্রুত প্রশ্ন',
                    style: GoogleFonts.notoSansBengali(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildQuickQuestion('ওজু কীভাবে করবো?'),
                      _buildQuickQuestion('নামাজের ফরজ কয়টি?'),
                      _buildQuickQuestion('রোজার বিধান কী?'),
                      _buildQuickQuestion('যাকাত কাকে দিতে হয়?'),
                      _buildQuickQuestion('হজ্জের ফরজ কী?'),
                      _buildQuickQuestion('দোয়া কবুলের সময়'),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(),

            // Chat Interface
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildAIMessage(
                    'আসসালামু আলাইকুম! আমি আপনার ইসলামিক AI সহায়ক। আপনি ইসলাম সম্পর্কিত যেকোনো প্রশ্ন করতে পারেন।',
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'এই ফিচার শীঘ্রই আসছে',
                      style: GoogleFonts.notoSansBengali(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Input Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'আপনার প্রশ্ন লিখুন...',
                        hintStyle: GoogleFonts.notoSansBengali(),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      style: GoogleFonts.notoSansBengali(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FloatingActionButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'AI সহায়ক শীঘ্রই আসছে',
                            style: GoogleFonts.notoSansBengali(),
                          ),
                        ),
                      );
                    },
                    backgroundColor: const Color(0xFF1D9375),
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickQuestion(String question) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'AI সহায়ক শীঘ্রই আসছে',
              style: GoogleFonts.notoSansBengali(),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1D9375).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF1D9375).withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          question,
          style: GoogleFonts.notoSansBengali(
            color: const Color(0xFF1D9375),
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildAIMessage(String message) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1D9375).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.auto_awesome,
            color: Color(0xFF1D9375),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              message,
              style: GoogleFonts.notoSansBengali(
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
