import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MasnoonAmalPage extends StatefulWidget {
  const MasnoonAmalPage({super.key});

  @override
  State<MasnoonAmalPage> createState() => _MasnoonAmalPageState();
}

class _MasnoonAmalPageState extends State<MasnoonAmalPage> {
  String _selectedCategory = 'দৈনিক';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          'মাসনুন আমল',
          style: GoogleFonts.notoSansBengali(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1A4D4D),
        elevation: 2,
      ),
      body: Column(
        children: [
          _buildCategoryTabs(),
          Expanded(
            child: _buildAmalList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    final categories = ['দৈনিক', 'সাপ্তাহিক', 'মাসিক', 'বাৎসরিক'];

    return Container(
      height: 50,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1D9375) : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Text(
                category,
                style: GoogleFonts.notoSansBengali(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAmalList() {
    final amalList = _getAmalByCategory(_selectedCategory);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: amalList.length,
      itemBuilder: (context, index) {
        final amal = amalList[index];
        return _buildAmalCard(amal);
      },
    );
  }

  Widget _buildAmalCard(Map<String, dynamic> amal) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (amal['color'] as Color).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              amal['icon'] as IconData,
              color: amal['color'] as Color,
              size: 24,
            ),
          ),
          title: Text(
            amal['title'] as String,
            style: GoogleFonts.notoSansBengali(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          subtitle: Text(
            amal['time'] as String,
            style: GoogleFonts.notoSansBengali(
              fontSize: 13,
              color: Colors.grey[600],
            ),
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
                      color: const Color(0xFF1D9375),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    amal['description'] as String,
                    style: GoogleFonts.notoSansBengali(
                      fontSize: 14,
                      color: Colors.grey[800],
                      height: 1.5,
                    ),
                  ),
                  if (amal['steps'] != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      'করণীয়:',
                      style: GoogleFonts.notoSansBengali(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1D9375),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...((amal['steps'] as List<String>).asMap().entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1D9375).withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${entry.key + 1}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1D9375),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                entry.value,
                                style: GoogleFonts.notoSansBengali(
                                  fontSize: 13,
                                  color: Colors.grey[800],
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList()),
                  ],
                  if (amal['reward'] != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber[200]!),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'সওয়াব: ${amal['reward']}',
                              style: GoogleFonts.notoSansBengali(
                                fontSize: 13,
                                color: Colors.amber[900],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (amal['reference'] != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'সূত্র: ${amal['reference']}',
                        style: GoogleFonts.notoSansBengali(
                          fontSize: 11,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getAmalByCategory(String category) {
    final allAmal = {
      'দৈনিক': [
        {
          'title': 'ফজরের নামাজ জামাতের সাথে',
          'time': 'ফজরের সময়',
          'icon': Icons.brightness_3,
          'color': const Color(0xFF673AB7),
          'description': 'ফজরের নামাজ জামাতের সাথে আদায় করা অত্যন্ত গুরুত্বপূর্ণ। এটি সারাদিনের বরকতের কারণ।',
          'steps': [
            'ফজরের ওয়াক্ত হওয়ার আগেই ঘুম থেকে উঠুন',
            'ওজু করুন এবং মসজিদে যান',
            'সুন্নত ২ রাকাত পড়ুন',
            'ফরজ ২ রাকাত জামাতের সাথে আদায় করুন',
          ],
          'reward': 'জান্নাতের গ্যারান্টি',
          'reference': 'বুখারী ৬৫৭',
        },
        {
          'title': 'সকাল ও সন্ধ্যার জিকির',
          'time': 'সকাল ও সন্ধ্যা',
          'icon': Icons.wb_sunny,
          'color': const Color(0xFFFF9800),
          'description': 'দিনের শুরু ও শেষে আল্লাহর জিকির করা সুন্নাহ। এটি সারাদিন সুরক্ষার কারণ।',
          'steps': [
            'সকালে ফজরের পর থেকে সূর্যোদয় পর্যন্ত',
            'সন্ধ্যায় আসরের পর থেকে মাগরিব পর্যন্ত',
            'আয়াতুল কুরসী পড়ুন',
            'সূরা ইখলাস, ফালাক, নাস - ৩ বার করে',
          ],
          'reward': 'দুনিয়া ও আখিরাতে সুরক্ষা',
          'reference': 'আবু দাউদ ৫০৮২',
        },
        {
          'title': 'পাঁচ ওয়াক্ত নামাজ',
          'time': 'দিনে ৫ বার',
          'icon': Icons.mosque,
          'color': const Color(0xFF1D9375),
          'description': 'পাঁচ ওয়াক্ত নামাজ ইসলামের ভিত্তি এবং আল্লাহর সাথে বান্দার সংযোগ।',
          'steps': [
            'ফজর - ভোর',
            'যোহর - দুপুর',
            'আসর - বিকেল',
            'মাগরিব - সূর্যাস্ত',
            'ইশা - রাত',
          ],
          'reward': 'জান্নাত লাভ',
          'reference': 'বুখারী ৮',
        },
        {
          'title': 'কুরআন তিলাওয়াত',
          'time': 'দিনের যেকোনো সময়',
          'icon': Icons.menu_book,
          'color': const Color(0xFF2196F3),
          'description': 'প্রতিদিন কুরআন তিলাওয়াত করা অত্যন্ত ফজিলতপূর্ণ। প্রতিটি অক্ষরে দশগুণ সওয়াব।',
          'steps': [
            'ওজু করে পবিত্র হয়ে বসুন',
            'কিবলামুখী হয়ে বসুন',
            'বিসমিল্লাহ বলে শুরু করুন',
            'তাজবীদ সহকারে পড়ুন',
            'অর্থ বুঝে পড়ার চেষ্টা করুন',
          ],
          'reward': 'প্রতি অক্ষরে ১০ নেকি',
          'reference': 'তিরমিযী ২৯১০',
        },
        {
          'title': 'ইস্তিগফার (ক্ষমা প্রার্থনা)',
          'time': 'দিনে ১০০ বার',
          'icon': Icons.favorite,
          'color': const Color(0xFFE91E63),
          'description': 'দিনে কমপক্ষে ১০০ বার ইস্তিগফার করা সুন্নাহ।',
          'steps': [
            'আস্তাগফিরুল্লাহ - ১০০ বার',
            'যেকোনো সময় পড়া যায়',
            'গুনাহ মাফের জন্য আন্তরিকতার সাথে',
          ],
          'reward': 'গুনাহ মাফ',
          'reference': 'বুখারী ৬৩০৭',
        },
      ],
      'সাপ্তাহিক': [
        {
          'title': 'জুমার নামাজ',
          'time': 'প্রতি শুক্রবার',
          'icon': Icons.event,
          'color': const Color(0xFF1D9375),
          'description': 'জুমার নামাজ প্রাপ্তবয়স্ক পুরুষদের জন্য ফরজ। এটি মুসলিমদের সাপ্তাহিক সমাবেশ।',
          'steps': [
            'গোসল করুন ও সুগন্ধি ব্যবহার করুন',
            'সুন্দর পোশাক পরিধান করুন',
            'আগে আগে মসজিদে যান',
            'খুতবা মনোযোগ দিয়ে শুনুন',
            'জুমার নামাজ আদায় করুন',
          ],
          'reward': 'সাপ্তাহিক গুনাহ মাফ',
          'reference': 'বুখারী ৮৭৭',
        },
        {
          'title': 'সূরা কাহফ তিলাওয়াত',
          'time': 'প্রতি শুক্রবার',
          'icon': Icons.auto_stories,
          'color': const Color(0xFF2196F3),
          'description': 'শুক্রবার সূরা কাহফ তিলাওয়াত করা সুন্নাহ। এটি দুই জুমার মধ্যে আলোকবর্তিকা।',
          'steps': [
            'শুক্রবার দিনে যেকোনো সময় পড়ুন',
            'অর্থ বুঝে পড়ুন',
            'ধীরে ধীরে তাজবীদ সহকারে পড়ুন',
          ],
          'reward': 'দুই জুমার মধ্যে আলো',
          'reference': 'আল-হাকিম',
        },
        {
          'title': 'সোমবার ও বৃহস্পতিবার রোজা',
          'time': 'প্রতি সপ্তাহ',
          'icon': Icons.restaurant,
          'color': const Color(0xFFFF9800),
          'description': 'সোমবার ও বৃহস্পতিবার রোজা রাখা সুন্নাহ এবং অত্যন্ত ফজিলতপূর্ণ।',
          'steps': [
            'সেহরি খান',
            'ফজরের আগে নিয়ত করুন',
            'সারাদিন খাদ্য-পানীয় ও যৌনতা থেকে বিরত থাকুন',
            'মাগরিবের সময় ইফতার করুন',
          ],
          'reward': 'বিশেষ নৈকট্য লাভ',
          'reference': 'তিরমিযী ৭৪৭',
        },
      ],
      'মাসিক': [
        {
          'title': 'আইয়ামে বীযের রোজা',
          'time': '১৩, ১৪, ১৫ তারিখ',
          'icon': Icons.nightlight_round,
          'color': const Color(0xFF673AB7),
          'description': 'প্রতি আরবি মাসের ১৩, ১৪ ও ১৫ তারিখে রোজা রাখা সুন্নাহ।',
          'steps': [
            'আরবি মাসের মধ্য তারিখ নোট করুন',
            'এই তিন দিন রোজা রাখুন',
            'সারা বছর রোজা রাখার সওয়াব পাবেন',
          ],
          'reward': 'সারা মাস রোজার সওয়াব',
          'reference': 'নাসায়ী ২৪২৪',
        },
        {
          'title': 'চাঁদ দেখা ও দোয়া',
          'time': 'নতুন চাঁদ দেখলে',
          'icon': Icons.brightness_3,
          'color': const Color(0xFF1D9375),
          'description': 'নতুন চাঁদ দেখে বিশেষ দোয়া পড়া সুন্নাহ।',
          'steps': [
            'চাঁদ দেখার চেষ্টা করুন',
            'দোয়া পড়ুন: আল্লাহুম্মা আহিল্লাহু আলাইনা...',
          ],
          'reward': 'বরকত লাভ',
          'reference': 'তিরমিযী ৩৪৫১',
        },
      ],
      'বাৎসরিক': [
        {
          'title': 'রমজানের রোজা',
          'time': 'রমজান মাস',
          'icon': Icons.mosque,
          'color': const Color(0xFF1D9375),
          'description': 'রমজান মাসের ৩০টি রোজা ফরজ। এটি ইসলামের পাঁচটি স্তম্ভের একটি।',
          'steps': [
            'প্রতিদিন সেহরি খান',
            'ফজরের আগে নিয়ত করুন',
            'সারাদিন ইবাদতে মশগুল থাকুন',
            'মাগরিবে ইফতার করুন',
            'তারাবীহ নামাজ পড়ুন',
          ],
          'reward': 'জান্নাত লাভ',
          'reference': 'বুখারী ১৯০১',
        },
        {
          'title': 'হজ্জ',
          'time': 'জিলহজ্জ মাস',
          'icon': Icons.mosque_outlined,
          'color': const Color(0xFFE91E63),
          'description': 'সামর্থ্যবান মুসলিমদের জন্য জীবনে একবার হজ্জ করা ফরজ।',
          'steps': [
            'আর্থিক ও শারীরিক সামর্থ্য নিশ্চিত করুন',
            'হজ্জের নিয়ম-কানুন শিখুন',
            'ইহরাম বেঁধে হজ্জ শুরু করুন',
            'সকল মানাসিক সম্পন্ন করুন',
          ],
          'reward': 'সকল গুনাহ মাফ',
          'reference': 'বুখারী ১৫২১',
        },
        {
          'title': 'কুরবানী',
          'time': 'ঈদুল আযহা',
          'icon': Icons.celebration,
          'color': const Color(0xFFFF9800),
          'description': 'সামর্থ্যবান মুসলিমদের জন্য কুরবানী করা ওয়াজিব।',
          'steps': [
            'ভালো পশু নির্বাচন করুন',
            'ঈদের নামাজের পর কুরবানী করুন',
            'গোশত তিন ভাগ করুন: নিজের জন্য, আত্মীয়দের জন্য, গরিবদের জন্য',
          ],
          'reward': 'আল্লাহর নৈকট্য',
          'reference': 'ইবনে মাজাহ ৩১৪৭',
        },
        {
          'title': 'আশুরার রোজা',
          'time': '১০ মুহাররম',
          'icon': Icons.event_note,
          'color': const Color(0xFF2196F3),
          'description': 'মুহাররম মাসের ১০ তারিখে রোজা রাখা অত্যন্ত ফজিলতপূর্ণ।',
          'steps': [
            '৯ ও ১০ মুহাররম রোজা রাখুন',
            'অথবা ১০ ও ১১ মুহাররম',
          ],
          'reward': 'এক বছরের গুনাহ মাফ',
          'reference': 'মুসলিম ১১৬২',
        },
        {
          'title': 'আরাফার দিনের রোজা',
          'time': '৯ জিলহজ্জ',
          'icon': Icons.sunny,
          'color': const Color(0xFFFFD700),
          'description': 'আরাফার দিনের রোজা দুই বছরের গুনাহ মাফ করে দেয়।',
          'steps': [
            'হাজী না হলে এই দিন রোজা রাখুন',
            'বেশি বেশি দোয়া করুন',
            'তাকবীর পড়ুন',
          ],
          'reward': 'দুই বছরের গুনাহ মাফ',
          'reference': 'মুসলিম ১১৬২',
        },
      ],
    };

    return allAmal[category] ?? [];
  }
}
