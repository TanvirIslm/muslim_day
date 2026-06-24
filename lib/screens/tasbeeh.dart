import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class TasbeehCounterScreen extends StatefulWidget {
  const TasbeehCounterScreen({Key? key}) : super(key: key);

  @override
  State<TasbeehCounterScreen> createState() => _TasbeehCounterScreenState();
}

class _TasbeehCounterScreenState extends State<TasbeehCounterScreen>
    with SingleTickerProviderStateMixin {
  int _currentCount = 0;
  int _totalCount = 0;
  int _targetCount = 33;
  late SharedPreferences _prefs;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  static const String _totalCountKey = 'tasbeeh_total_count';

  @override
  void initState() {
    super.initState();
    _loadTotalCount();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadTotalCount() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _totalCount = _prefs.getInt(_totalCountKey) ?? 0;
    });
  }

  Future<void> _incrementCount() async {
    HapticFeedback.lightImpact();
    _animationController.forward().then((_) => _animationController.reverse());

    setState(() {
      _currentCount++;
      _totalCount++;
    });

    await _prefs.setInt(_totalCountKey, _totalCount);

    if (_currentCount == _targetCount) {
      HapticFeedback.heavyImpact();
      _showCompletionDialog();
    }
  }

  void _resetCurrentCount() {
    setState(() {
      _currentCount = 0;
    });
    HapticFeedback.mediumImpact();
  }

  void _resetTotalCount() {
    setState(() {
      _totalCount = 0;
      _currentCount = 0;
    });
    _prefs.setInt(_totalCountKey, 0);
    HapticFeedback.mediumImpact();
  }

  void _setTarget(int newTarget) {
    setState(() {
      _targetCount = newTarget;
      _currentCount = 0;
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.teal, size: 30),
            const SizedBox(width: 12),
            Text(
              'সম্পন্ন!',
              style: GoogleFonts.notoSansBengali(
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ],
        ),
        content: Text(
          'আপনি $_targetCount বার সম্পন্ন করেছেন।',
          style: GoogleFonts.notoSansBengali(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ঠিক আছে', style: GoogleFonts.notoSansBengali()),
          ),
        ],
      ),
    );
  }

  String _toBengaliNumber(int number) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const bengali = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    String numStr = number.toString();
    for (int i = 0; i < english.length; i++) {
      numStr = numStr.replaceAll(english[i], bengali[i]);
    }
    return numStr;
  }

  @override
  Widget build(BuildContext context) {
    final double progress =
        _targetCount > 0 ? _currentCount / _targetCount : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "তাসবীহ কাউন্টার",
          style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1D9375),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'মোট রিসেট',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: Text('নিশ্চিত করুন',
                      style: GoogleFonts.notoSansBengali()),
                  content: Text('আপনি কি মোট কাউন্ট রিসেট করতে চান?',
                      style: GoogleFonts.notoSansBengali()),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('না', style: GoogleFonts.notoSansBengali()),
                    ),
                    TextButton(
                      onPressed: () {
                        _resetTotalCount();
                        Navigator.pop(context);
                      },
                      child: Text('হ্যাঁ',
                          style:
                              GoogleFonts.notoSansBengali(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1D9375).withValues(alpha: 0.05),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Stats Cards
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'মোট',
                        _toBengaliNumber(_totalCount),
                        Icons.format_list_numbered,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'লক্ষ্য',
                        _toBengaliNumber(_targetCount),
                        Icons.flag,
                        Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),

              // Progress Indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'অগ্রগতি',
                          style: GoogleFonts.notoSansBengali(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          '${_toBengaliNumber(_currentCount)}/${_toBengaliNumber(_targetCount)}',
                          style: GoogleFonts.notoSansBengali(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1D9375),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 12,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF1D9375)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Main Counter Button
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: _incrementCount,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF1D9375),
                              const Color(0xFF1D9375).withValues(alpha: 0.7),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1D9375)
                                  .withValues(alpha: 0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _toBengaliNumber(_currentCount),
                                style: GoogleFonts.notoSansBengali(
                                  fontSize: 80,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'ট্যাপ করুন',
                                style: GoogleFonts.notoSansBengali(
                                  fontSize: 16,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Target Selection & Reset
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      'লক্ষ্য নির্বাচন করুন',
                      style: GoogleFonts.notoSansBengali(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTargetButton(11),
                        const SizedBox(width: 12),
                        _buildTargetButton(33),
                        const SizedBox(width: 12),
                        _buildTargetButton(99),
                        const SizedBox(width: 12),
                        _buildTargetButton(100),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _resetCurrentCount,
                      icon: const Icon(Icons.refresh),
                      label: Text(
                        'বর্তমান রিসেট',
                        style: GoogleFonts.notoSansBengali(),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.notoSansBengali(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.notoSansBengali(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetButton(int target) {
    final bool isSelected = _targetCount == target;
    return InkWell(
      onTap: () => _setTarget(target),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1D9375) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF1D9375) : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF1D9375).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          _toBengaliNumber(target),
          style: GoogleFonts.notoSansBengali(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}
