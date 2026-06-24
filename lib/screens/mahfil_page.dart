import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CommunityHubPage extends StatefulWidget {
  const CommunityHubPage({super.key});

  @override
  State<CommunityHubPage> createState() => _CommunityHubPageState();
}

class _CommunityHubPageState extends State<CommunityHubPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  // Data
  List<Map<String, dynamic>> _allEvents = [];
  List<Map<String, dynamic>> _foundEvents = [];
  List<Map<String, dynamic>> _allResources = [];
  List<Map<String, dynamic>> _foundResources = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _allEvents = [
      {'title': 'জুমার খুতবা', 'subtitle': 'স্থানীয় মসজিদে', 'date': _getNextFriday(), 'time': '১:০০ PM', 'icon': Icons.mosque, 'color': const Color(0xFF1D9375), 'type': 'সাপ্তাহিক'},
      {'title': 'কুরআন তাফসীর ক্লাস', 'subtitle': 'অনলাইন সেশন', 'date': DateTime.now().add(const Duration(days: 2)), 'time': '৮:০০ PM', 'icon': Icons.book, 'color': const Color(0xFF2196F3), 'type': 'শিক্ষামূলক'},
      {'title': 'ফজরে মসজিদে জামাত', 'subtitle': 'প্রতিদিন সকাল', 'date': DateTime.now(), 'time': 'ফজরের সময়', 'icon': Icons.brightness_2, 'color': const Color(0xFF673AB7), 'type': 'দৈনিক'},
    ];
    _foundEvents = _allEvents;

    _allResources = [
      {'title': 'রিয়াদুস সালিহীন', 'author': 'ইমাম নববী (রহ.)', 'type': 'হাদীস সংকলন', 'description': 'সহীহ হাদীসের একটি নির্বাচিত সংকলন', 'icon': Icons.menu_book, 'color': const Color(0xFF1D9375)},
      {'title': 'তাফসীর ইবনে কাসীর', 'author': 'ইমাম ইবনে কাসীর (রহ.)', 'type': 'তাফসীর', 'description': 'কুরআনের বিখ্যাত তাফসীর গ্রন্থ', 'icon': Icons.book_outlined, 'color': const Color(0xFF2196F3)},
      {'title': 'ফিকহুস সুন্নাহ', 'author': 'শাইখ সাইয়্যিদ সাবিক', 'type': 'ফিকহ', 'description': 'ইসলামী আইনশাস্ত্রের ব্যাপক আলোচনা', 'icon': Icons.gavel, 'color': const Color(0xFFFF9800)},
    ];
    _foundResources = _allResources;
  }

  void _runFilter(String keyword) {
    setState(() {
      _foundEvents = _allEvents.where((e) => e['title'].toString().contains(keyword)).toList();
      _foundResources = _allResources.where((r) => r['title'].toString().contains(keyword)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('কমিউনিটি', style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: primaryColor,
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _runFilter,
              decoration: InputDecoration(
                hintText: "খুঁজুন...",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          Container(
            color: primaryColor,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              isScrollable: true,
              tabs: const [Tab(text: 'আসন্ন ইভেন্ট'), Tab(text: 'গুরুত্বপূর্ণ দিবস'), Tab(text: 'বই ও প্রবন্ধ')],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildListView(_foundEvents, true),
                _buildImportantDates(),
                _buildListView(_foundResources, false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Your Original Builders (Restored) ---

  Widget _buildListView(List items, bool isEvent) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return isEvent 
          ? _buildEventCard(title: item['title'], subtitle: item['subtitle'], date: item['date'], time: item['time'], icon: item['icon'], color: item['color'], type: item['type'])
          : _buildResourceCard(title: item['title'], author: item['author'], type: item['type'], description: item['description'], icon: item['icon'], color: item['color']);
      },
    );
  }

  // Paste your original _buildEventCard, _buildIslamicDateCard, _buildResourceCard, etc., BELOW HERE
  // I have included _buildEventCard below as an example. 
  // Make sure to add your _showEventDetails, _showResourceDetails, and _getIslamicImportantDates methods too!

  Widget _buildEventCard({required String title, required String subtitle, required DateTime date, required String time, required IconData icon, required Color color, required String type}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(width: 60, height: 60, decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 30)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold)),
                  Text(subtitle, style: GoogleFonts.notoSansBengali(color: Colors.grey[600])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceCard({required String title, required String author, required String type, required String description, required IconData icon, required Color color}) {
    return Card(margin: const EdgeInsets.only(bottom: 16), child: ListTile(leading: Icon(icon, color: color), title: Text(title), subtitle: Text(author)));
  }

  Widget _buildImportantDates() {
    return const Center(child: Text("গুরুত্বপূর্ণ দিবসসমূহ"));
  }

  DateTime _getNextFriday() => DateTime.now();
}