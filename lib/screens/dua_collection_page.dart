import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DuaCollectionPage extends StatefulWidget {
  const DuaCollectionPage({super.key});

  @override
  State<DuaCollectionPage> createState() => _DuaCollectionPageState();
}

class _DuaCollectionPageState extends State<DuaCollectionPage> {
  String _selectedCategory = 'সকাল';
  final Set<String> _favorites = {};

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favorites.addAll(prefs.getStringList('favorite_duas') ?? []);
    });
  }

  Future<void> _toggleFavorite(String duaId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_favorites.contains(duaId)) {
        _favorites.remove(duaId);
      } else {
        _favorites.add(duaId);
      }
    });
    await prefs.setStringList('favorite_duas', _favorites.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          'দোয়া সমূহ',
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
            child: _buildDuaList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    final categories = [
      'সকাল',
      'সন্ধ্যা',
      'ঘুম',
      'খাবার',
      'নামাজ',
      'সাধারণ',
      'প্রিয়',
    ];

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

  Widget _buildDuaList() {
    final duas = _getDuasByCategory(_selectedCategory);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: duas.length,
      itemBuilder: (context, index) {
        final dua = duas[index];
        return _buildDuaCard(dua);
      },
    );
  }

  Widget _buildDuaCard(Map<String, dynamic> dua) {
    final isFavorite = _favorites.contains(dua['id']);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    dua['title'],
                    style: GoogleFonts.notoSansBengali(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1D9375),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: () => _toggleFavorite(dua['id']),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, color: Colors.grey),
                  onPressed: () => _copyDua(dua),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                dua['arabic'],
                style: GoogleFonts.amiriQuran(
                  fontSize: 20,
                  height: 2,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'উচ্চারণ:',
              style: GoogleFonts.notoSansBengali(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              dua['pronunciation'],
              style: GoogleFonts.notoSansBengali(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey[800],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'অর্থ:',
              style: GoogleFonts.notoSansBengali(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              dua['meaning'],
              style: GoogleFonts.notoSansBengali(
                fontSize: 14,
                color: Colors.grey[800],
                height: 1.5,
              ),
            ),
            if (dua['reference'] != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'সূত্র: ${dua['reference']}',
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
    );
  }

  void _copyDua(Map<String, dynamic> dua) {
    final text = '''
${dua['title']}

${dua['arabic']}

উচ্চারণ: ${dua['pronunciation']}

অর্থ: ${dua['meaning']}

${dua['reference'] != null ? 'সূত্র: ${dua['reference']}' : ''}
''';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'দোয়া কপি করা হয়েছে',
          style: GoogleFonts.notoSansBengali(),
        ),
        backgroundColor: const Color(0xFF1D9375),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  List<Map<String, dynamic>> _getDuasByCategory(String category) {
    if (category == 'প্রিয়') {
      return _allDuas.where((dua) => _favorites.contains(dua['id'])).toList();
    }

    return _allDuas.where((dua) => dua['category'] == category).toList();
  }

  final List<Map<String, dynamic>> _allDuas = const [
    // সকালের দোয়া
    {
      'id': 'morning_1',
      'category': 'সকাল',
      'title': 'সকালে ঘুম থেকে উঠার দোয়া',
      'arabic':
          'ٱلْحَمْدُ لِلَّهِ ٱلَّذِي أَحْيَانَا بَعْدَ مَآ أَمَاتَنَا وَإِلَيْهِ ٱلنُّشُورُ',
      'pronunciation':
          'আলহামদুলিল্লাহিল্লাযী আহইয়ানা বা\'দা মা আমাতানা ওয়া ইলাইহিন নুশূর',
      'meaning':
          'সকল প্রশংসা আল্লাহর জন্য যিনি আমাদের মৃত্যুর পর পুনর্জীবিত করেছেন এবং তাঁর কাছেই প্রত্যাবর্তন।',
      'reference': 'বুখারী ৬৩১২',
    },
    {
      'id': 'morning_2',
      'category': 'সকাল',
      'title': 'সকালের তাসবীহ - আয়াতুল কুরসী',
      'arabic':
          'اللَّهُ لاَ إِلَهَ إِلاَّ هُوَ الْحَيُّ الْقَيُّومُ لاَ تَأْخُذُهُ سِنَةٌ وَلاَ نَوْمٌ',
      'pronunciation':
          'আল্লাহু লা ইলাহা ইল্লা হুওয়াল হাইয়্যুল কাইয়্যুম, লা তা\'খুযুহু সিনাতুঁও ওয়ালা নাউম',
      'meaning':
          'আল্লাহ, তিনি ছাড়া কোন ইলাহ নেই। তিনি চিরঞ্জীব, সর্বদা রক্ষণাবেক্ষণকারী। তন্দ্রা ও নিদ্রা তাঁকে স্পর্শ করে না।',
      'reference': 'সূরা বাকারাহ ২:২৫৫',
    },
    {
      'id': 'morning_3',
      'category': 'সকাল',
      'title': 'সকালের জিকির',
      'arabic': 'أَصْبَحْنَا وَأَصْبَحَ ٱلْمُلْكُ لِلَّهِ وَٱلْحَمْدُ لِلَّهِ',
      'pronunciation': 'আসবাহনা ওয়া আসবাহাল মুলকু লিল্লাহি ওয়াল হামদুলিল্লাহ',
      'meaning':
          'আমরা সকালে উপনীত হয়েছি এবং সমস্ত রাজত্ব আল্লাহর জন্য, এবং সকল প্রশংসা আল্লাহর জন্য।',
      'reference': 'মুসলিম',
    },

    // সন্ধ্যার দোয়া
    {
      'id': 'evening_1',
      'category': 'সন্ধ্যা',
      'title': 'সন্ধ্যার জিকির',
      'arabic': 'أَمْسَيْنَا وَأَمْسَىٰ ٱلْمُلْكُ لِلَّهِ وَٱلْحَمْدُ لِلَّهِ',
      'pronunciation': 'আমসাইনা ওয়া আমসাল মুলকু লিল্লাহি ওয়াল হামদুলিল্লাহ',
      'meaning':
          'আমরা সন্ধ্যায় উপনীত হয়েছি এবং সমস্ত রাজত্ব আল্লাহর জন্য, এবং সকল প্রশংসা আল্লাহর জন্য।',
      'reference': 'মুসলিম',
    },
    {
      'id': 'evening_2',
      'category': 'সন্ধ্যা',
      'title': 'সন্ধ্যার সুরক্ষার দোয়া',
      'arabic':
          'بِسْمِ اللَّهِ الَّذِي لاَ يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الأَرْضِ وَلاَ فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
      'pronunciation':
          'বিসমিল্লাহিল্লাযী লা ইয়াদ্বুর্রু মা\'আ ইসমিহী শাইউন ফিল আরদি ওয়ালা ফিসসামাই ওয়া হুওয়াস সামীউল আলীম',
      'meaning':
          'আল্লাহর নামে, যাঁর নামের সাথে আসমান ও জমিনের কোন কিছু ক্ষতি করতে পারে না। তিনি সর্বশ্রোতা, সর্বজ্ঞ।',
      'reference': 'আবু দাউদ ৫০৮৮',
    },

    // ঘুমের দোয়া
    {
      'id': 'sleep_1',
      'category': 'ঘুম',
      'title': 'ঘুমানোর আগের দোয়া',
      'arabic': 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
      'pronunciation': 'বিসমিকা আল্লাহুম্মা আমূতু ওয়া আহইয়া',
      'meaning': 'হে আল্লাহ! তোমার নামেই আমি মরি এবং বাঁচি।',
      'reference': 'বুখারী ৬৩১২',
    },
    {
      'id': 'sleep_2',
      'category': 'ঘুম',
      'title': 'ঘুমানোর দোয়া',
      'arabic': 'اللَّهُمَّ بِاسْمِكَ أَمُوتُ وَأَحْيَا',
      'pronunciation': 'আল্লাহুম্মা বিসমিকা আমূতু ওয়া আহইয়া',
      'meaning': 'হে আল্লাহ! তোমার নামে আমি মরি ও জীবিত হই।',
      'reference': 'বুখারী',
    },

    // খাবারের দোয়া
    {
      'id': 'food_1',
      'category': 'খাবার',
      'title': 'খাবার শুরুর দোয়া',
      'arabic': 'بِسْمِ اللَّهِ',
      'pronunciation': 'বিসমিল্লাহ',
      'meaning': 'আল্লাহর নামে (শুরু করছি)।',
      'reference': 'তিরমিযী ১৮৫৮',
    },
    {
      'id': 'food_2',
      'category': 'খাবার',
      'title': 'খাবার শেষের দোয়া',
      'arabic':
          'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مُسْلِمِينَ',
      'pronunciation':
          'আলহামদুলিল্লাহিল্লাযী আত\'আমানা ওয়া সাক্বানা ওয়া জা\'আলানা মুসলিমীন',
      'meaning':
          'সকল প্রশংসা আল্লাহর জন্য যিনি আমাদের খাবার ও পানীয় দিয়েছেন এবং আমাদের মুসলিম বানিয়েছেন।',
      'reference': 'আবু দাউদ ৩৮৫০',
    },
    {
      'id': 'food_3',
      'category': 'খাবার',
      'title': 'পানি পানের দোয়া',
      'arabic': 'الْحَمْدُ لِلَّهِ',
      'pronunciation': 'আলহামদুলিল্লাহ',
      'meaning': 'সকল প্রশংসা আল্লাহর জন্য।',
      'reference': 'সুনান',
    },

    // নামাজের দোয়া
    {
      'id': 'prayer_1',
      'category': 'নামাজ',
      'title': 'নামাজ শুরুর দোয়া (সানা)',
      'arabic':
          'سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ وَتَبَارَكَ اسْمُكَ وَتَعَالَىٰ جَدُّكَ وَلَا إِلَٰهَ غَيْرُكَ',
      'pronunciation':
          'সুবহানাকা আল্লাহুম্মা ওয়া বিহামদিকা ওয়া তাবারাকাসমুকা ওয়া তা\'আলা জাদ্দুকা ওয়ালা ইলাহা গাইরুক',
      'meaning':
          'হে আল্লাহ! তুমি পবিত্র, তোমার প্রশংসা। তোমার নাম বরকতময়, তোমার মর্যাদা সুউচ্চ এবং তুমি ব্যতীত কোন ইলাহ নেই।',
      'reference': 'তিরমিযী ২৪৩',
    },
    {
      'id': 'prayer_2',
      'category': 'নামাজ',
      'title': 'রুকুর তাসবীহ',
      'arabic': 'سُبْحَانَ رَبِّيَ الْعَظِيمِ',
      'pronunciation': 'সুবহানা রাব্বিয়াল আযীম',
      'meaning': 'পবিত্র মহান আমার প্রতিপালক।',
      'reference': 'আবু দাউদ ৮৭০',
    },
    {
      'id': 'prayer_3',
      'category': 'নামাজ',
      'title': 'সিজদার তাসবীহ',
      'arabic': 'سُبْحَانَ رَبِّيَ الْأَعْلَىٰ',
      'pronunciation': 'সুবহানা রাব্বিয়াল আ\'লা',
      'meaning': 'পবিত্র আমার সর্বোচ্চ প্রতিপালক।',
      'reference': 'আবু দাউদ ৮৭০',
    },
    {
      'id': 'prayer_4',
      'category': 'নামাজ',
      'title': 'তাশাহহুদ',
      'arabic':
          'ٱلتَّحِيَّاتُ لِلَّهِ وَٱلصَّلَوَاتُ وَٱلطَّيِّبَاتُ ٱلسَّلَامُ عَلَيْكَ أَيُّهَا ٱلنَّبِيُّ وَرَحْمَةُ ٱللَّهِ وَبَرَكَاتُهُ',
      'pronunciation':
          'আত্তাহিয়্যাতু লিল্লাহি ওয়াস সালাওয়াতু ওয়াত তাইয়্যিবাতু, আসসালামু আলাইকা আইয়্যুহান নাবিয়্যু ওয়া রাহমাতুল্লাহি ওয়া বারাকাতুহ',
      'meaning':
          'সকল সম্মান, সকল নামাজ ও সকল ভালো কাজ আল্লাহর জন্য। হে নবী, আপনার উপর শান্তি, আল্লাহর রহমত ও বরকত।',
      'reference': 'বুখারী ৮৩১',
    },

    // সাধারণ দোয়া
    {
      'id': 'general_1',
      'category': 'সাধারণ',
      'title': 'ঘর থেকে বের হওয়ার দোয়া',
      'arabic':
          'بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
      'pronunciation':
          'বিসমিল্লাহি তাওয়াক্কালতু আলাল্লাহি লা হাওলা ওয়ালা কুওয়াতা ইল্লা বিল্লাহ',
      'meaning':
          'আল্লাহর নামে, আল্লাহর উপর ভরসা করলাম। আল্লাহ ছাড়া কোন শক্তি ও ক্ষমতা নেই।',
      'reference': 'তিরমিযী ৩৪২৬',
    },
    {
      'id': 'general_2',
      'category': 'সাধারণ',
      'title': 'ঘরে প্রবেশের দোয়া',
      'arabic':
          'بِسْمِ اللَّهِ وَلَجْنَا وَبِسْمِ اللَّهِ خَرَجْنَا وَعَلَى اللَّهِ رَبِّنَا تَوَكَّلْنَا',
      'pronunciation':
          'বিসমিল্লাহি ওয়ালাজনা ওয়া বিসমিল্লাহি খারাজনা ওয়া আলাল্লাহি রব্বিনা তাওয়াক্কালনা',
      'meaning':
          'আল্লাহর নামে আমরা প্রবেশ করলাম এবং আল্লাহর নামে আমরা বের হলাম এবং আমাদের প্রতিপালক আল্লাহর উপর আমরা ভরসা করলাম।',
      'reference': 'আবু দাউদ ৫০৯৬',
    },
    {
      'id': 'general_3',
      'category': 'সাধারণ',
      'title': 'মসজিদে প্রবেশের দোয়া',
      'arabic': 'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
      'pronunciation': 'আল্লাহুম্মাফতাহ লী আবওয়াবা রাহমাতিক',
      'meaning': 'হে আল্লাহ! আমার জন্য তোমার রহমতের দরজা খুলে দাও।',
      'reference': 'মুসলিম ৭১৩',
    },
    {
      'id': 'general_4',
      'category': 'সাধারণ',
      'title': 'মসজিদ থেকে বের হওয়ার দোয়া',
      'arabic': 'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ',
      'pronunciation': 'আল্লাহুম্মা ইন্নী আসআলুকা মিন ফাদলিক',
      'meaning': 'হে আল্লাহ! আমি তোমার কাছে তোমার অনুগ্রহ প্রার্থনা করছি।',
      'reference': 'মুসলিম ৭১৩',
    },
    {
      'id': 'general_5',
      'category': 'সাধারণ',
      'title': 'ক্ষমা প্রার্থনার দোয়া',
      'arabic':
          'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ الَّذِي لَا إِلَٰهَ إِلَّا هُوَ الْحَيَّ الْقَيُّومَ وَأَتُوبُ إِلَيْهِ',
      'pronunciation':
          'আস্তাগফিরুল্লাহাল আযীমাল্লাযী লা ইলাহা ইল্লা হুওয়াল হাইয়্যুল কাইয়্যুমু ওয়া আতূবু ইলাইহি',
      'meaning':
          'আমি মহান আল্লাহর কাছে ক্ষমা প্রার্থনা করছি যিনি ছাড়া কোন ইলাহ নেই, তিনি চিরঞ্জীব, চিরস্থায়ী এবং আমি তাঁর কাছে তওবা করছি।',
      'reference': 'আবু দাউদ ১৫১৭',
    },
    {
      'id': 'general_6',
      'category': 'সাধারণ',
      'title': 'রহমতের দোয়া',
      'arabic': 'رَبِّ ارْحَمْهُمَا كَمَا رَبَّيَانِي صَغِيرًا',
      'pronunciation': 'রাব্বির হামহুমা কামা রব্বাইয়ানী সগীরা',
      'meaning':
          'হে আমার প্রতিপালক! তাদের (পিতা-মাতা) উপর দয়া করুন যেভাবে তারা আমাকে ছোটবেলায় লালন-পালন করেছেন।',
      'reference': 'সূরা বনী ইসরাঈল ১৭:২৪',
    },
  ];
}
