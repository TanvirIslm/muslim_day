import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppCautionPage extends StatelessWidget {
  const AppCautionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'বিশেষ দ্রষ্টব্য',
          style: GoogleFonts.notoSansBengali(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1D9375),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1D9375).withValues(alpha: 0.1),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWarningCard(
                icon: Icons.access_time,
                title: 'নামাজের সময় সম্পর্কে',
                content:
                    'এই অ্যাপে প্রদর্শিত নামাজের সময় গাণিতিক হিসাবের উপর ভিত্তি করে নির্ধারিত। এটি আপনার অবস্থানের উপর ভিত্তি করে স্বয়ংক্রিয়ভাবে হিসাব করা হয়।\n\n'
                    '• আপনার স্থানীয় মসজিদের সময়সূচীর সাথে কিছুটা পার্থক্য হতে পারে।\n'
                    '• সবসময় আপনার স্থানীয় মসজিদ বা ইসলামিক কেন্দ্রের সময়সূচীকে অগ্রাধিকার দিন।\n'
                    '• অবস্থান পরিবর্তন করলে সময় স্বয়ংক্রিয়ভাবে আপডেট হবে।',
              ),
              const SizedBox(height: 16),
              _buildWarningCard(
                icon: Icons.calendar_today,
                title: 'হিজরি তারিখ',
                content:
                    'হিজরি তারিখ গণনা জ্যোতির্বিদ্যাগত হিসাবের উপর ভিত্তি করে করা হয়।\n\n'
                    '• প্রকৃত চাঁদ দেখার সাথে ১-২ দিনের পার্থক্য হতে পারে।\n'
                    '• রমজান, ঈদ ও অন্যান্য ইসলামিক তারিখের জন্য আপনার দেশের সরকারি ঘোষণা অনুসরণ করুন।\n'
                    '• এই তারিখ শুধুমাত্র তথ্যের জন্য প্রদান করা হয়।',
              ),
              const SizedBox(height: 16),
              _buildWarningCard(
                icon: Icons.location_on,
                title: 'অবস্থান নির্ভুলতা',
                content:
                    'নামাজের সময় আপনার GPS অবস্থানের উপর নির্ভর করে।\n\n'
                    '• নিশ্চিত করুন যে GPS/Location Service চালু আছে।\n'
                    '• ইন্টারনেট সংযোগ থাকলে আরও সঠিক ফলাফল পাওয়া যায়।\n'
                    '• সেটিংস থেকে আপনি ম্যানুয়ালি অবস্থান নির্বাচন করতে পারেন।',
              ),
              const SizedBox(height: 16),
              _buildWarningCard(
                icon: Icons.calculate,
                title: 'হিসাব পদ্ধতি',
                content:
                    'এই অ্যাপে বিভিন্ন আন্তর্জাতিক হিসাব পদ্ধতি ব্যবহার করা হয়:\n\n'
                    '• ফজর ও ইশার কোণ হিসাব পদ্ধতি\n'
                    '• আসর হিসাবে Shafi/Hanafi মত\n'
                    '• সেটিংস থেকে আপনার পছন্দের পদ্ধতি নির্বাচন করতে পারেন।',
              ),
              const SizedBox(height: 16),
              _buildWarningCard(
                icon: Icons.alarm,
                title: 'অ্যালার্ম ও বিজ্ঞপ্তি',
                content:
                    'নামাজের অ্যালার্ম সেট করার জন্য:\n\n'
                    '• প্রথমবার অ্যাপ চালু করলে নোটিফিকেশন অনুমতি দিন।\n'
                    '• ব্যাটারি অপটিমাইজেশন থেকে এই অ্যাপটি বাদ দিন।\n'
                    '• ফোন সাইলেন্ট মোডে থাকলেও অ্যালার্ম বাজবে।',
              ),
              const SizedBox(height: 16),
              _buildWarningCard(
                icon: Icons.info_outline,
                title: 'সাধারণ পরামর্শ',
                content:
                    '• এই অ্যাপ একটি সহায়ক হিসেবে ব্যবহার করুন।\n'
                    '• গুরুত্বপূর্ণ বিষয়ে সর্বদা আলেম/ইমামের পরামর্শ নিন।\n'
                    '• কোন ত্রুটি পেলে সেটিংস চেক করুন।\n'
                    '• নিয়মিত অ্যাপ আপডেট করুন।',
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.teal.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.contact_support, color: Colors.teal.shade700, size: 30),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'কোন প্রশ্ন বা সমস্যা থাকলে সেটিংস থেকে যোগাযোগ করুন।',
                        style: GoogleFonts.notoSansBengali(
                          fontSize: 14,
                          color: Colors.teal.shade900,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWarningCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D9375).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: const Color(0xFF1D9375), size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.notoSansBengali(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: GoogleFonts.notoSansBengali(
              fontSize: 14,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
