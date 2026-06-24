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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'সেটিংস',
          style: GoogleFonts.notoSansBengali(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
      ),
      backgroundColor: Colors.grey[50],
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- General Settings ---
          _buildSectionHeader(context, 'সাধারণ'),
          _buildCard([
            _buildThemeSelector(themeProvider),
            _buildSwitchTile(
              'বাংলা সংখ্যা ব্যবহার করুন',
              'অ্যাপ জুড়ে বাংলা সংখ্যা প্রদর্শন করুন',
              Icons.looks_one,
              true, // This should be managed by a provider later
              (value) {},
            ),
          ]),

          const SizedBox(height: 20),

          // --- Prayer Settings ---
          _buildSectionHeader(context, 'নামাজ ও ইবাদত'),
          Consumer<PrayerSettings>(
            builder: (context, ps, _) {
              return _buildCard([
                ListTile(
                  leading: const Icon(Icons.location_on, color: Color(0xFF1D9375)),
                  title: Text(
                    'বর্তমান লোকেশন',
                    style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(ps.locationName, style: GoogleFonts.notoSansBengali()),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrayerSettingsPage(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.calculate, color: Color(0xFF1D9375)),
                  title: Text('গণনা পদ্ধতি', style: GoogleFonts.notoSansBengali()),
                  subtitle: Text(
                    ps.getCalculationMethodName(ps.calculationMethod),
                    style: GoogleFonts.notoSansBengali(fontSize: 12, color: Colors.grey[600]),
                  ),
                  trailing: const Icon(Icons.tune),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrayerSettingsPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.school, color: Color(0xFF1D9375)),
                  title: Text('মাযহাব (আসর হিসাব)', style: GoogleFonts.notoSansBengali()),
                  subtitle: Text(
                    ps.madhab == Madhab.hanafi ? 'হানাফী' : 'শাফেয়ী',
                    style: GoogleFonts.notoSansBengali(fontSize: 12, color: Colors.grey[600]),
                  ),
                  trailing: const Icon(Icons.swap_horiz),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrayerSettingsPage(),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade300, width: 1.5),
                    ),
                    child: ExpansionTile(
                      leading: const Icon(Icons.edit_location_alt, color: Color(0xFF1D9375)),
                      title: Text('ম্যানুয়াল লোকেশন সেট করুন', style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        'GPS ছাড়াই আপনার জেলা নির্বাচন করুন',
                        style: GoogleFonts.notoSansBengali(fontSize: 12, color: Colors.grey[700]),
                      ),
                      childrenPadding: const EdgeInsets.all(12),
                      children: [
                        Text(
                          'ইসলামিক ফাউন্ডেশন ক্যালেন্ডারের সাথে সামঞ্জস্য রাখতে জেলা ভিত্তিক লোকেশন ব্যবহার করুন।',
                          style: GoogleFonts.notoSansBengali(fontSize: 12, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PrayerSettingsPage(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.arrow_forward),
                            label: Text('সেটিংস খুলুন', style: GoogleFonts.notoSansBengali()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]);
            },
          ),

          const SizedBox(height: 20),

          // --- Notifications ---
          _buildSectionHeader(context, 'নোটিফিকেশন'),
          _buildCard([
            _buildSwitchTile(
              'নামাজের সময় নোটিফিকেশন',
              'ওয়াক্ত শুরু হলে আপনাকে জানানো হবে',
              Icons.notifications_active,
              true,
              (value) {},
            ),
            _buildSwitchTile(
              'আজান সাউন্ড',
              'নোটিফিকেশনের সাথে আজান বাজবে',
              Icons.volume_up,
              false,
              (value) {},
            ),
          ]),

          const SizedBox(height: 20),

          // --- App Info ---
          _buildSectionHeader(context, 'অ্যাপ সম্পর্কে'),
          _buildCard([
            _buildInfoTile(
              'সংস্করণ',
              '২.০.০',
              Icons.info_outline,
            ),
            _buildTapTile(
              'গোপনীয়তা নীতি',
              'আমাদের ডেটা ব্যবহারের নীতি পড়ুন',
              Icons.privacy_tip_outlined,
              () => _showPrivacyPolicy(context),
            ),
            _buildTapTile(
              'শর্তাবলী',
              'আমাদের ব্যবহারের শর্তাবলী পড়ুন',
              Icons.description_outlined,
              () => _showTermsOfService(context),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.notoSansBengali(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildThemeSelector(ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Icon(Icons.palette_outlined, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'অ্যাপ থিম',
                  style: GoogleFonts.notoSansBengali(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'আপনার পছন্দের থিম বেছে নিন',
                  style: GoogleFonts.notoSansBengali(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(
                value: ThemeMode.light,
                icon: Icon(Icons.light_mode),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                icon: Icon(Icons.dark_mode),
              ),
              ButtonSegment(
                value: ThemeMode.system,
                icon: Icon(Icons.brightness_auto),
              ),
            ],
            selected: {themeProvider.themeMode},
            onSelectionChanged: (newSelection) {
              themeProvider.setThemeMode(newSelection.first);
            },
            style: SegmentedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return SwitchListTile(
      title: Text(
        title,
        style: GoogleFonts.notoSansBengali(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.notoSansBengali(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      secondary: Icon(icon, color: Colors.grey[600]),
      value: value,
      onChanged: onChanged,
      activeThumbColor: Theme.of(context).primaryColor,
    );
  }

  Widget _buildTapTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(
        title,
        style: GoogleFonts.notoSansBengali(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.notoSansBengali(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildInfoTile(String title, String subtitle, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(
        title,
        style: GoogleFonts.notoSansBengali(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.notoSansBengali(
          fontSize: 14,
          color: Colors.grey[800],
        ),
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('গোপনীয়তা নীতি', style: GoogleFonts.notoSansBengali()),
        content: SingleChildScrollView(
          child: Text(
            'আমরা আপনার ব্যক্তিগত তথ্যকে সম্মান করি। এই অ্যাপটি আপনার অবস্থান এবং সেটিংস শুধুমাত্র নামাজের সময় গণনার জন্য ব্যবহার করে। কোনো তথ্য তৃতীয় পক্ষের সাথে শেয়ার করা হয় না।',
            style: GoogleFonts.notoSansBengali(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('বন্ধ করুন'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('শর্তাবলী', style: GoogleFonts.notoSansBengali()),
        content: SingleChildScrollView(
          child: Text(
            'এই অ্যাপটি ইসলামিক জীবনযাপনে সহায়তার জন্য তৈরি। প্রদত্ত সকল তথ্য ইসলামিক স্কলারদের মতামতের ভিত্তিতে তৈরি, তবে সময়ের সাথে তথ্যের পরিবর্তন হতে পারে। যেকোনো ভুলের জন্য আমরা ক্ষমাপ্রার্থী।',
            style: GoogleFonts.notoSansBengali(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('বন্ধ করুন'),
          ),
        ],
      ),
    );
  }
}
