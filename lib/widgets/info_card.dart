import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String? content;
  final bool hasInfoIcon;
  final bool isSimple;
  final IconData? icon;

  // Properties for the Sehri/Iftar card type
  final String? time;
  final bool isCountdown;

  // Main constructor for the grid cards
  const InfoCard({
    super.key,
    required this.title,
    this.content,
    this.hasInfoIcon = false,
    this.isSimple = false,
    this.icon,
  })  : time = null,
        isCountdown = false;

  // Named constructor for creating the Sehri/Iftar style card
  const InfoCard.sehriIftar({
    super.key,
    required this.title,
    required this.time,
    this.isCountdown = false,
  })  : content = null,
        hasInfoIcon = false,
        isSimple = false,
        icon = null;

  @override
  Widget build(BuildContext context) {
    // If 'time' is not null, we build the special Sehri/Iftar card.
    // Otherwise, we build the regular info card.
    if (time != null) {
      return _buildSehriIftarCard();
    } else {
      return _buildGridCard();
    }
  }

  // Helper method to build the regular info card
  Widget _buildGridCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.5,
        ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isSimple ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: const Color(0xFF1D9375), size: 20),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              if (hasInfoIcon) const SizedBox(width: 8),
              if (hasInfoIcon) const Icon(Icons.info_outline, color: Colors.black54, size: 18),
            ],
          ),
          if (!isSimple && content != null) ...[
            const SizedBox(height: 8),
            Text(
              content!,
              style: const TextStyle(color: Colors.black54, fontSize: 12, height: 1.5),
            ),
          ]
        ],
      ),
    );
  }


  Widget _buildSehriIftarCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.5,
        ),
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
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.black87), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(
            time!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: isCountdown ? const Color(0xFFD32F2F) : const Color(0xFF1D9375),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF1D9375).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.alarm, color: Color(0xFF1D9375), size: 16),
                const SizedBox(width: 4),
                Text(
                  'অ্যালার্ম',
                  style: TextStyle(color: Colors.grey[700], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}