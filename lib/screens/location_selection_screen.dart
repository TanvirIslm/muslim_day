import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/prayer_settings.dart';
import '../models/district.dart';

class LocationSelectionScreen extends StatefulWidget {
  const LocationSelectionScreen({super.key});

  @override
  State<LocationSelectionScreen> createState() =>
      _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<District> _filteredDistricts = [];
  List<District> _allDistricts = [];

  // State Management Variables
  bool _isGpsMode = false;
  District? _selectedDistrict;

  final Color primaryThemeColor = const Color(0xFF1D9375);

  @override
  void initState() {
    super.initState();
    _loadDistricts();
  }

  void _loadDistricts() {
    _allDistricts = [
      // Dhaka Division
      District(name: "ঢাকা", latitude: 23.8103, longitude: 90.4125),
      District(name: "গাজীপুর", latitude: 23.9999, longitude: 90.4203),
      District(name: "নারায়ণগঞ্জ", latitude: 23.6238, longitude: 90.4995),
      District(name: "টাঙ্গাইল", latitude: 24.2513, longitude: 89.9167),
      District(name: "মুন্সিগঞ্জ", latitude: 23.5422, longitude: 90.5305),
      District(name: "মানিকগঞ্জ", latitude: 23.8617, longitude: 90.0003),
      District(name: "ফরিদপুর", latitude: 23.6070, longitude: 89.8429),
      District(name: "কিশোরগঞ্জ", latitude: 24.4449, longitude: 90.7766),
      District(name: "মাদারীপুর", latitude: 23.1641, longitude: 90.1897),
      District(name: "রাজবাড়ী", latitude: 23.7574, longitude: 89.6444),
      District(name: "শরীয়তপুর", latitude: 23.2423, longitude: 90.3451),
      District(name: "গোপালগঞ্জ", latitude: 23.0050, longitude: 89.8266),
      District(name: "নরসিংদী", latitude: 23.9322, longitude: 90.7151),

      // Chittagong Division
      District(name: "চট্টগ্রাম", latitude: 22.3569, longitude: 91.7832),
      District(name: "কক্সবাজার", latitude: 21.4272, longitude: 92.0058),
      District(name: "রাঙ্গামাটি", latitude: 22.7324, longitude: 92.2985),
      District(name: "বান্দরবান", latitude: 22.1953, longitude: 92.2183),
      District(name: "খাগড়াছড়ি", latitude: 23.1193, longitude: 91.9847),
      District(name: "ফেনী", latitude: 23.0159, longitude: 91.3976),
      District(name: "কুমিল্লা", latitude: 23.4607, longitude: 91.1809),
      District(name: "ব্রাহ্মণবাড়ীয়া", latitude: 23.9608, longitude: 91.1115),
      District(name: "চাঁদপুর", latitude: 23.2332, longitude: 90.6712),
      District(name: "নোয়াখালী", latitude: 22.8696, longitude: 91.0995),
      District(name: "লক্ষ্মীপুর", latitude: 22.9447, longitude: 90.8282),

      // Rajshahi Division
      District(name: "রাজশাহী", latitude: 24.3745, longitude: 88.6042),
      District(name: "নাটোর", latitude: 24.4206, longitude: 89.0000),
      District(name: "পাবনা", latitude: 24.0064, longitude: 89.2372),
      District(name: "সিরাজগঞ্জ", latitude: 24.4533, longitude: 89.7006),
      District(name: "বগুড়া", latitude: 24.8465, longitude: 89.3770),
      District(name: "জয়পুরহাট", latitude: 25.0968, longitude: 89.0227),
      District(name: "নওগাঁ", latitude: 24.7936, longitude: 88.9318),
      District(name: "চাঁপাইনবাবগঞ্জ", latitude: 24.5965, longitude: 88.2775),

      // Khulna Division
      District(name: "খুলনা", latitude: 22.8456, longitude: 89.5403),
      District(name: "যশোর", latitude: 23.1634, longitude: 89.2182),
      District(name: "সাতক্ষীরা", latitude: 22.7185, longitude: 89.0705),
      District(name: "বাগেরহাট", latitude: 22.6516, longitude: 89.7851),
      District(name: "ঝিনাইদহ", latitude: 23.5404, longitude: 89.0526),
      District(name: "কুষ্টিয়া", latitude: 23.9013, longitude: 89.1200),
      District(name: "চুয়াডাঙ্গা", latitude: 23.6401, longitude: 88.8412),
      District(name: "মেহেরপুর", latitude: 23.7622, longitude: 88.6318),
      District(name: "মাগুরা", latitude: 23.4876, longitude: 89.4198),
      District(name: "নড়াইল", latitude: 23.1725, longitude: 89.5125),

      // Barisal Division
      District(name: "বরিশাল", latitude: 22.7010, longitude: 90.3535),
      District(name: "পটুয়াখালী", latitude: 22.3596, longitude: 90.3298),
      District(name: "ভোলা", latitude: 22.6859, longitude: 90.6482),
      District(name: "পিরোজপুর", latitude: 22.5841, longitude: 89.9720),
      District(name: "ঝালকাঠি", latitude: 22.6406, longitude: 90.1987),
      District(name: "বরগুনা", latitude: 22.1590, longitude: 90.1119),

      // Sylhet Division
      District(name: "সিলেট", latitude: 24.8949, longitude: 91.8687),
      District(name: "মৌলভীবাজার", latitude: 24.4829, longitude: 91.7774),
      District(name: "হবিগঞ্জ", latitude: 24.3745, longitude: 91.4152),
      District(name: "সুনামগঞ্জ", latitude: 25.0657, longitude: 91.3950),

      // Rangpur Division
      District(name: "রংপুর", latitude: 25.7439, longitude: 89.2752),
      District(name: "দিনাজপুর", latitude: 25.6217, longitude: 88.6354),
      District(name: "গাইবান্ধা", latitude: 25.3287, longitude: 89.5285),
      District(name: "ঠাকুরগাঁও", latitude: 26.0336, longitude: 88.4616),
      District(name: "পঞ্চগড়", latitude: 26.3411, longitude: 88.5541),
      District(name: "কুড়িগ্রাম", latitude: 25.8074, longitude: 89.6361),
      District(name: "লালমনিরহাট", latitude: 25.9923, longitude: 89.2847),
      District(name: "নীলফামারী", latitude: 25.9317, longitude: 88.8560),

      // Mymensingh Division
      District(name: "ময়মনসিংহ", latitude: 24.7471, longitude: 90.4203),
      District(name: "জামালপুর", latitude: 24.9375, longitude: 89.9403),
      District(name: "শেরপুর", latitude: 25.0204, longitude: 90.0152),
      District(name: "নেত্রকোনা", latitude: 24.8804, longitude: 90.7278),
    ];

    _filteredDistricts = _allDistricts;
  }

