import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/amal_provider.dart';

class AmalJournalPage extends StatelessWidget {
  const AmalJournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AmalProvider>(context);
    
    // ক্যালেন্ডার নেই, তাই আমরা সব সময় আজকের তারিখ ব্যবহার করব
    final DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final completedAmals = provider.getAmalsForDate(today);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "আজকের আমল", // <-- টাইটেল পরিবর্তন করা হয়েছে
          style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          // !! নতুন: মোট পয়েন্ট দেখানোর বাটন
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Chip(
              avatar: const Icon(Icons.star, color: Colors.amber, size: 18),
              label: Text(
                provider.totalPoints.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.amber.withValues(alpha: 0.1),
              side: BorderSide(color: Colors.amber.shade300),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView( // সম্পূর্ণ পৃষ্ঠা স্ক্রলযোগ্য
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- নতুন: ক্যাটাগরি Streak সেকশন ---
            _buildCategoryStreakSection(context, provider),

            // --- আমলের তালিকা (গ্রুপ করা) ---
            _buildAmalGroup(
              context,
              provider,
              'fardh', // ক্যাটাগরি আইডি
              'ফরজ ইবাদত', // সেকশন টাইটেল
              completedAmals,
              today, // <-- আজকের তারিখ পাস করা হয়েছে
            ),
            _buildAmalGroup(
              context,
              provider,
              'sunnah', 
              'সুন্নাহ ও জিকির',
              completedAmals,
              today,
            ),
            _buildAmalGroup(
              context,
              provider,
              'habit',
              'দৈনিক অভ্যাস',
              completedAmals,
              today,
            ),
            const SizedBox(height: 20), // তালিকার নিচে স্পেস
          ],
        ),
      ),
    );
  }

  // !! নতুন: ক্যাটাগরি Streak উইজেট
  Widget _buildCategoryStreakSection(BuildContext context, AmalProvider provider) {
    final fardhStreak = provider.getCategoryStreak('fardh');
    final sunnahStreak = provider.getCategoryStreak('sunnah');

    // যদি কোনো স্ট্রিম না থাকে, তবে এই সেকশনটি দেখাবেন না
    if (fardhStreak == 0 && sunnahStreak == 0) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "প্রতিদিন আমল করে স্ট্রিম তৈরি করুন!",
          style: GoogleFonts.notoSansBengali(fontSize: 16, color: Colors.grey[700]),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "আপনার চলমান আমল (Streaks)",
            style: GoogleFonts.notoSansBengali(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade800,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (fardhStreak > 0)
                Expanded(
                  child: _StreakCard(
                    title: "ফরজ আমল",
                    streak: fardhStreak,
                    icon: Icons.mosque_outlined,
                    color: Colors.teal,
                  ),
                ),
              if (fardhStreak > 0) const SizedBox(width: 12),
              if (sunnahStreak > 0)
                Expanded(
                  child: _StreakCard(
                    title: "সুন্নাহ আমল",
                    streak: sunnahStreak,
                    icon: Icons.wb_sunny_outlined,
                    color: Colors.orange,
                  ),
                ),
            ],
          ),
          const Divider(height: 24),
        ],
      ),
    );
  }


  // --- আমল গ্রুপ বিল্ডার ---
  Widget _buildAmalGroup(
    BuildContext context,
    AmalProvider provider,
    String category,
    String title,
    List<String> completedAmals,
    DateTime date, // <-- তারিখ গ্রহণ করুন
  ) {
    final amals = provider.getAmalsByCategory(category);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // সেকশন হেডার
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Text(
              title,
              style: GoogleFonts.notoSansBengali(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          // আমল আইটেমের কলাম
          Column(
            children: amals.map((amal) {
              final isDone = completedAmals.contains(amal.id);
              return _AmalItem(
                amal: amal,
                isDone: isDone,
                onTap: () {
                  // এখানে সব সময় 'date' (অর্থাৎ আজকের তারিখ) পাস করুন
                  provider.toggleAmal(date, amal.id);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// --- নতুন: ক্যাটাগরি Streak কার্ড উইজেট ---
class _StreakCard extends StatelessWidget {
  final String title;
  final int streak;
  final IconData icon;
  final Color color;

  const _StreakCard({
    required this.title,
    required this.streak,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.notoSansBengali(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.local_fire_department_rounded, color: color, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "$streak দিন",
                        style: GoogleFonts.notoSansBengali(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// --- কাস্টম আমল আইটেম উইজেট ---
class _AmalItem extends StatelessWidget {
  final Amal amal;
  final bool isDone;
  final VoidCallback onTap;

  const _AmalItem({
    required this.amal,
    required this.isDone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDone ? Colors.teal.withValues(alpha: 0.08) : Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0), // প্যাডিং বাড়ানো হয়েছে
          child: Row(
            children: [
              // আইকন
              Icon(
                amal.icon,
                size: 28,
                color: isDone ? Colors.teal.shade700 : Colors.grey.shade600,
              ),
              const SizedBox(width: 16),
              // টাইটেল
              Expanded(
                child: Text(
                  amal.title,
                  style: GoogleFonts.notoSansBengali(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDone ? Colors.black54 : Colors.black,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                    decorationColor: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // কাস্টম চেকবক্স
              Icon(
                isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                size: 28,
                color: isDone ? Colors.teal : Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}