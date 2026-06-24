import 'package:flutter/material.dart';

class DateTimeBar extends StatelessWidget {
  final String gregorianDate;
  final String hijriDate;
  final String sunriseTime;
  final String sunsetTime;

  const DateTimeBar({
    super.key,
    required this.gregorianDate,
    required this.hijriDate,
    required this.sunriseTime,
    required this.sunsetTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1D9375),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hijriDate, style: const TextStyle(color: Colors.white)),
                Text(gregorianDate,
                    style: const TextStyle(color: Colors.white, height: 1.4)),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(Icons.wb_sunny_outlined, color: Colors.white),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('সূর্যোদয়: $sunriseTime',
                      style: const TextStyle(color: Colors.white)),
                  Text('সূর্যাস্ত: $sunsetTime',
                      style: const TextStyle(color: Colors.white)),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