  void _filterDistricts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredDistricts = _allDistricts;
      } else {
        _filteredDistricts = _allDistricts
            .where((district) =>
                district.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prayerSettings = Provider.of<PrayerSettings>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'লোকেশন সেটিংস',
          style: GoogleFonts.notoSansBengali(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryThemeColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // FIXED: The CustomScrollView allows everything to scroll cleanly out of the way when the keyboard opens
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Top static content wrapped in a SliverToBoxAdapter
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: primaryThemeColor,
                        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'সালাত ও সাহরি-ইফতারের সময় সঠিক ভাবে হিসাব করার জন্য আপনার লোকেশন সেট করুন।',
                              style: GoogleFonts.notoSansBengali(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'দেশ নির্বাচন করুন',
                              style: GoogleFonts.notoSansBengali(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'বাংলাদেশ',
                                      style: GoogleFonts.notoSansBengali(
                                          fontSize: 16),
                                    ),
                                  ),
                                  const Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'বর্তমান লোকেশন: ${prayerSettings.locationName}',
                              style: GoogleFonts.notoSansBengali(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'লোকেশন সেট করার পদ্ধতি সিলেক্ট করুন',
                              style: GoogleFonts.notoSansBengali(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Manual Selection Option
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isGpsMode = false;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: !_isGpsMode
                                      ? Colors.green.shade50
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: !_isGpsMode
                                        ? primaryThemeColor
                                        : Colors.grey.shade300,
                                    width: !_isGpsMode ? 2 : 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Radio<bool>(
                                          value: false,
                                          groupValue: _isGpsMode,
                                          onChanged: (value) {
                                            setState(() {
                                              _isGpsMode = value!;
                                            });
                                          },
                                          activeColor: primaryThemeColor,
                                        ),
                                        Expanded(
                                          child: Text(
                                            'জেলা ভিত্তিক (ইসলামিক ফাউন্ডেশন)',
                                            style: GoogleFonts.notoSansBengali(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 48.0),
                                      child: Text(
                                        'GPS পদ্ধতিতে কোনো স্থানের পুঙ্খানুপুঙ্খ সময় দেখানো হয়। সেক্ষেত্রে অন্যান্য ক্যালেন্ডারের সময়ের সাথে কিছু পার্থক্য হতে পারে। রমাদানে ইসলামিক ফাউন্ডেশনের সময় দেখতে চাইলে GPS\'র পরিবর্তে, জেলা সিলেক্ট করুন।',
                                        style: GoogleFonts.notoSansBengali(
                                          fontSize: 12,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // GPS Option
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isGpsMode = true;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: _isGpsMode
                                      ? Colors.green.shade50
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _isGpsMode
                                        ? primaryThemeColor
                                        : Colors.grey.shade300,
                                    width: _isGpsMode ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Radio<bool>(
                                      value: true,
                                      groupValue: _isGpsMode,
                                      onChanged: (value) {
                                        setState(() {
                                          _isGpsMode = value!;
                                        });
                                      },
                                      activeColor: primaryThemeColor,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'GPS লোকেশন ভিত্তিক (অপেক্ষাকৃত নির্ভুল)',
                                        style: GoogleFonts.notoSansBengali(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Search field
                            Opacity(
                              opacity: _isGpsMode ? 0.5 : 1.0,
                              child: TextField(
                                controller: _searchController,
                                onTap: () {
                                  setState(() {
                                    _isGpsMode = false;
                                  });
                                },
                                onChanged: _filterDistricts,
                                decoration: InputDecoration(
                                  hintText: 'জেলা খুঁজুন...',
                                  hintStyle: GoogleFonts.notoSansBengali(),
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // The list of districts wrapped in a SliverList
                SliverOpacity(
                  opacity: _isGpsMode ? 0.5 : 1.0,
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final district = _filteredDistricts[index];
                        final isSelected =
                            !_isGpsMode && _selectedDistrict == district;

                        return ListTile(
                          selected: isSelected,
                          selectedTileColor: Colors.green.shade50,
                          title: Text(
                            district.name,
                            style: GoogleFonts.notoSansBengali(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? primaryThemeColor
                                  : Colors.black87,
                            ),
                          ),
                          trailing: isSelected
                              ? Icon(Icons.check_circle,
                                  color: primaryThemeColor)
                              : null,
                          onTap: () {
                            setState(() {
                              _isGpsMode = false;
                              _selectedDistrict = district;
                            });
                          },
                        );
                      },
                      childCount: _filteredDistricts.length,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Operational SAVE Button remains fixed at the bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_isGpsMode || _selectedDistrict != null)
                    ? () async {
                        if (_isGpsMode) {
                          await prayerSettings.detectCurrentLocation();
                        } else if (_selectedDistrict != null) {
                          await prayerSettings.updateManualLocation(
                            _selectedDistrict!.latitude,
                            _selectedDistrict!.longitude,
                            '${_selectedDistrict!.name}, বাংলাদেশ',
                          );
                        }
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryThemeColor,
                  disabledBackgroundColor: Colors.grey.shade300,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'SAVE',
                  style: GoogleFonts.notoSansBengali(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
