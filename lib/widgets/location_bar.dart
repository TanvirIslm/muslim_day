import 'package:flutter/material.dart';

class LocationBar extends StatelessWidget {
  final String location;
  final String country;
  final VoidCallback onLocationPressed;
  final bool isLoading;

  const LocationBar({
    super.key,
    required this.location,
    required this.country,
    required this.onLocationPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    const Color brandGreen = Color(0xFF1D9375);

    return Material(
      color: brandGreen,
      child: InkWell(
        onTap: isLoading ? null : onLocationPressed,
        splashColor: Colors.white.withValues(alpha: 0.2),
        highlightColor: Colors.white.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ১. স্টাইলিশ লোকেশন আইকন (বাম দিকে)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15), // হালকা গ্লাস ইফেক্ট
                  borderRadius: BorderRadius.circular(10), // সুন্দর স্কয়ার-রাউন্ডেড শেপ
                ),
                child: const Icon(
                  Icons.location_on_rounded, // রাউন্ডেড আইকন দেখতে বেশি আধুনিক লাগে
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),

              // ২. লোকেশন এবং দেশের নাম (এক সারিতে)
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Flexible(
                      child: Text(
                        location,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 0.3,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (country.trim().isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Text(
                        country,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // ৩. স্টাইলিশ ডানদিকের আইকন / লোডিং
              isLoading
                  ? Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2), // আইকনটিকে একটু বেশি হাইলাইট করা হয়েছে
                        shape: BoxShape.circle, // পুরোপুরি গোলাকার শেপ
                      ),
                      child: const Icon(
                        Icons.keyboard_arrow_right_rounded, // অ্যারো রাইট (পেজ চেঞ্জ বোঝাতে)
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}