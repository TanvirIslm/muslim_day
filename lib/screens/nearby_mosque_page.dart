import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class NearbyMosquePage extends StatefulWidget {
  const NearbyMosquePage({super.key});

  @override
  State<NearbyMosquePage> createState() => _NearbyMosquePageState();
}

class _NearbyMosquePageState extends State<NearbyMosquePage> {
  Position? _currentPosition;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final permissionStatus = await Permission.location.request();
      
      if (permissionStatus.isGranted) {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        
        setState(() {
          _currentPosition = position;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'লোকেশন অনুমতি প্রয়োজন';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'লোকেশন পেতে ব্যর্থ: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          'নিকটবর্তী মসজিদ',
          style: GoogleFonts.notoSansBengali(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1A4D4D),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _getCurrentLocation,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF1D9375),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              style: GoogleFonts.notoSansBengali(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.refresh),
              label: Text(
                'আবার চেষ্টা করুন',
                style: GoogleFonts.notoSansBengali(),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D9375),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_currentPosition == null) {
      return Center(
        child: Text(
          'লোকেশন লোড হচ্ছে...',
          style: GoogleFonts.notoSansBengali(fontSize: 16),
        ),
      );
    }

    return Column(
      children: [
        _buildLocationInfo(),
        Expanded(
          child: _buildMosqueList(),
        ),
      ],
    );
  }

  Widget _buildLocationInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1D9375).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.my_location,
              color: Color(0xFF1D9375),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'আপনার অবস্থান',
                  style: GoogleFonts.notoSansBengali(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'নিকটবর্তী মসজিদ খুঁজছি...',
                  style: GoogleFonts.notoSansBengali(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMosqueList() {
    // Sample data - In production, you would fetch from Google Maps API or similar
    final mosques = _getSampleMosques();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mosques.length,
      itemBuilder: (context, index) {
        final mosque = mosques[index];
        return _buildMosqueCard(mosque);
      },
    );
  }

  Widget _buildMosqueCard(Map<String, dynamic> mosque) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showMosqueDetails(mosque),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D9375).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.mosque,
                      color: Color(0xFF1D9375),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mosque['name'],
                          style: GoogleFonts.notoSansBengali(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              mosque['distance'],
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getRatingColor(mosque['rating']).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          size: 14,
                          color: _getRatingColor(mosque['rating']),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          mosque['rating'].toString(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _getRatingColor(mosque['rating']),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                mosque['address'],
                style: GoogleFonts.notoSansBengali(
                  fontSize: 13,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _openInMaps(mosque),
                      icon: const Icon(Icons.directions, size: 18),
                      label: Text(
                        'দিক নির্দেশনা',
                        style: GoogleFonts.notoSansBengali(fontSize: 12),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF1D9375),
                        side: const BorderSide(color: Color(0xFF1D9375)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _callMosque(mosque),
                      icon: const Icon(Icons.phone, size: 18),
                      label: Text(
                        'কল করুন',
                        style: GoogleFonts.notoSansBengali(fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D9375),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRatingColor(double rating) {
    if (rating >= 4.5) return Colors.green;
    if (rating >= 4.0) return Colors.lightGreen;
    if (rating >= 3.5) return Colors.orange;
    return Colors.red;
  }

  void _showMosqueDetails(Map<String, dynamic> mosque) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D9375).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.mosque,
                      color: Color(0xFF1D9375),
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mosque['name'],
                          style: GoogleFonts.notoSansBengali(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 16, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              '${mosque['rating']} • ${mosque['distance']}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 32),
              _buildDetailRow(Icons.location_on, 'ঠিকানা', mosque['address']),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.phone, 'ফোন', mosque['phone']),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.access_time, 'খোলা থাকে', mosque['openHours']),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _openInMaps(mosque);
                      },
                      icon: const Icon(Icons.directions),
                      label: Text(
                        'দিক নির্দেশনা',
                        style: GoogleFonts.notoSansBengali(),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF1D9375),
                        side: const BorderSide(color: Color(0xFF1D9375)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _callMosque(mosque);
                      },
                      icon: const Icon(Icons.phone),
                      label: Text(
                        'কল করুন',
                        style: GoogleFonts.notoSansBengali(),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D9375),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.notoSansBengali(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.notoSansBengali(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _openInMaps(Map<String, dynamic> mosque) async {
    final lat = mosque['lat'];
    final lng = mosque['lng'];
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'ম্যাপ খুলতে ব্যর্থ',
              style: GoogleFonts.notoSansBengali(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _callMosque(Map<String, dynamic> mosque) async {
    final phone = mosque['phone'];
    final url = 'tel:$phone';
    
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'কল করতে ব্যর্থ',
              style: GoogleFonts.notoSansBengali(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<Map<String, dynamic>> _getSampleMosques() {
    // Sample data - Replace with actual API data in production
    return [
      {
        'name': 'বায়তুল মোকাররম জাতীয় মসজিদ',
        'address': 'বায়তুল মোকাররম, ঢাকা',
        'distance': '০.৫ কিমি',
        'rating': 4.8,
        'phone': '+880 1234567890',
        'openHours': 'সর্বদা খোলা',
        'lat': 23.7317,
        'lng': 90.3956,
      },
      {
        'name': 'আজাদ মসজিদ',
        'address': 'গুলশান, ঢাকা',
        'distance': '১.২ কিমি',
        'rating': 4.6,
        'phone': '+880 1234567891',
        'openHours': 'সর্বদা খোলা',
        'lat': 23.7808,
        'lng': 90.4106,
      },
      {
        'name': 'কাকরাইল মসজিদ',
        'address': 'কাকরাইল, ঢাকা',
        'distance': '১.৮ কিমি',
        'rating': 4.7,
        'phone': '+880 1234567892',
        'openHours': 'সর্বদা খোলা',
        'lat': 23.7379,
        'lng': 90.3956,
      },
      {
        'name': 'গুলশান সেন্ট্রাল মসজিদ',
        'address': 'গুলশান ২, ঢাকা',
        'distance': '২.৩ কিমি',
        'rating': 4.5,
        'phone': '+880 1234567893',
        'openHours': 'সর্বদা খোলা',
        'lat': 23.7925,
        'lng': 90.4078,
      },
      {
        'name': 'ধানমন্ডি জামে মসজিদ',
        'address': 'ধানমন্ডি, ঢাকা',
        'distance': '৩.০ কিমি',
        'rating': 4.4,
        'phone': '+880 1234567894',
        'openHours': 'সর্বদা খোলা',
        'lat': 23.7461,
        'lng': 90.3742,
      },
    ];
  }
}