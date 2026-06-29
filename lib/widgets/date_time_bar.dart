import 'package:flutter/material.dart';

class DateTimeBar extends StatelessWidget {
  final String gregorianDate, hijriDate, sunriseTime, sunsetTime;
  const DateTimeBar({
    super.key,
    required this.gregorianDate,
    required this.hijriDate,
    required this.sunriseTime,
    required this.sunsetTime,
  });

  @override
  Widget build(BuildContext context) {
    // ব্র্যান্ড কালারের সাথে একটি ডার্ক টোন নিয়ে গ্রেডিয়েন্ট তৈরি
    const Color primaryColor = Color(0xFF1D9375);
    const Color darkColor = Color(0xFF126E56);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        // ১. Linear Gradient: কার্ডটিতে গভীরতা (Depth) আনবে
        gradient: const LinearGradient(
          colors: [primaryColor, darkColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24), // একটু বেশি রাউন্ডেড শেপ
        // ২. Soft Glow Shadow: প্রিমিয়াম ফিল দেওয়ার জন্য
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      // ClipRRect ব্যবহার করা হয়েছে যাতে ব্যাকগ্রাউন্ডের ওয়াটারমার্ক কার্ডের বাইরে না যায়
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // ৩. Watermark Effect: ব্যাকগ্রাউন্ডে একটি বিশাল, হালকা আইকন (Pro Tip)
            Positioned(
              right: -25,
              top: -25,
              child: Transform.rotate(
                angle: -0.2,
                child: Icon(
                  Icons.nights_stay_rounded, // ইসলামিক থিমের সাথে মানানসই
                  size: 130,
                  color: Colors.white.withValues(alpha: 0.08), // খুবই হালকা দৃশ্যমান
                ),
              ),
            ),
            
            // মূল কন্টেন্ট
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // বাম দিক: তারিখের অংশ
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ৪. Glassmorphism Badge: হিজরি তারিখের জন্য প্রিমিয়াম ব্যাজ
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            hijriDate,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // ইংরেজি তারিখ
                        Text(
                          gregorianDate,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // ডান দিক: সূর্যোদয় ও সূর্যাস্ত (Frosted Glass Panel)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildTimeItem(Icons.wb_sunny_rounded, 'সূর্যোদয়', sunriseTime),
                        const SizedBox(width: 12),
                        // ডিভাইডার লাইন
                        Container(
                          width: 1,
                          height: 32,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                        const SizedBox(width: 12),
                        _buildTimeItem(Icons.wb_twilight_rounded, 'সূর্যাস্ত', sunsetTime),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeItem(IconData icon, String label, String time) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ৫. Color Accent: সাদা লেখার সাথে আইকনগুলোতে হালকা হলুদ/কমলা ছোঁয়া
        Icon(icon, color: Colors.amber.shade300, size: 22), 
        const SizedBox(height: 4),
        Text(
          time,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}