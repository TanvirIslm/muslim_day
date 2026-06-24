import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';

class LearningPathPage extends StatefulWidget {
  const LearningPathPage({super.key});

  @override
  State<LearningPathPage> createState() => _LearningPathPageState();
}

class _LearningPathPageState extends State<LearningPathPage> {
  String selectedPath = 'beginner';
  Map<String, double> progressData = {
    'beginner': 0.35,
    'intermediate': 0.20,
    'advanced': 0.05,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ইসলামিক শিক্ষার পথ',
          style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Path Selector
          _buildPathSelector(),

          // Progress Overview
          _buildProgressOverview(),

          // Lesson List
          Expanded(
            child: _buildLessonList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPathSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF1D9375).withValues(alpha: 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'আপনার শিক্ষার পথ নির্বাচন করুন',
            style: GoogleFonts.notoSansBengali(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildPathCard(
                  'beginner',
                  'প্রাথমিক',
                  'ইসলামের মৌলিক বিষয়',
                  Icons.school,
                  const Color(0xFF4CAF50),
                ),
                const SizedBox(width: 12),
                _buildPathCard(
                  'intermediate',
                  'মাধ্যমিক',
                  'ফিকহ ও হাদিস',
                  Icons.menu_book,
                  const Color(0xFF2196F3),
                ),
                const SizedBox(width: 12),
                _buildPathCard(
                  'advanced',
                  'উন্নত',
                  'তাফসীর ও আরবি',
                  Icons.auto_stories,
                  const Color(0xFF9C27B0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPathCard(
    String id,
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    final isSelected = selectedPath == id;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPath = id;
        });
      },
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? Colors.white : color,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.notoSansBengali(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.notoSansBengali(
                fontSize: 11,
                color: isSelected ? Colors.white70 : Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressOverview() {
    final progress = progressData[selectedPath] ?? 0.0;
    final completedLessons = (progress * 20).round();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1D9375), Color(0xFF1A4D4D)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 50,
            lineWidth: 10,
            percent: progress,
            center: Text(
              '${(progress * 100).toInt()}%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            progressColor: Colors.white,
            backgroundColor: Colors.white24,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'আপনার অগ্রগতি',
                  style: GoogleFonts.notoSansBengali(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$completedLessons টি পাঠ সম্পন্ন',
                  style: GoogleFonts.notoSansBengali(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${20 - completedLessons} টি বাকি আছে',
                  style: GoogleFonts.notoSansBengali(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonList() {
    final lessons = _getLessonsForPath(selectedPath);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        final lesson = lessons[index];
        return _buildLessonCard(lesson, index);
      },
    );
  }

  Widget _buildLessonCard(Map<String, dynamic> lesson, int index) {
    final isCompleted = lesson['completed'] as bool;
    final isLocked = lesson['locked'] as bool;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: isLocked
            ? null
            : () {
                _showLessonDetail(lesson);
              },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Lesson Number/Status
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? const Color(0xFF4CAF50)
                      : isLocked
                          ? Colors.grey.shade300
                          : const Color(0xFF1D9375),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white)
                      : isLocked
                          ? const Icon(Icons.lock, color: Colors.white70)
                          : Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                ),
              ),
              const SizedBox(width: 16),

              // Lesson Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson['title'] as String,
                      style: GoogleFonts.notoSansBengali(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isLocked ? Colors.grey : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lesson['duration'] as String,
                      style: GoogleFonts.notoSansBengali(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    if (isCompleted)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '১০০ পয়েন্ট',
                              style: GoogleFonts.notoSansBengali(
                                fontSize: 11,
                                color: Colors.amber.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // Arrow or Lock
              Icon(
                isLocked ? Icons.lock : Icons.arrow_forward_ios,
                size: 16,
                color: isLocked ? Colors.grey : const Color(0xFF1D9375),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getLessonsForPath(String path) {
    switch (path) {
      case 'beginner':
        return [
          {
            'title': 'ঈমানের রুকন',
            'duration': '১৫ মিনিট',
            'completed': true,
            'locked': false,
            'content': 'ঈমানের ছয়টি রুকন সম্পর্কে বিস্তারিত আলোচনা।',
          },
          {
            'title': 'ইসলামের স্তম্ভ',
            'duration': '২০ মিনিট',
            'completed': true,
            'locked': false,
            'content': 'ইসলামের পাঁচটি স্তম্ভ এবং তাদের গুরুত্ব।',
          },
          {
            'title': 'কালিমা তাইয়্যিবা',
            'duration': '১০ মিনিট',
            'completed': true,
            'locked': false,
            'content': 'কালিমার অর্থ ও তাৎপর্য।',
          },
          {
            'title': 'ওজু করার নিয়ম',
            'duration': '২৫ মিনিট',
            'completed': true,
            'locked': false,
            'content': 'ধাপে ধাপে ওজু করার সঠিক পদ্ধতি।',
          },
          {
            'title': 'নামাজের ফরজ',
            'duration': '৩০ মিনিট',
            'completed': true,
            'locked': false,
            'content': 'নামাজের ফরজ ও ওয়াজিব সম্পর্কে।',
          },
          {
            'title': 'সূরা ফাতিহা শেখা',
            'duration': '২০ মিনিট',
            'completed': true,
            'locked': false,
            'content': 'সূরা ফাতিহা মুখস্থ করা ও অর্থ বোঝা।',
          },
          {
            'title': 'ছোট সূরা শেখা',
            'duration': '৩৫ মিনিট',
            'completed': true,
            'locked': false,
            'content': 'সূরা ইখলাস, ফালাক, নাস শেখা।',
          },
          {
            'title': 'নামাজ পড়ার পদ্ধতি',
            'duration': '৪০ মিনিট',
            'completed': false,
            'locked': false,
            'content': 'প্রথম থেকে শেষ পর্যন্ত নামাজের পদ্ধতি।',
          },
          {
            'title': 'রোজার বিধান',
            'duration': '২৫ মিনিট',
            'completed': false,
            'locked': true,
            'content': 'রোজার ফরজ, সুন্নাহ এবং মাকরূহ।',
          },
          {
            'title': 'যাকাতের নিয়ম',
            'duration': '৩০ মিনিট',
            'completed': false,
            'locked': true,
            'content': 'যাকাত কী, কাদের দিতে হয় এবং কিভাবে।',
          },
        ];
      case 'intermediate':
        return [
          {
            'title': 'হাদিস পরিচিতি',
            'duration': '৩০ মিনিট',
            'completed': true,
            'locked': false,
            'content': 'হাদিসের শ্রেণীবিভাগ ও সহীহ হাদিস চেনার উপায়।',
          },
          {
            'title': 'সহীহ বুখারী ও মুসলিম',
            'duration': '৪০ মিনিট',
            'completed': true,
            'locked': false,
            'content': 'দুই সহীহ কিতাবের পরিচয়।',
          },
          {
            'title': 'ফিকহের মূলনীতি',
            'duration': '৪৫ মিনিট',
            'completed': true,
            'locked': false,
            'content': 'ফিকহের চার মূলনীতি: কুরআন, সুন্নাহ, ইজমা, কিয়াস।',
          },
          {
            'title': 'ইবাদতের ফিকহ',
            'duration': '৫০ মিনিট',
            'completed': true,
            'locked': false,
            'content': 'ইবাদত সংক্রান্ত বিস্তারিত মাসায়েল।',
          },
          {
            'title': 'পরিবার ও সমাজ',
            'duration': '৩৫ মিনিট',
            'completed': false,
            'locked': false,
            'content': 'পারিবারিক ও সামাজিক বিধান।',
          },
          {
            'title': 'বিয়ে ও তালাক',
            'duration': '৪৫ মিনিট',
            'completed': false,
            'locked': true,
            'content': 'বিয়ে ও তালাকের শরয়ী বিধান।',
          },
          {
            'title': 'হালাল-হারাম',
            'duration': '৪০ মিনিট',
            'completed': false,
            'locked': true,
            'content': 'খাদ্য, পানীয় ও কাজের হালাল-হারাম।',
          },
          {
            'title': 'ব্যবসা ও লেনদেন',
            'duration': '৫০ মিনিট',
            'completed': false,
            'locked': true,
            'content': 'ইসলামী অর্থনীতির মূলনীতি।',
          },
        ];
      case 'advanced':
        return [
          {
            'title': 'তাফসীর পরিচিতি',
            'duration': '৬০ মিনিট',
            'completed': true,
            'locked': false,
            'content': 'তাফসীরের ইতিহাস ও পদ্ধতি।',
          },
          {
            'title': 'সূরা বাকারা তাফসীর',
            'duration': '১২০ মিনিট',
            'completed': false,
            'locked': false,
            'content': 'সূরা বাকারার প্রথম রুকু।',
          },
          {
            'title': 'আরবি ব্যাকরণ - ১',
            'duration': '৯০ মিনিট',
            'completed': false,
            'locked': true,
            'content': 'নাহু ও সরফের মূলনীতি।',
          },
          {
            'title': 'কুরআনের উলূম',
            'duration': '৭৫ মিনিট',
            'completed': false,
            'locked': true,
            'content': 'মক্কী-মাদানী, নাসিখ-মানসূখ ইত্যাদি।',
          },
        ];
      default:
        return [];
    }
  }

  void _showLessonDetail(Map<String, dynamic> lesson) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
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
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson['title'] as String,
                    style: GoogleFonts.notoSansBengali(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        lesson['duration'] as String,
                        style: GoogleFonts.notoSansBengali(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Text(
                  lesson['content'] as String,
                  style: GoogleFonts.notoSansBengali(
                    fontSize: 16,
                    height: 1.8,
                  ),
                ),
              ),
            ),

            // Action Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      lesson['completed'] = true;
                      // Update progress
                      final currentProgress = progressData[selectedPath] ?? 0.0;
                      progressData[selectedPath] =
                          (currentProgress + 0.05).clamp(0.0, 1.0);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '✅ পাঠ সম্পন্ন! ১০০ পয়েন্ট পেয়েছেন',
                          style: GoogleFonts.notoSansBengali(),
                        ),
                        backgroundColor: const Color(0xFF4CAF50),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D9375),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    lesson['completed'] as bool
                        ? 'পুনরায় পড়ুন'
                        : 'পাঠ শুরু করুন',
                    style: GoogleFonts.notoSansBengali(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
