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
  bool _isLoading = false; // নতুন: সেভ করার সময় লোডিং দেখানোর জন্য

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

  Future<void> _handleSave() async {
    setState(() => _isLoading = true);
    final prayerSettings = Provider.of<PrayerSettings>(context, listen: false);

    try {
      if (_isGpsMode) {
        await prayerSettings.detectCurrentLocation();
      } else if (_selectedDistrict != null) {
        await prayerSettings.updateManualLocation(
          _selectedDistrict!.latitude,
          _selectedDistrict!.longitude,
          '${_selectedDistrict!.name}, বাংলাদেশ',
        );
      }
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving location: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prayerSettings = Provider.of<PrayerSettings>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'লোকেশন সেটিংস',
          style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryThemeColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ১. হাই-ফিডেলিটি ম্যাপ ও কারেন্ট লোকেশন কার্ড
                        _buildCurrentLocationCard(prayerSettings),
                        const SizedBox(height: 24),

                        Text(
                          'লোকেশন সেট করার পদ্ধতি',
                          style: GoogleFonts.notoSansBengali(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // ২. মডার্ন মোড সিলেক্টর (ট্যাপেবল কার্ড)
                        Row(
                          children: [
                            _buildModeCard(
                              title: "অটো (GPS)",
                              subtitle: "নির্ভুল ও স্বয়ংক্রিয়",
                              icon: Icons.my_location_rounded,
                              isSelected: _isGpsMode,
                              onTap: () => setState(() => _isGpsMode = true),
                            ),
                            const SizedBox(width: 12),
                            _buildModeCard(
                              title: "ম্যানুয়াল",
                              subtitle: "জেলা নির্বাচন করুন",
                              icon: Icons.map_rounded,
                              isSelected: !_isGpsMode,
                              onTap: () => setState(() => _isGpsMode = false),
                            ),
                          ],
                        ),

                        // ৩. ব্যাখ্যামূলক টেক্সট
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue.withValues(alpha: 0.1)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.info_outline, size: 18, color: Colors.blue),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _isGpsMode
                                        ? 'GPS পদ্ধতিতে আপনার ডিভাইসের বর্তমান স্থানের একদম পুঙ্খানুপুঙ্খ সময় হিসাব করা হয়। এটি সবচেয়ে বেশি নির্ভুল।'
                                        : 'রমাদানে ইসলামিক ফাউন্ডেশনের ক্যালেন্ডারের সময়ের সাথে হুবহু মিল রাখতে চাইলে GPS-এর পরিবর্তে আপনার জেলা সিলেক্ট করুন।',
                                    style: GoogleFonts.notoSansBengali(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // ৪. সার্চ বার (শুধুমাত্র ম্যানুয়াল মোডে)
                        if (!_isGpsMode) ...[
                          const SizedBox(height: 16),
                          _buildSearchField(),
                          const SizedBox(height: 8),
                        ],
                      ],
                    ),
                  ),
                ),

                // ৫. ডায়নামিক জেলা লিস্ট
                if (!_isGpsMode)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final district = _filteredDistricts[index];
                          final isSelected = _selectedDistrict == district;
                          return _buildDistrictTile(district, isSelected);
                        },
                        childCount: _filteredDistricts.length,
                      ),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],
            ),
          ),

          // ৬. ফ্লোটিং সেভ বাটন
          _buildSaveButton(),
        ],
      ),
    );
  }

  // --- হেল্পার উইজেটসমূহ ---

  Widget _buildCurrentLocationCard(PrayerSettings settings) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryThemeColor, const Color(0xFF126E56)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryThemeColor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.location_on, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "বর্তমান লোকেশন",
                      style: GoogleFonts.notoSansBengali(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      settings.locationName,
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
          if (_selectedDistrict != null && !_isGpsMode) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.satellite_alt_rounded, color: Colors.white70, size: 14),
                  const SizedBox(width: 8),
                  Text(
                    "Lat: ${_selectedDistrict!.latitude}  |  Lng: ${_selectedDistrict!.longitude}",
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildModeCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected ? primaryThemeColor.withValues(alpha: 0.05) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? primaryThemeColor : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? []
                : [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, color: isSelected ? primaryThemeColor : Colors.grey.shade500),
                  if (isSelected)
                    Icon(Icons.check_circle, color: primaryThemeColor, size: 18),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: GoogleFonts.notoSansBengali(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? primaryThemeColor : Colors.black87,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.notoSansBengali(
                  color: Colors.grey.shade600,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _filterDistricts,
        style: GoogleFonts.notoSansBengali(),
        decoration: InputDecoration(
          hintText: "জেলা খুঁজুন...",
          hintStyle: GoogleFonts.notoSansBengali(color: Colors.grey.shade400),
          prefixIcon: Icon(Icons.search, color: primaryThemeColor),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildDistrictTile(District district, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () => setState(() => _selectedDistrict = district),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? primaryThemeColor.withValues(alpha: 0.1) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? primaryThemeColor.withValues(alpha: 0.5) : Colors.grey.shade200),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            title: Text(
              district.name,
              style: GoogleFonts.notoSansBengali(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? primaryThemeColor : Colors.black87,
              ),
            ),
            subtitle: Text(
              "Lat: ${district.latitude}, Lng: ${district.longitude}",
              style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey.shade500),
            ),
            trailing: isSelected
                ? Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: primaryThemeColor, shape: BoxShape.circle),
                    child: const Icon(Icons.check, color: Colors.white, size: 16),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    final bool canSave = _isGpsMode || _selectedDistrict != null;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -4))],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryThemeColor,
          disabledBackgroundColor: Colors.grey.shade300,
          minimumSize: const Size(double.infinity, 56),
          elevation: canSave ? 4 : 0,
          shadowColor: primaryThemeColor.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: canSave ? _handleSave : null,
        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
              )
            : Text(
                'সেভ করুন',
                style: GoogleFonts.notoSansBengali(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}