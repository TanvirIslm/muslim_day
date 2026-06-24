import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class PrayerStreakPage extends StatefulWidget {
  const PrayerStreakPage({super.key});

  @override
  State<PrayerStreakPage> createState() => _PrayerStreakPageState();
}

class _PrayerStreakPageState extends State<PrayerStreakPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int currentStreak = 12;
  int bestStreak = 45;
  int totalPoints = 3250;
  int level = 8;

  final List<Map<String, dynamic>> badges = [
    {
      'title': 'প্রথম পদক্ষেপ',
      'subtitle': '৭ দিন স্ট্রিক',
      'icon': Icons.star,
      'color': Colors.amber,
      'unlocked': true,
    },
    {
      'title': 'নিয়মিত মুসল্লি',
      'subtitle': '৩০ দিন স্ট্রিক',
      'icon': Icons.emoji_events,
      'color': Colors.orange,
      'unlocked': true,
    },
    {
      'title': 'ফজরের বীর',
      'subtitle': '২১ দিন ফজর',
      'icon': Icons.wb_sunny,
      'color': Colors.deepOrange,
      'unlocked': true,
    },
    {
      'title': 'তাহাজ্জুদ প্রেমী',
      'subtitle': '১৫ দিন তাহাজ্জুদ',
      'icon': Icons.nightlight,
      'color': Colors.indigo,
      'unlocked': false,
    },
    {
      'title': 'কুরআন পাঠক',
      'subtitle': '১০০ পৃষ্ঠা পড়া',
      'icon': Icons.menu_book,
      'color': Colors.green,
      'unlocked': true,
    },
    {
      'title': 'দোয়া মুখস্থকারী',
      'subtitle': '২৫টি দোয়া',
      'icon': Icons.favorite,
      'color': Colors.red,
      'unlocked': false,
    },
    {
      'title': 'মাস্টার মুমিন',
      'subtitle': '১০০ দিন স্ট্রিক',
      'icon': Icons.military_tech,
      'color': Colors.purple,
      'unlocked': false,
    },
    {
      'title': 'রমজান চ্যাম্পিয়ন',
      'subtitle': 'পূর্ণ রমজান',
      'icon': Icons.calendar_month,
      'color': Colors.teal,
      'unlocked': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildStreakCard(),
                _buildLevelCard(),
                _buildWeeklyProgress(),
                _buildAchievements(),
                _buildLeaderboard(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'নামাজ স্ট্রিক',
          style: GoogleFonts.notoSansBengali(
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1D9375), Color(0xFF1A4D4D)],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: () {
            _showHelpDialog();
          },
        ),
      ],
    );
  }

  Widget _buildStreakCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFF6F00)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStreakStat(
                '🔥',
                '$currentStreak',
                'বর্তমান স্ট্রিক',
              ),
              Container(
                width: 2,
                height: 50,
                color: Colors.white30,
              ),
              _buildStreakStat(
                '🏆',
                '$bestStreak',
                'সর্বোচ্চ স্ট্রিক',
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.stars, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  '$totalPoints পয়েন্ট',
                  style: GoogleFonts.notoSansBengali(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakStat(String emoji, String value, String label) {
    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 36),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.notoSansBengali(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildLevelCard() {
    final progress = (level % 10) / 10;
    final nextLevelPoints = (level + 1) * 500;
    final currentLevelPoints = totalPoints % 500;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1D9375), Color(0xFF1A4D4D)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'লেভেল $level',
                    style: GoogleFonts.notoSansBengali(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '$currentLevelPoints / $nextLevelPoints',
                  style: GoogleFonts.notoSansBengali(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF1D9375),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'পরবর্তী লেভেলে আরও ${nextLevelPoints - currentLevelPoints} পয়েন্ট প্রয়োজন',
              style: GoogleFonts.notoSansBengali(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyProgress() {
    final days = ['সোম', 'মঙ্গল', 'বুধ', 'বৃহঃ', 'শুক্র', 'শনি', 'রবি'];
    final prayers = [5, 5, 5, 4, 5, 5, 3]; // Number of prayers per day

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'এই সপ্তাহের অগ্রগতি',
              style: GoogleFonts.notoSansBengali(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                return _buildDayColumn(days[index], prayers[index]);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayColumn(String day, int count) {
    final isComplete = count == 5;
    return Column(
      children: [
        Text(
          day,
          style: GoogleFonts.notoSansBengali(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 36,
          height: 60,
          decoration: BoxDecoration(
            color: isComplete
                ? const Color(0xFF4CAF50)
                : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isComplete ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isComplete ? Colors.white : Colors.grey,
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                '$count/5',
                style: GoogleFonts.notoSansBengali(
                  color: isComplete ? Colors.white : Colors.grey,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAchievements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Text(
            'অর্জন ও ব্যাজ',
            style: GoogleFonts.notoSansBengali(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: badges.length,
            itemBuilder: (context, index) {
              return _buildBadgeCard(badges[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBadgeCard(Map<String, dynamic> badge) {
    final isUnlocked = badge['unlocked'] as bool;
    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Card(
        color: isUnlocked ? Colors.white : Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  if (isUnlocked)
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _animationController.value * 2 * math.pi,
                          child: Icon(
                            Icons.auto_awesome,
                            size: 50,
                            color: (badge['color'] as Color).withValues(alpha: 0.2),
                          ),
                        );
                      },
                    ),
                  Icon(
                    badge['icon'] as IconData,
                    size: 40,
                    color: isUnlocked
                        ? badge['color'] as Color
                        : Colors.grey.shade400,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                badge['title'] as String,
                style: GoogleFonts.notoSansBengali(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: isUnlocked ? Colors.black87 : Colors.grey,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              const SizedBox(height: 4),
              Text(
                badge['subtitle'] as String,
                style: GoogleFonts.notoSansBengali(
                  fontSize: 10,
                  color: isUnlocked ? Colors.grey : Colors.grey.shade400,
                ),
                textAlign: TextAlign.center,
              ),
              if (!isUnlocked)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock, size: 10, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        'লক করা',
                        style: GoogleFonts.notoSansBengali(
                          fontSize: 9,
                          color: Colors.grey.shade600,
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

  Widget _buildLeaderboard() {
    final leaders = [
      {'name': 'আপনি', 'points': totalPoints, 'rank': 12},
      {'name': 'মোহাম্মদ আলী', 'points': 4500, 'rank': 1},
      {'name': 'ফাতিমা খাতুন', 'points': 4200, 'rank': 2},
      {'name': 'আব্দুল্লাহ', 'points': 3800, 'rank': 3},
      {'name': 'আয়েশা', 'points': 3600, 'rank': 4},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Row(
            children: [
              Text(
                'লিডারবোর্ড',
                style: GoogleFonts.notoSansBengali(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'লিডারবোর্ড ফিচার শীঘ্রই আসছে',
                        style: GoogleFonts.notoSansBengali(),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.leaderboard, size: 18),
                label: Text(
                  'সব দেখুন',
                  style: GoogleFonts.notoSansBengali(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        ...leaders.map((leader) => _buildLeaderTile(leader)),
      ],
    );
  }

  Widget _buildLeaderTile(Map<String, dynamic> leader) {
    final isYou = leader['name'] == 'আপনি';
    final rank = leader['rank'] as int;
    
    Color getRankColor() {
      if (rank == 1) return Colors.amber;
      if (rank == 2) return Colors.grey.shade400;
      if (rank == 3) return Colors.orange.shade700;
      return Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: isYou ? const Color(0xFF1D9375).withValues(alpha: 0.1) : null,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: getRankColor().withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: rank <= 3
                ? Icon(Icons.emoji_events, color: getRankColor(), size: 20)
                : Text(
                    '#$rank',
                    style: GoogleFonts.notoSansBengali(
                      fontWeight: FontWeight.bold,
                      color: getRankColor(),
                    ),
                  ),
          ),
        ),
        title: Text(
          leader['name'] as String,
          style: GoogleFonts.notoSansBengali(
            fontWeight: isYou ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.stars, color: Colors.amber, size: 18),
            const SizedBox(width: 4),
            Text(
              '${leader['points']}',
              style: GoogleFonts.notoSansBengali(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1D9375),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'স্ট্রিক কীভাবে কাজ করে?',
          style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHelpItem('🔥', 'প্রতিদিন ৫ ওয়াক্ত নামাজ পড়ুন'),
              _buildHelpItem('⭐', 'প্রতি নামাজে ২০ পয়েন্ট পাবেন'),
              _buildHelpItem('🏆', 'স্ট্রিক বজায় রাখলে বোনাস পয়েন্ট'),
              _buildHelpItem('🎖️', 'ব্যাজ আনলক করে বিশেষ পুরস্কার পান'),
              _buildHelpItem('📈', 'লেভেল আপ করে নতুন ফিচার খুলুন'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'বুঝেছি',
              style: GoogleFonts.notoSansBengali(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.notoSansBengali(height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
