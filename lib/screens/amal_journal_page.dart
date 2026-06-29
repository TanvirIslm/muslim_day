import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_filex/open_filex.dart';
import 'package:intl/intl.dart';

import '../providers/amal_provider.dart';
import 'hijri_calendar_screen.dart';

class AmalJournalPage extends StatefulWidget {
  const AmalJournalPage({super.key});

  @override
  State<AmalJournalPage> createState() => _AmalJournalPageState();
}

class _AmalJournalPageState extends State<AmalJournalPage> {
  late DateTime _selectedDate;
  late ScrollController _calendarScrollController;
  late List<DateTime> _recentDates;
  late List<DateTime> _last30Days;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);

    _recentDates = List.generate(15, (index) {
      final d = now.subtract(Duration(days: 14 - index));
      return DateTime(d.year, d.month, d.day);
    });

    _last30Days = List.generate(30, (index) {
      final d = now.subtract(Duration(days: 29 - index));
      return DateTime(d.year, d.month, d.day);
    });

    _calendarScrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_calendarScrollController.hasClients) {
        _calendarScrollController.jumpTo(_calendarScrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _calendarScrollController.dispose();
    super.dispose();
  }

  double _calculateDailyProgress(AmalProvider provider, DateTime date) {
    final completed = provider.getAmalsForDate(date).length;
    final total = provider.getAmalsByCategory('fardh').length +
        provider.getAmalsByCategory('sunnah').length +
        provider.getAmalsByCategory('habit').length;
    if (total == 0) return 0.0;
    return completed / total;
  }

  Color _getHeatmapColor(double progress, Color primaryColor) {
    if (progress == 0) return Colors.grey.shade200;
    if (progress <= 0.33) return primaryColor.withValues(alpha: 0.3);
    if (progress <= 0.66) return primaryColor.withValues(alpha: 0.6);
    return primaryColor;
  }

  Future<void> _generateAndSavePDF(AmalProvider provider) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Generating Analytics Report..."), duration: Duration(seconds: 1)),
      );

      final pdf = pw.Document();
      final primaryPdfColor = PdfColor.fromHex('#1D9375');
      final accentPdfColor = PdfColor.fromHex('#FF9800');
      final darkText = PdfColor.fromHex('#2D3748');

      final fardhIds = provider.getAmalsByCategory('fardh').map((e) => e.id).toList();
      final sunnahIds = provider.getAmalsByCategory('sunnah').map((e) => e.id).toList();
      final habitIds = provider.getAmalsByCategory('habit').map((e) => e.id).toList();

      final totalDailyFardh = fardhIds.length;
      final totalDailySunnah = sunnahIds.length;
      final totalDailyHabit = habitIds.length;

      final last7Days = _last30Days.sublist(_last30Days.length - 7);
      
      int fardhDone7 = 0, sunnahDone7 = 0, habitDone7 = 0;
      double totalProgress30 = 0;

      for (var date in last7Days) {
        final doneAmals = provider.getAmalsForDate(date);
        for (var id in doneAmals) {
          if (fardhIds.contains(id)) fardhDone7++;
          if (sunnahIds.contains(id)) sunnahDone7++;
          if (habitIds.contains(id)) habitDone7++;
        }
      }

      for (var date in _last30Days) {
        totalProgress30 += _calculateDailyProgress(provider, date);
      }

      final avgProgress30 = totalProgress30 / 30.0;
      final fardhRate = totalDailyFardh > 0 ? (fardhDone7 / (totalDailyFardh * 7)) * 100 : 0.0;
      final sunnahRate = totalDailySunnah > 0 ? (sunnahDone7 / (totalDailySunnah * 7)) * 100 : 0.0;
      final habitRate = totalDailyHabit > 0 ? (habitDone7 / (totalDailyHabit * 7)) * 100 : 0.0;

      List<String> insights = [];
      if (fardhRate < 100) {
        insights.add("CRITICAL: Your Fardh completion rate is ${fardhRate.toInt()}%. Fardh (obligatory) acts must be your #1 priority. Aim for 100% before focusing on habits.");
      } else {
        insights.add("EXCELLENT: You have maintained a 100% completion rate for Fardh acts over the last 7 days. May Allah accept it.");
      }

      if (fardhRate > 90 && sunnahRate < 50) {
        insights.add("SUGGESTION: Your foundation (Fardh) is very strong. Now is the perfect time to elevate your spiritual rank by incorporating more Sunnah prayers & Dhikr.");
      }

      if (avgProgress30 < 0.5) {
        insights.add("OBSERVATION: Your overall 30-day consistency is below 50%. Try setting smaller, manageable goals rather than attempting too many tasks at once.");
      } else if (avgProgress30 >= 0.8) {
        insights.add("ACHIEVEMENT: Outstanding dedication! An 80%+ consistency rate over 30 days indicates highly disciplined behavioral patterns.");
      }

      String userName = "Tanvir Islam"; 

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  padding: const pw.EdgeInsets.all(24),
                  decoration: pw.BoxDecoration(
                    color: primaryPdfColor,
                    borderRadius: pw.BorderRadius.circular(12),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text("Amal & Habit Analytics", style: pw.TextStyle(color: PdfColors.white, fontSize: 24, fontWeight: pw.FontWeight.bold)),
                          pw.SizedBox(height: 6),
                          pw.Text("Generated for: $userName", style: pw.TextStyle(color: PdfColors.white, fontSize: 14)),
                          pw.Text("Report Period: Last 30 Days", style: pw.TextStyle(color: PdfColors.white, fontSize: 12)),
                        ],
                      ),
                      pw.Container(
                        padding: const pw.EdgeInsets.all(14),
                        decoration: const pw.BoxDecoration(color: PdfColors.white, shape: pw.BoxShape.circle),
                        child: pw.Text("${(avgProgress30 * 100).toInt()}%", style: pw.TextStyle(color: primaryPdfColor, fontSize: 20, fontWeight: pw.FontWeight.bold)),
                      )
                    ],
                  ),
                ),
                pw.SizedBox(height: 24),

                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPdfStatCard("Total Points Earned", "${provider.totalPoints}", primaryPdfColor),
                    _buildPdfStatCard("Current Fardh Streak", "${provider.getCategoryStreak('fardh')} Days", accentPdfColor),
                    _buildPdfStatCard("Completed (7 Days)", "${fardhDone7 + sunnahDone7 + habitDone7} Tasks", PdfColor.fromHex('#4A5568')),
                  ],
                ),
                pw.SizedBox(height: 24),

                pw.Text("7-Day Performance Trend", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: darkText)),
                pw.SizedBox(height: 12),
                pw.Container(
                  height: 120,
                  padding: const pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey300), borderRadius: pw.BorderRadius.circular(8)),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: last7Days.map((date) {
                      final prog = _calculateDailyProgress(provider, date);
                      final barHeight = prog * 80; 
                      return pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text("${(prog * 100).toInt()}%", style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                          pw.SizedBox(height: 4),
                          pw.Container(
                            width: 24,
                            height: barHeight == 0 ? 2 : barHeight,
                            decoration: pw.BoxDecoration(
                              color: prog >= 0.7 ? primaryPdfColor : (prog > 0.3 ? PdfColor.fromHex('#4DB499') : PdfColors.grey400),
                              borderRadius: const pw.BorderRadius.vertical(top: pw.Radius.circular(4)),
                            ),
                          ),
                          pw.SizedBox(height: 6),
                          pw.Text(DateFormat('EEE').format(date), style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                pw.SizedBox(height: 24),

                pw.Text("Category Breakdown (Last 7 Days)", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: darkText)),
                pw.SizedBox(height: 12),
                pw.TableHelper.fromTextArray(
                  headerDecoration: pw.BoxDecoration(color: primaryPdfColor),
                  headerStyle: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 12),
                  cellStyle: const pw.TextStyle(fontSize: 11),
                  cellAlignment: pw.Alignment.centerLeft,
                  headerPadding: const pw.EdgeInsets.all(10),
                  cellPadding: const pw.EdgeInsets.all(10),
                  border: pw.TableBorder.all(color: PdfColors.grey300),
                  headers: ['Category', 'Target Tasks', 'Completed', 'Success Rate'],
                  data: [
                    ['Fardh (Obligatory)', '${totalDailyFardh * 7}', '$fardhDone7', '${fardhRate.toStringAsFixed(1)}%'],
                    ['Sunnah & Dhikr', '${totalDailySunnah * 7}', '$sunnahDone7', '${sunnahRate.toStringAsFixed(1)}%'],
                    ['Daily Habits', '${totalDailyHabit * 7}', '$habitDone7', '${habitRate.toStringAsFixed(1)}%'],
                  ],
                ),
                pw.SizedBox(height: 24),

                pw.Text("Actionable Insights & Next Steps", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: darkText)),
                pw.SizedBox(height: 12),
                pw.Container(
                  padding: const pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(color: PdfColor.fromHex('#F7FAFC'), borderRadius: pw.BorderRadius.circular(8), border: pw.Border.all(color: PdfColors.grey200)),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: insights.map((insight) {
                      return pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 8),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("• ", style: pw.TextStyle(fontSize: 14, color: primaryPdfColor, fontWeight: pw.FontWeight.bold)),
                            pw.Expanded(child: pw.Text(insight, style: pw.TextStyle(fontSize: 11, color: darkText, lineSpacing: 1.5))),
                          ]
                        ),
                      );
                    }).toList(),
                  ),
                ),
                pw.Spacer(),
                
                pw.Divider(color: PdfColors.grey300),
                pw.SizedBox(height: 8),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Generated securely via Muslim Day App", style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
                    pw.Text(DateFormat('MMMM d, yyyy - hh:mm a').format(DateTime.now()), style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
                  ]
                )
              ],
            );
          },
        ),
      );

      final output = await getApplicationDocumentsDirectory();
      final file = File("${output.path}/Amal_Analytics_Report.pdf");
      await file.writeAsBytes(await pdf.save());
      await OpenFilex.open(file.path);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to generate PDF.")));
      }
    }
  }

  pw.Widget _buildPdfStatCard(String title, String value, PdfColor color) {
    return pw.Container(
      width: 140,
      padding: const pw.EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: color.withAlpha(0.3), width: 1.5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(value, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: color)),
          pw.SizedBox(height: 6),
          pw.Text(title, style: pw.TextStyle(fontSize: 11, color: PdfColors.grey700)),
        ],
      ),
    );
  }

  void _showAddTaskBottomSheet(BuildContext context, AmalProvider provider, Color primaryColor) {
    String taskName = '';
    String selectedCategory = 'habit'; 

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                top: 24, left: 24, right: 24,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40, height: 5,
                      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  Text("নতুন টাস্ক তৈরি করুন", style: GoogleFonts.notoSansBengali(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.black87)),
                  Text("নিজের প্রতিদিনের রুটিনকে কাস্টমাইজ করুন", style: GoogleFonts.notoSansBengali(fontSize: 13, color: Colors.grey.shade600)),
                  const SizedBox(height: 24),

                  TextField(
                    autofocus: true,
                    style: GoogleFonts.notoSansBengali(fontSize: 16, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: "যেমন: কোরআন তিলাওয়াত, বই পড়া...",
                      hintStyle: GoogleFonts.notoSansBengali(color: Colors.grey.shade400, fontWeight: FontWeight.normal),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      prefixIcon: Icon(Icons.edit_note_rounded, color: primaryColor),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: primaryColor, width: 2)),
                    ),
                    onChanged: (value) => taskName = value,
                  ),
                  const SizedBox(height: 24),

                  Text("ক্যাটাগরি নির্বাচন করুন", style: GoogleFonts.notoSansBengali(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.black87)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildCategoryChip('fardh', 'ফরজ', Icons.star_rounded, selectedCategory, primaryColor, () => setModalState(() => selectedCategory = 'fardh')),
                      const SizedBox(width: 8),
                      _buildCategoryChip('sunnah', 'সুন্নাহ', Icons.nights_stay_rounded, selectedCategory, primaryColor, () => setModalState(() => selectedCategory = 'sunnah')),
                      const SizedBox(width: 8),
                      _buildCategoryChip('habit', 'অভ্যাস', Icons.self_improvement_rounded, selectedCategory, primaryColor, () => setModalState(() => selectedCategory = 'habit')),
                    ],
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        if (taskName.trim().isNotEmpty) {
                          // TODO: Uncomment below once you add `addCustomAmal` to your AmalProvider
                          // provider.addCustomAmal(taskName, selectedCategory);
                          
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("'$taskName' সফলভাবে যুক্ত হয়েছে!"),
                            backgroundColor: primaryColor,
                            behavior: SnackBarBehavior.floating,
                          ));
                        }
                      },
                      child: Text("সংরক্ষণ করুন", style: GoogleFonts.notoSansBengali(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCategoryChip(String id, String title, IconData icon, String selectedId, Color primaryColor, VoidCallback onTap) {
    final isSelected = id == selectedId;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor.withValues(alpha: 0.1) : Colors.white,
            border: Border.all(color: isSelected ? primaryColor : Colors.grey.shade300, width: isSelected ? 2 : 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? primaryColor : Colors.grey.shade500, size: 20),
              const SizedBox(height: 4),
              Text(title, style: GoogleFonts.notoSansBengali(fontSize: 12, fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600, color: isSelected ? primaryColor : Colors.grey.shade600)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AmalProvider>(context);
    final primaryColor = const Color(0xFF1D9375);

    final completedAmals = provider.getAmalsForDate(_selectedDate);
    final currentProgress = _calculateDailyProgress(provider, _selectedDate);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      appBar: AppBar(
        title: Text("আমল ট্র্যাকার", style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_task_rounded),
            tooltip: "নতুন টাস্ক",
            onPressed: () => _showAddTaskBottomSheet(context, provider, primaryColor),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month_rounded),
            tooltip: "হিজরি ক্যালেন্ডার",
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HijriCalendarScreen())),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 4.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  const Icon(Icons.stars_rounded, color: Colors.amber, size: 18),
                  const SizedBox(width: 6),
                  Text(provider.totalPoints.toString(), style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 14)),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _generateAndSavePDF(provider),
        backgroundColor: primaryColor,
        elevation: 4,
        icon: const Icon(Icons.analytics_rounded, color: Colors.white),
        label: Text("Analytics", style: GoogleFonts.notoSans(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            padding: const EdgeInsets.only(bottom: 16, top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedDate.day == DateTime.now().day ? "আজকের টাস্ক" : DateFormat('d MMMM').format(_selectedDate),
                            style: GoogleFonts.notoSansBengali(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black87),
                          ),
                          Text(
                            "আপনার প্রতিদিনের উন্নতি",
                            style: GoogleFonts.notoSansBengali(fontSize: 12, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 48, height: 48,
                            child: CircularProgressIndicator(value: currentProgress, strokeWidth: 5, backgroundColor: primaryColor.withValues(alpha: 0.1), color: primaryColor, strokeCap: StrokeCap.round),
                          ),
                          Text("${(currentProgress * 100).toInt()}%", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w900, fontSize: 13)),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 90,
                  child: ListView.builder(
                    controller: _calendarScrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _recentDates.length,
                    itemBuilder: (context, index) {
                      final date = _recentDates[index];
                      final isSelected = date == _selectedDate;
                      final dailyProg = _calculateDailyProgress(provider, date);

                      return GestureDetector(
                        onTap: () => setState(() => _selectedDate = date),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          width: 65,
                          decoration: BoxDecoration(
                            gradient: isSelected ? LinearGradient(colors: [primaryColor, const Color(0xFF126E56)], begin: Alignment.topLeft, end: Alignment.bottomRight) : null,
                            color: isSelected ? null : Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade200, width: 1.5),
                            boxShadow: isSelected ? [BoxShadow(color: primaryColor.withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 6))] : [],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(DateFormat('EEE').format(date).toUpperCase(), style: TextStyle(color: isSelected ? Colors.white70 : Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                              const SizedBox(height: 4),
                              Text("${date.day}", style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontSize: 24, fontWeight: FontWeight.w900)),
                              const SizedBox(height: 4),
                              if (dailyProg > 0)
                                Container(
                                  width: 6, height: 6,
                                  decoration: BoxDecoration(color: isSelected ? Colors.amber : primaryColor, shape: BoxShape.circle),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: 16, bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGitHubHeatmap(provider, primaryColor),
                  _buildAmalGroup(context, provider, 'fardh', 'ফরজ ইবাদত (সর্বোচ্চ অগ্রাধিকার)', completedAmals, _selectedDate, primaryColor),
                  _buildAmalGroup(context, provider, 'sunnah', 'সুন্নাহ ও জিকির', completedAmals, _selectedDate, primaryColor),
                  _buildAmalGroup(context, provider, 'habit', 'দৈনিক অভ্যাস', completedAmals, _selectedDate, primaryColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGitHubHeatmap(AmalProvider provider, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade100, width: 1.5),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "গত ৩০ দিনের পারফরম্যান্স", 
                        style: GoogleFonts.notoSansBengali(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.black87),
                        maxLines: 1, 
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "ধারাবাহিকতা বজায় রাখুন", 
                        style: GoogleFonts.notoSansBengali(fontSize: 12, color: Colors.grey.shade500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_fire_department_rounded, color: Colors.orange, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "${provider.getCategoryStreak('fardh')} দিনের স্ট্রিক", 
                        style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.w800, color: Colors.orange, fontSize: 12),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _last30Days.map((date) {
                final progress = _calculateDailyProgress(provider, date);
                return Tooltip(
                  message: "${DateFormat('MMM d').format(date)}: ${(progress*100).toInt()}%",
                  child: Container(
                    width: 16, height: 16,
                    decoration: BoxDecoration(
                      color: _getHeatmapColor(progress, primaryColor), 
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmalGroup(BuildContext context, AmalProvider provider, String category, String title, List<String> completedAmals, DateTime date, Color primaryColor) {
    final amals = provider.getAmalsByCategory(category);
    if (amals.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0, top: 12.0, left: 4),
            child: Text(title, style: GoogleFonts.notoSansBengali(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.black54, letterSpacing: 0.2)),
          ),
          ...amals.map((amal) {
            final isDone = completedAmals.contains(amal.id);
            return _AmalItem(
              amal: amal,
              isDone: isDone,
              primaryColor: primaryColor,
              onTap: () => provider.toggleAmal(date, amal.id),
            );
          }),
        ],
      ),
    );
  }
}

class _AmalItem extends StatelessWidget {
  final Amal amal;
  final bool isDone;
  final Color primaryColor;
  final VoidCallback onTap;

  const _AmalItem({required this.amal, required this.isDone, required this.primaryColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCirc,
        decoration: BoxDecoration(
          color: isDone ? primaryColor.withValues(alpha: 0.04) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDone ? primaryColor.withValues(alpha: 0.4) : Colors.grey.shade200, width: isDone ? 1.5 : 1),
          boxShadow: isDone ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.015), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            splashColor: primaryColor.withValues(alpha: 0.1),
            highlightColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDone ? primaryColor : Colors.grey.shade50,
                      shape: BoxShape.circle,
                      boxShadow: isDone ? [BoxShadow(color: primaryColor.withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 2))] : [],
                    ),
                    child: Icon(amal.icon, size: 20, color: isDone ? Colors.white : Colors.grey.shade500),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: GoogleFonts.notoSansBengali(
                        fontSize: 16,
                        fontWeight: isDone ? FontWeight.w700 : FontWeight.w600,
                        color: isDone ? Colors.black45 : Colors.black87,
                        decoration: isDone ? TextDecoration.lineThrough : null,
                        decorationColor: primaryColor,
                        decorationThickness: 2,
                      ),
                      child: Text(amal.title),
                    ),
                  ),
                  const SizedBox(width: 16),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(
                        scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
                        child: child,
                      );
                    },
                    child: isDone
                        ? Icon(Icons.check_circle_rounded, key: const ValueKey('done'), size: 32, color: primaryColor)
                        : Icon(Icons.circle_outlined, key: const ValueKey('not_done'), size: 32, color: Colors.grey.shade300),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}