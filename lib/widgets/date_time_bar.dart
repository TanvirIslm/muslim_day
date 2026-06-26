import 'package:flutter/material.dart';

class DateTimeBar extends StatelessWidget {
  final String gregorianDate, hijriDate, sunriseTime, sunsetTime;
  const DateTimeBar({super.key, required this.gregorianDate, required this.hijriDate, required this.sunriseTime, required this.sunsetTime});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1D9375),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: const Color(0xFF1D9375).withAlpha(60), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hijriDate, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
                Text(gregorianDate, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Row(
            children: [
              _buildTimeItem(Icons.wb_sunny_rounded, 'সূর্যোদয়', sunriseTime),
              const SizedBox(width: 16),
              Container(width: 1, height: 30, color: Colors.white24),
              const SizedBox(width: 16),
              _buildTimeItem(Icons.wb_twilight_rounded, 'সূর্যাস্ত', sunsetTime),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeItem(IconData icon, String label, String time) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(height: 4),
        Text(time, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
      ],
    );
  }
}