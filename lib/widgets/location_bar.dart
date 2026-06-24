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
    // Defined primary green here to keep it consistent
    const Color brandGreen = Color(0xFF1D9375);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      color: brandGreen, // Changed from Colors.white to brandGreen
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_on,
              color: Colors.white, size: 20), // Icon is now white
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  country,
                  style: const TextStyle(
                    color: Colors
                        .white70, // Slightly transparent white for country
                    fontSize: 12,
                  ),
                ),
                Text(
                  location,
                  style: const TextStyle(
                    color: Colors.white, // Location text is now solid white
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white), // Spinner is now white
                  )
                : const Icon(Icons.my_location,
                    color: Colors.white, size: 24), // Button is now white
            onPressed: isLoading ? null : onLocationPressed,
            tooltip: "Detect Current Location",
          ),
        ],
      ),
    );
  }
}
