import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:muslim_day/screens/prayer_settings_page.dart';
import '../providers/prayer_settings.dart';
import '../providers/theme_provider.dart';
import 'package:adhan/adhan.dart';

class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({super.key});

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'সেটিংস',
          style: GoogleFonts.notoSansBengali(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[100],
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- 1. General Settings ---
          _buildSectionHeader(context, 'সাধারণ'),
          _buildCard([
            _buildThemeSelector(context, themeProvider, primaryColor),
            _buildSwitchTile(
              context,
              'বাংলা সংখ্যা ব্যবহার করুন',
              'অ্যাপ জুড়ে বাংলা সংখ্যা প্রদর্শন করুন',
              Icons.looks_one,
              true, // This should be managed by a provider later
              (value) {},
            ),
          ]),

          const SizedBox(height: 24),

          // --- 2. Prayer Settings ---
          _buildSectionHeader(context, 'নামাজ ও ইবাদত'),
          Consumer<PrayerSettings>(
            builder: (context, ps, _) {
              return _buildCard([
                _buildListTile(
                  context, 
                  'বর্তমান লোকেশন', 
                  ps.locationName, 
                  Icons.location_on, 
                  primaryColor, 
                  () => _goToPrayerSettings(context),
                  showDivider: true,
                ),
                _buildListTile(
                  context, 
                  'গণনা পদ্ধতি', 
                  ps.getCalculationMethodName(ps.calculationMethod), 
                  Icons.calculate, 
                  primaryColor, 
                  () => _goToPrayerSettings(context),
                  showDivider: true,
                ),
                _buildListTile(
                  context, 
                  'মাযহাব (আসর হিসাব)', 
                  ps.madhab == Madhab.hanafi ? 'হানাফী' : 'শাফেয়ী', 
                  Icons.school, 
                  primaryColor, 
                  () => _goToPrayerSettings(context),
                  showDivider: false,
                ),
              ]);
            },
          ),

          const SizedBox(height: 24),

          // --- 3. Notifications ---
          _buildSectionHeader(context, 'নোটিফিকেশন'),
          _buildCard([
            _buildSwitchTile(
              context, 
              'নামাজের সময় নোটিফিকেশন', 
              'ওয়াক্ত শুরু হলে আপনাকে জানানো হবে', 
              Icons.notifications_active, 
              true, 
              (v) {},
              showDivider: true,
            ),
            _buildSwitchTile(
              context, 
              'আজান সাউন্ড', 
              'নোটিফিকেশনের সাথে আজান বাজবে', 
              Icons.volume_up, 
              false, 
              (v) {},
              showDivider: false,
            ),
          ]),

          const SizedBox(height: 24),

          // --- 4. App Info ---
          _buildSectionHeader(context, 'অ্যাপ সম্পর্কে'),
          _buildCard([
            _buildInfoTile('সংস্করণ', '২.০.০', Icons.info_outline, primaryColor),
            Divider(height: 1, indent: 64, endIndent: 16, color: Colors.grey.shade200),
            _buildListTile(
              context, 
              'গোপনীয়তা নীতি', 
              'ডেটা ব্যবহারের নীতি', 
              Icons.privacy_tip_outlined, 
              primaryColor, 
              () => _showPrivacyPolicy(context),
              showDivider: true,
            ),
            _buildListTile(
              context, 
              'শর্তাবলী', 
              'ব্যবহারের শর্তাবলী', 
              Icons.description_outlined, 
              primaryColor, 
              () => _showTermsOfService(context),
              showDivider: false,
            ),
          ]),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // --- Navigation Helpers ---
  void _goToPrayerSettings(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const PrayerSettingsPage()));
  }

  // --- UI Builder Methods ---

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 12.0),
      child: Text(
        title,
        style: GoogleFonts.notoSansBengali(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context, ThemeProvider themeProvider, Color primaryColor) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.palette_outlined, color: primaryColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'অ্যাপ থিম', 
                  style: GoogleFonts.notoSansBengali(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)
                ),
              ),
              SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(value: ThemeMode.light, icon: Icon(Icons.light_mode, size: 18)),
                  ButtonSegment(value: ThemeMode.dark, icon: Icon(Icons.dark_mode, size: 18)),
                ],
                selected: {themeProvider.themeMode == ThemeMode.dark ? ThemeMode.dark : ThemeMode.light},
                onSelectionChanged: (newSelection) => themeProvider.setThemeMode(newSelection.first),
                style: SegmentedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, indent: 64, endIndent: 16, color: Colors.grey.shade200),
      ],
    );
  }

  Widget _buildSwitchTile(BuildContext context, String title, String subtitle, IconData icon, bool value, Function(bool) onChanged, {bool showDivider = false}) {
    final primaryColor = Theme.of(context).primaryColor;
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: primaryColor, size: 22),
          ),
          title: Text(
            title, 
            style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black87)
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              subtitle, 
              style: GoogleFonts.notoSansBengali(fontSize: 13, color: Colors.grey.shade600, height: 1.3)
            ),
          ),
          trailing: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: primaryColor,
          ),
        ),
        if (showDivider)
          Divider(height: 1, indent: 64, endIndent: 16, color: Colors.grey.shade200),
      ],
    );
  }

  Widget _buildListTile(BuildContext context, String title, String subtitle, IconData icon, Color primaryColor, VoidCallback onTap, {bool showDivider = false}) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: primaryColor, size: 22),
          ),
          title: Text(
            title, 
            style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black87)
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              subtitle, 
              style: GoogleFonts.notoSansBengali(fontSize: 13, color: Colors.grey.shade600, height: 1.3)
            ),
          ),
          trailing: Icon(Icons.chevron_right, size: 20, color: Colors.grey.shade400),
          onTap: onTap,
        ),
        if (showDivider)
          Divider(height: 1, indent: 64, endIndent: 16, color: Colors.grey.shade200),
      ],
    );
  }

  Widget _buildInfoTile(String title, String subtitle, IconData icon, Color primaryColor) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: primaryColor, size: 22),
      ),
      title: Text(
        title, 
        style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black87)
      ),
      trailing: Text(
        subtitle, 
        style: GoogleFonts.notoSansBengali(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.bold)
      ),
    );
  }

  // --- Dialogs ---
  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('গোপনীয়তা নীতি', style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold)), 
        content: Text(
          'আমরা আপনার ব্যক্তিগত তথ্যকে সম্মান করি। এই অ্যাপটি আপনার অবস্থান এবং সেটিংস শুধুমাত্র নামাজের সময় গণনার জন্য ব্যবহার করে। কোনো তথ্য তৃতীয় পক্ষের সাথে শেয়ার করা হয় না।', 
          style: GoogleFonts.notoSansBengali(height: 1.4)
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), 
            child: Text('বন্ধ করুন', style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor))
          )
        ],
      )
    );
  }

  void _showTermsOfService(BuildContext context) {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('শর্তাবলী', style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold)), 
        content: Text(
          'এই অ্যাপটি ইসলামিক জীবনযাপনে সহায়তার জন্য তৈরি। প্রদত্ত সকল তথ্য ইসলামিক স্কলারদের মতামতের ভিত্তিতে তৈরি, তবে সময়ের সাথে তথ্যের পরিবর্তন হতে পারে। যেকোনো ভুলের জন্য আমরা ক্ষমাপ্রার্থী।', 
          style: GoogleFonts.notoSansBengali(height: 1.4)
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), 
            child: Text('বন্ধ করুন', style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor))
          )
        ],
      )
    );
  }
}