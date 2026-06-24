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
  late List<DateTime> _last30Days; // For the GitHub Heatmap

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);

    // Last 15 days for the calendar strip
    _recentDates = List.generate(15, (index) {
      final d = now.subtract(Duration(days: 14 - index));
      return DateTime(d.year, d.month, d.day);
    });

    // Last 30 days for the GitHub Heatmap
    _last30Days = List.generate(30, (index) {
      final d = now.subtract(Duration(days: 29 - index));
      return DateTime(d.year, d.month, d.day);
    });

    _calendarScrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_calendarScrollController.hasClients) {
        _calendarScrollController
            .jumpTo(_calendarScrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _calendarScrollController.dispose();
    super.dispose();
  }

  // Helper to calculate daily progress percentage
  double _calculateDailyProgress(AmalProvider provider, DateTime date) {
    final completed = provider.getAmalsForDate(date).length;
    final total = provider.getAmalsByCategory('fardh').length +
        provider.getAmalsByCategory('sunnah').length +
        provider.getAmalsByCategory('habit').length;
    if (total == 0) return 0.0;
    return completed / total;
  }

  // Get color intensity based on completion (GitHub Style)
  Color _getHeatmapColor(double progress, Color primaryColor) {
    if (progress == 0) return Colors.grey.shade200;
    if (progress <= 0.33) return primaryColor.withValues(alpha: 0.3);
    if (progress <= 0.66) return primaryColor.withValues(alpha: 0.6);
    return primaryColor; // 100% or high completion
  }

  // --- Premium PDF Generation with Heatmap ---
  Future<void> _generateAndSavePDF(AmalProvider provider, int completed,
      double progress, Color appPrimaryColor) async {
    try {
      final pdf = pw.Document();
      final primaryPdfColor = PdfColor.fromHex('#1D9375');
      final accentOrange = PdfColor.fromHex('#FF9800');

      // Generate Heatmap widgets for PDF
      List<pw.Widget> pdfHeatmapSquares = _last30Days.map((date) {
        final dailyProg = _calculateDailyProgress(provider, date);
        PdfColor squareColor = PdfColors.grey300;
        if (dailyProg > 0 && dailyProg <= 0.33)
          squareColor = PdfColor.fromHex('#A3D5C7');
        if (dailyProg > 0.33 && dailyProg <= 0.66)
          squareColor = PdfColor.fromHex('#4DB499');
        if (dailyProg > 0.66) squareColor = primaryPdfColor;

        return pw.Container(
            width: 12,
            height: 12,
            decoration: pw.BoxDecoration(
                color: squareColor, borderRadius: pw.BorderRadius.circular(2)));
      }).toList();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(20),
                  decoration: pw.BoxDecoration(
                      color: primaryPdfColor,
                      borderRadius: pw.BorderRadius.circular(12)),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text("Monthly Amal Overview",
                          style: pw.TextStyle(
                              color: PdfColors.white,
                              fontSize: 26,
                              fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 8),
                      pw.Text(
                          "Your personal progress and consistency tracking.",
                          style: pw.TextStyle(
                              color: PdfColors.white, fontSize: 14)),
                    ],
                  ),
                ),
                pw.SizedBox(height: 25),

                // 30-Day Heatmap inside PDF
                pw.Text("30-Day Contribution Graph",
                    style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.black)),
                pw.SizedBox(height: 10),
                pw.Container(
                  padding: const pw.EdgeInsets.all(15),
                  decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey300),
                      borderRadius: pw.BorderRadius.circular(8)),
                  child: pw.Wrap(
                      spacing: 4, runSpacing: 4, children: pdfHeatmapSquares),
                ),
                pw.SizedBox(height: 25),

                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPdfStatCard("Total Points", "${provider.totalPoints}",
                        primaryPdfColor),
                    _buildPdfStatCard(
                        "Highest Streak",
                        "${provider.getCategoryStreak('fardh')} Days",
                        accentOrange),
                  ],
                ),
                pw.SizedBox(height: 30),

                pw.Text("Category Summary",
                    style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.black)),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  headerDecoration: pw.BoxDecoration(color: primaryPdfColor),
                  headerStyle: pw.TextStyle(
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 12),
                  cellStyle: const pw.TextStyle(fontSize: 11),
                  cellAlignment: pw.Alignment.centerLeft,
                  headerPadding: const pw.EdgeInsets.all(10),
                  cellPadding: const pw.EdgeInsets.all(10),
                  border: pw.TableBorder.all(color: PdfColors.grey300),
                  headers: ['Category', 'Current Streak', 'Status'],
                  data: [
                    [
                      'Fardh Worship',
                      '${provider.getCategoryStreak('fardh')} Days',
                      'Active'
                    ],
                    [
                      'Sunnah & Dhikr',
                      '${provider.getCategoryStreak('sunnah')} Days',
                      'Active'
                    ],
                  ],
                ),
                pw.Spacer(),
                pw.Divider(color: PdfColors.grey400),
                pw.SizedBox(height: 10),
                pw.Text(
                    "Generated on: ${DateFormat('MMMM d, yyyy').format(DateTime.now())}",
                    style: const pw.TextStyle(
                        fontSize: 10, color: PdfColors.grey700)),
              ],
            );
          },
        ),
      );

      final output = await getApplicationDocumentsDirectory();
      final file = File("${output.path}/Amal_Report.pdf");
      await file.writeAsBytes(await pdf.save());
      await OpenFilex.open(file.path);
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to generate PDF.")));
    }
  }

  pw.Widget _buildPdfStatCard(String title, String value, PdfColor color) {
    return pw.Container(
      width: 230,
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
          color: PdfColors.white,
          borderRadius: pw.BorderRadius.circular(8),
          border: pw.Border.all(color: color, width: 1.5)),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(value,
              style: pw.TextStyle(
                  fontSize: 22, fontWeight: pw.FontWeight.bold, color: color)),
          pw.SizedBox(height: 4),
          pw.Text(title,
              style: pw.TextStyle(fontSize: 12, color: PdfColors.grey800)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AmalProvider>(context);
    final primaryColor = Theme.of(context).primaryColor;

    final completedAmals = provider.getAmalsForDate(_selectedDate);
    final currentProgress = _calculateDailyProgress(provider, _selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text("আমল ট্র্যাকার",
            style: GoogleFonts.notoSansBengali(
                fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            tooltip: "হিজরি ক্যালেন্ডার",
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HijriCalendarScreen())),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 8.0),
            child: Chip(
              avatar: const Icon(Icons.star, color: Colors.amber, size: 18),
              label: Text(provider.totalPoints.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              side: BorderSide.none,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[50],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _generateAndSavePDF(
            provider, completedAmals.length, currentProgress, primaryColor),
        backgroundColor: primaryColor,
        icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
        label: Text("রিপোর্ট",
            style: GoogleFonts.notoSansBengali(
                fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- 1. Interactive Organized Calendar Strip ---
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 16, top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate.day == DateTime.now().day
                            ? "আজকের আমল"
                            : DateFormat('d MMM, yyyy').format(_selectedDate),
                        style: GoogleFonts.notoSansBengali(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          "${(currentProgress * 100).toInt()}% সম্পন্ন",
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 85,
                  child: ListView.builder(
                    controller: _calendarScrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _recentDates.length,
                    itemBuilder: (context, index) {
                      final date = _recentDates[index];
                      final isSelected = date == _selectedDate;
                      final dailyProg = _calculateDailyProgress(provider, date);

                      return GestureDetector(
                        onTap: () => setState(() => _selectedDate = date),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 4),
                          width: 65,
                          decoration: BoxDecoration(
                            color: isSelected ? primaryColor : Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                        color:
                                            primaryColor.withValues(alpha: 0.4),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4))
                                  ]
                                : [
                                    BoxShadow(
                                        color:
                                            Colors.grey.withValues(alpha: 0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2))
                                  ],
                            border: Border.all(
                                color: isSelected
                                    ? primaryColor
                                    : Colors.grey.shade200),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat('EEE').format(date).toUpperCase(),
                                style: TextStyle(
                                    color: isSelected
                                        ? Colors.white70
                                        : Colors.grey,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${date.day}",
                                style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              // Small dot indicator if all amals are done for that day
                              if (dailyProg == 1.0)
                                Container(
                                    width: 4,
                                    height: 4,
                                    decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.white
                                            : primaryColor,
                                        shape: BoxShape.circle)),
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

          // --- Main Content ---
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: 16, bottom: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- 2. GitHub Style Streak Dashboard ---
                  _buildGitHubHeatmap(provider, primaryColor),

                  // --- 3. Amal Groups ---
                  _buildAmalGroup(context, provider, 'fardh', 'ফরজ ইবাদত',
                      completedAmals, _selectedDate, primaryColor),
                  _buildAmalGroup(
                      context,
                      provider,
                      'sunnah',
                      'সুন্নাহ ও জিকির',
                      completedAmals,
                      _selectedDate,
                      primaryColor),
                  _buildAmalGroup(context, provider, 'habit', 'দৈনিক অভ্যাস',
                      completedAmals, _selectedDate, primaryColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- GitHub Heatmap Builder ---
  Widget _buildGitHubHeatmap(AmalProvider provider, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("গত ৩০ দিনের আমল",
                    style: GoogleFonts.notoSansBengali(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                Row(
                  children: [
                    Icon(Icons.local_fire_department,
                        color: Colors.orange, size: 16),
                    const SizedBox(width: 4),
                    Text("${provider.getCategoryStreak('fardh')} দিন",
                        style: GoogleFonts.notoSansBengali(
                            fontWeight: FontWeight.bold, color: Colors.orange)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _last30Days.map((date) {
                final progress = _calculateDailyProgress(provider, date);
                return Tooltip(
                  message: DateFormat('MMM d').format(date),
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: _getHeatmapColor(progress, primaryColor),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("কম",
                    style: GoogleFonts.notoSansBengali(
                        fontSize: 10, color: Colors.grey)),
                const SizedBox(width: 4),
                Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: 4),
                Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: 4),
                Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: 4),
                Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: 4),
                Text("বেশি",
                    style: GoogleFonts.notoSansBengali(
                        fontSize: 10, color: Colors.grey)),
              ],
            )
          ],
        ),
      ),
    );
  }

  // --- Amal Group ---
  Widget _buildAmalGroup(
      BuildContext context,
      AmalProvider provider,
      String category,
      String title,
      List<String> completedAmals,
      DateTime date,
      Color primaryColor) {
    final amals = provider.getAmalsByCategory(category);
    if (amals.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0, top: 12.0),
            child: Text(title,
                style: GoogleFonts.notoSansBengali(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54)),
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

// --- Animated Amal Item ---
class _AmalItem extends StatelessWidget {
  final Amal amal;
  final bool isDone;
  final Color primaryColor;
  final VoidCallback onTap;

  const _AmalItem(
      {required this.amal,
      required this.isDone,
      required this.primaryColor,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isDone ? primaryColor.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isDone
                  ? primaryColor.withValues(alpha: 0.3)
                  : Colors.grey.shade200),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: isDone
                          ? primaryColor.withValues(alpha: 0.15)
                          : Colors.grey.shade100,
                      shape: BoxShape.circle),
                  child: Icon(amal.icon,
                      size: 22,
                      color: isDone ? primaryColor : Colors.grey.shade500),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    amal.title,
                    style: GoogleFonts.notoSansBengali(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDone ? Colors.grey.shade600 : Colors.black87,
                      decoration: isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) =>
                          ScaleTransition(scale: animation, child: child),
                  child: Icon(
                    isDone ? Icons.check_circle : Icons.circle_outlined,
                    key: ValueKey<bool>(isDone),
                    size: 28,
                    color: isDone ? primaryColor : Colors.grey.shade300,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
