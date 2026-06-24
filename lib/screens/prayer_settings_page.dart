import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:adhan/adhan.dart';
import '../providers/prayer_settings.dart';
import 'location_selection_screen.dart';

class PrayerSettingsPage extends StatelessWidget {
  const PrayerSettingsPage({super.key});

  List<CalculationMethod> _getAvailableMethods() {
    return [
      CalculationMethod.muslim_world_league,
      CalculationMethod.egyptian,
      CalculationMethod.karachi,
      CalculationMethod.umm_al_qura,
      CalculationMethod.dubai,
      CalculationMethod.qatar,
      CalculationMethod.kuwait,
      CalculationMethod.singapore,
      CalculationMethod.north_america,
      CalculationMethod.moon_sighting_committee,
    ];
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryThemeColor = Color(0xFF1D9375);

    return Consumer<PrayerSettings>(
      builder: (context, settings, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "সেটিংস",
              style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold),
            ),
            backgroundColor: primaryThemeColor,
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  settings.detectCurrentLocation();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'লোকেশন আপডেট করা হচ্ছে...',
                        style: GoogleFonts.notoSansBengali(),
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
          backgroundColor: Colors.grey[50],
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildCard(
                child: ListTile(
                  leading:
                      const Icon(Icons.location_on, color: primaryThemeColor),
                  title: Text(
                    'লোকেশন সেট করুন',
                    style: GoogleFonts.notoSansBengali(
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    settings.locationName,
                    style: GoogleFonts.notoSansBengali(),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LocationSelectionScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // FIXED: Typo corrected from 'হিসার' to 'হিসাব'
                            'হিসাব সেট করুন',
                            style: GoogleFonts.notoSansBengali(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'সালাত, দিবস, সময় ও তারিখ',
                            style: GoogleFonts.notoSansBengali(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading:
                          const Icon(Icons.calculate, color: primaryThemeColor),
                      title: Text(
                        'গণনা হিসাব বিধি দিয়ে দেখুন',
                        style: GoogleFonts.notoSansBengali(),
                      ),
                      subtitle: Text(
                        _getCalculationMethodName(settings.calculationMethod),
                        style: GoogleFonts.notoSansBengali(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        _showCalculationMethodDialog(
                            context, settings, primaryThemeColor);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildCard(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.access_time,
                          color: primaryThemeColor),
                      title: Text(
                        'আসরের হানাফী ভিত্তি দিয়ে দেখুন',
                        style: GoogleFonts.notoSansBengali(
                            fontWeight: FontWeight.bold),
                      ),
                      // FIXED: Swapped out static 'Enable' text for a dynamic functional status block
                      subtitle: Text(
                        settings.madhab == Madhab.hanafi
                            ? 'হানাফী মাজহাব সময়সূচী সক্রিয়'
                            : 'শাফেয়ী, মালেকী ও হাম্বলী সময়সূচী সক্রিয়',
                        style: GoogleFonts.notoSansBengali(
                          fontSize: 12,
                          color: primaryThemeColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildRadioOption(
                              'হানাফী',
                              settings.madhab == Madhab.hanafi,
                              () => settings.updateMadhab(Madhab.hanafi),
                              primaryThemeColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildRadioOption(
                              'শাফেয়ী, মালেকী ও হাম্বলী',
                              settings.madhab == Madhab.shafi,
                              () => settings.updateMadhab(Madhab.shafi),
                              primaryThemeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        // FIXED: Typo corrected from 'হিসার' to 'হিসাব'
                        'সালাতের সময় হিসাব করার পদ্ধতি',
                        style: GoogleFonts.notoSansBengali(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.info_outline,
                          color: primaryThemeColor),
                      title: Text(
                        _getCalculationMethodName(settings.calculationMethod),
                        style: GoogleFonts.notoSansBengali(),
                      ),
                      subtitle: Text(
                        'আপনার নির্বাচিত পদ্ধতিটি সালাতের সময় হিসাব করার জন্য ব্যবহার করা হবে।',
                        style: GoogleFonts.notoSansBengali(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildRadioOption(
      String label, bool selected, VoidCallback onTap, Color activeColor) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.green.shade50 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? activeColor : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<bool>(
              value: selected,
              groupValue: true,
              onChanged: (value) => onTap(),
              activeColor: activeColor,
            ),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.notoSansBengali(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCalculationMethodDialog(
      BuildContext context, PrayerSettings settings, Color activeColor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'গণনা পদ্ধতি নির্বাচন করুন',
          style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _getAvailableMethods().map((method) {
              return RadioListTile<CalculationMethod>(
                title: Text(
                  _getCalculationMethodName(method),
                  style: GoogleFonts.notoSansBengali(),
                ),
                value: method,
                groupValue: settings.calculationMethod,
                onChanged: (value) {
                  if (value != null) {
                    settings.updateCalculationMethod(value);
                    Navigator.pop(context);
                  }
                },
                activeColor: activeColor,
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'বাতিল',
              style: GoogleFonts.notoSansBengali(color: activeColor),
            ),
          ),
        ],
      ),
    );
  }

  String _getCalculationMethodName(CalculationMethod method) {
    switch (method) {
      case CalculationMethod.muslim_world_league:
        return "Muslim World League";
      case CalculationMethod.egyptian:
        return "Egyptian General Authority";
      case CalculationMethod.karachi:
        return "University of Islamic Sciences, Karachi";
      case CalculationMethod.umm_al_qura:
        return "Umm al-Qura University, Makkah";
      case CalculationMethod.dubai:
        return "Dubai (UAE)";
      case CalculationMethod.qatar:
        return "Qatar";
      case CalculationMethod.kuwait:
        return "Kuwait";
      case CalculationMethod.singapore:
        return "Singapore";
      case CalculationMethod.north_america:
        return "ISNA (North America)";
      case CalculationMethod.moon_sighting_committee:
        return "Moonsighting Committee";
      case CalculationMethod.other:
        return "Other";
      default:
        return method.name;
    }
  }
}
