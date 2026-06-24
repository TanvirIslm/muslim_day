import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CommunityHubPage extends StatefulWidget {
  const CommunityHubPage({super.key});

  @override
  State<CommunityHubPage> createState() => _CommunityHubPageState();
}

class _CommunityHubPageState extends State<CommunityHubPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          'কমিউনিটি',
          style: GoogleFonts.notoSansBengali(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1A4D4D),
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          isScrollable: true,
          labelStyle: GoogleFonts.notoSansBengali(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          tabs: const [
            Tab(text: 'আসন্ন ইভেন্ট'),
            Tab(text: 'গুরুত্বপূর্ণ দিবস'),
            Tab(text: 'বই ও প্রবন্ধ'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUpcomingEvents(),
          _buildImportantDates(),
          _buildBooksAndArticles(),
        ],
      ),
    );
  }

  Widget _buildUpcomingEvents() {
    final upcomingEvents = [
      {
        'title': 'জুমার খুতবা',
        'subtitle': 'স্থানীয় মসজিদে',
        'date': _getNextFriday(),
        'time': '১:০০ PM',
        'icon': Icons.mosque,
        'color': const Color(0xFF1D9375),
        'type': 'সাপ্তাহিক',
      },
      {
        'title': 'কুরআন তাফসীর ক্লাস',
        'subtitle': 'অনলাইন সেশন',
        'date': DateTime.now().add(const Duration(days: 2)),
        'time': '৮:০০ PM',
        'icon': Icons.book,
        'color': const Color(0xFF2196F3),
        'type': 'শিক্ষামূলক',
      },
      {
        'title': 'ফজরে মসজিদে জামাত',
        'subtitle': 'প্রতিদিন সকাল',
        'date': DateTime.now(),
        'time': 'ফজরের সময়',
        'icon': Icons.brightness_2,
        'color': const Color(0xFF673AB7),
        'type': 'দৈনিক',
      },
      {
        'title': 'হালাকা (আলোচনা সভা)',
        'subtitle': 'ইসলামিক স্টাডিজ সেন্টার',
        'date': DateTime.now().add(const Duration(days: 5)),
        'time': '৬:০০ PM',
        'icon': Icons.groups,
        'color': const Color(0xFFFF9800),
        'type': 'সাপ্তাহিক',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: upcomingEvents.length,
      itemBuilder: (context, index) {
        final event = upcomingEvents[index];
        return _buildEventCard(
          title: event['title'] as String,
          subtitle: event['subtitle'] as String,
          date: event['date'] as DateTime,
          time: event['time'] as String,
          icon: event['icon'] as IconData,
          color: event['color'] as Color,
          type: event['type'] as String,
        );
      },
    );
  }

  Widget _buildImportantDates() {
    final islamicDates = _getIslamicImportantDates();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: islamicDates.length,
      itemBuilder: (context, index) {
        final dateInfo = islamicDates[index];
        return _buildIslamicDateCard(
          title: dateInfo['title'] as String,
          arabicName: dateInfo['arabicName'] as String,
          hijriDate: dateInfo['hijriDate'] as String,
          gregorianDate: dateInfo['gregorianDate'] as DateTime,
          description: dateInfo['description'] as String,
          significance: dateInfo['significance'] as String,
          icon: dateInfo['icon'] as IconData,
          color: dateInfo['color'] as Color,
        );
      },
    );
  }

  Widget _buildBooksAndArticles() {
    final resources = [
      {
        'title': 'রিয়াদুস সালিহীন',
        'author': 'ইমাম নববী (রহ.)',
        'type': 'হাদীস সংকলন',
        'description': 'সহীহ হাদীসের একটি নির্বাচিত সংকলন',
        'icon': Icons.menu_book,
        'color': const Color(0xFF1D9375),
      },
      {
        'title': 'তাফসীর ইবনে কাসীর',
        'author': 'ইমাম ইবনে কাসীর (রহ.)',
        'type': 'তাফসীর',
        'description': 'কুরআনের বিখ্যাত তাফসীর গ্রন্থ',
        'icon': Icons.book_outlined,
        'color': const Color(0xFF2196F3),
      },
      {
        'title': 'ফিকহুস সুন্নাহ',
        'author': 'শাইখ সাইয়্যিদ সাবিক',
        'type': 'ফিকহ',
        'description': 'ইসলামী আইনশাস্ত্রের ব্যাপক আলোচনা',
        'icon': Icons.gavel,
        'color': const Color(0xFFFF9800),
      },
      {
        'title': 'হিসনুল মুসলিম',
        'author': 'শাইখ সাঈদ আল-কাহতানী',
        'type': 'দোয়া ও জিকির',
        'description': 'দৈনন্দিন জীবনের দোয়া ও জিকির',
        'icon': Icons.favorite_border,
        'color': const Color(0xFFE91E63),
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: resources.length,
      itemBuilder: (context, index) {
        final resource = resources[index];
        return _buildResourceCard(
          title: resource['title'] as String,
          author: resource['author'] as String,
          type: resource['type'] as String,
          description: resource['description'] as String,
          icon: resource['icon'] as IconData,
          color: resource['color'] as Color,
        );
      },
    );
  }

  Widget _buildEventCard({
    required String title,
    required String subtitle,
    required DateTime date,
    required String time,
    required IconData icon,
    required Color color,
    required String type,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Show event details
          _showEventDetails(title, subtitle, date, time, type);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.notoSansBengali(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.notoSansBengali(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            DateFormat('dd MMM, yyyy', 'bn_BD').format(date),
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            time,
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  type,
                  style: GoogleFonts.notoSansBengali(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIslamicDateCard({
    required String title,
    required String arabicName,
    required String hijriDate,
    required DateTime gregorianDate,
    required String description,
    required String significance,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(
          title,
          style: GoogleFonts.notoSansBengali(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              arabicName,
              style: GoogleFonts.amiriQuran(
                fontSize: 14,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$hijriDate • ${DateFormat('dd MMMM, yyyy', 'bn_BD').format(gregorianDate)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'বিবরণ:',
                  style: GoogleFonts.notoSansBengali(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: GoogleFonts.notoSansBengali(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'গুরুত্ব:',
                  style: GoogleFonts.notoSansBengali(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  significance,
                  style: GoogleFonts.notoSansBengali(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceCard({
    required String title,
    required String author,
    required String type,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          _showResourceDetails(title, author, type, description);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.notoSansBengali(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      author,
                      style: GoogleFonts.notoSansBengali(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        type,
                        style: GoogleFonts.notoSansBengali(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  DateTime _getNextFriday() {
    final now = DateTime.now();
    final daysUntilFriday = (DateTime.friday - now.weekday) % 7;
    return now.add(Duration(days: daysUntilFriday == 0 ? 7 : daysUntilFriday));
  }

  List<Map<String, dynamic>> _getIslamicImportantDates() {
    // This is a simplified version. In production, you'd calculate actual Islamic dates
    final now = DateTime.now();
    
    return [
      {
        'title': 'লাইলাতুল কদর',
        'arabicName': 'ليلة القدر',
        'hijriDate': '২৭ রমজান',
        'gregorianDate': now.add(const Duration(days: 30)),
        'description': 'লাইলাতুল কদর হল রমজান মাসের শেষ দশকের একটি বিশেষ রাত, যা হাজার মাসের চেয়েও উত্তম।',
        'significance': 'এই রাতে কুরআন নাযিল হয়েছিল। এই রাতে ইবাদত করলে হাজার মাসের ইবাদতের চেয়ে বেশি সওয়াব পাওয়া যায়।',
        'icon': Icons.star,
        'color': const Color(0xFFFFD700),
      },
      {
        'title': 'ঈদুল ফিতর',
        'arabicName': 'عيد الفطر',
        'hijriDate': '১ শাওয়াল',
        'gregorianDate': now.add(const Duration(days: 35)),
        'description': 'রমজান মাসের রোজার পর উদযাপিত মুসলিমদের প্রধান উৎসব।',
        'significance': 'এই দিনে মুসলিমরা ঈদের নামাজ পড়ে, জাকাত আদায় করে এবং পরিবার-পরিজনের সাথে খুশি ভাগাভাগি করে।',
        'icon': Icons.celebration,
        'color': const Color(0xFF4CAF50),
      },
      {
        'title': 'ঈদুল আযহা',
        'arabicName': 'عيد الأضحى',
        'hijriDate': '১০ জিলহজ্জ',
        'gregorianDate': now.add(const Duration(days: 100)),
        'description': 'হজ্জের পর উদযাপিত বলিদানের ঈদ।',
        'significance': 'এই দিনে হযরত ইব্রাহীম (আ.) এর আত্মত্যাগের স্মরণে পশু কুরবানী করা হয়।',
        'icon': Icons.mosque,
        'color': const Color(0xFFE91E63),
      },
      {
        'title': 'আশুরা',
        'arabicName': 'عاشوراء',
        'hijriDate': '১০ মুহাররম',
        'gregorianDate': now.add(const Duration(days: 150)),
        'description': 'মুহাররম মাসের দশম দিন, একটি গুরুত্বপূর্ণ ইসলামী দিবস।',
        'significance': 'এই দিনে রোজা রাখা সুন্নাহ। এই দিনে হযরত মুসা (আ.) ফেরাউনের হাত থেকে মুক্তি পেয়েছিলেন।',
        'icon': Icons.water_drop,
        'color': const Color(0xFF2196F3),
      },
      {
        'title': 'শবে মিরাজ',
        'arabicName': 'ليلة المعراج',
        'hijriDate': '২৭ রজব',
        'gregorianDate': now.add(const Duration(days: 200)),
        'description': 'রাসূলুল্লাহ (সা.) এর মিরাজে গমনের রাত।',
        'significance': 'এই রাতে পাঁচ ওয়াক্ত নামাজ ফরজ হয়েছিল। মুসলিমরা এই রাতে বিশেষ ইবাদত করে।',
        'icon': Icons.nights_stay,
        'color': const Color(0xFF673AB7),
      },
    ];
  }

  void _showEventDetails(String title, String subtitle, DateTime date, String time, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subtitle,
              style: GoogleFonts.notoSansBengali(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  DateFormat('dd MMMM, yyyy', 'bn_BD').format(date),
                  style: GoogleFonts.notoSansBengali(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(time, style: GoogleFonts.notoSansBengali(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.category, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(type, style: GoogleFonts.notoSansBengali(fontSize: 14)),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'বন্ধ করুন',
              style: GoogleFonts.notoSansBengali(color: const Color(0xFF1D9375)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Add to calendar functionality
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'ক্যালেন্ডারে যোগ করা হয়েছে',
                    style: GoogleFonts.notoSansBengali(),
                  ),
                  backgroundColor: const Color(0xFF1D9375),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D9375),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              'ক্যালেন্ডারে যোগ করুন',
              style: GoogleFonts.notoSansBengali(),
            ),
          ),
        ],
      ),
    );
  }

  void _showResourceDetails(String title, String author, String type, String description) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'লেখক: $author',
              style: GoogleFonts.notoSansBengali(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1D9375).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                type,
                style: GoogleFonts.notoSansBengali(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1D9375),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: GoogleFonts.notoSansBengali(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'বন্ধ করুন',
              style: GoogleFonts.notoSansBengali(color: const Color(0xFF1D9375)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Open resource or download
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'শীঘ্রই উপলব্ধ হবে',
                    style: GoogleFonts.notoSansBengali(),
                  ),
                  backgroundColor: const Color(0xFF1D9375),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D9375),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              'পড়ুন',
              style: GoogleFonts.notoSansBengali(),
            ),
          ),
        ],
      ),
    );
  }
}
