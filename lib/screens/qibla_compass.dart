import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:adhan/adhan.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' as math;

class QiblaCompassScreen extends StatefulWidget {
  const QiblaCompassScreen({Key? key}) : super(key: key);

  @override
  State<QiblaCompassScreen> createState() => _QiblaCompassScreenState();
}

class _QiblaCompassScreenState extends State<QiblaCompassScreen> {
  late Coordinates coordinates;
  bool locationLoaded = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final permission = await Permission.location.request();
      if (!permission.isGranted) {
        setState(() {
          errorMessage = "অবস্থান অনুমতি প্রয়োজন";
          locationLoaded = true;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () async =>
            await Geolocator.getLastKnownPosition() ??
            Position(
              longitude: 90.4068,
              latitude: 23.8103,
              timestamp: DateTime.now(),
              accuracy: 0,
              altitude: 0,
              heading: 0,
              speed: 0,
              speedAccuracy: 0,
              altitudeAccuracy: 0,
              headingAccuracy: 0,
            ),
      );

      setState(() {
        coordinates = Coordinates(position.latitude, position.longitude);
        locationLoaded = true;
      });
    } catch (e) {
      setState(() {
        errorMessage = "অবস্থান লোড করতে ব্যর্থ: $e";
        locationLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!locationLoaded) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "কিবলা কম্পাস",
            style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.teal.shade600,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.teal),
              SizedBox(height: 20),
              Text("অবস্থান লোড হচ্ছে..."),
            ],
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "কিবলা কম্পাস",
            style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.teal.shade600,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 60, color: Colors.red.shade400),
              const SizedBox(height: 20),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSansBengali(fontSize: 16),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    locationLoaded = false;
                    errorMessage = null;
                  });
                  _getCurrentLocation();
                },
                child: const Text("পুনরায় চেষ্টা করুন"),
              ),
            ],
          ),
        ),
      );
    }

    final qiblaDirection = Qibla(coordinates).direction;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "কিবলা কম্পাস",
          style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal.shade600,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: StreamBuilder<CompassEvent>(
        stream: FlutterCompass.events,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.compass_calibration,
                      size: 60, color: Colors.orange.shade400),
                  const SizedBox(height: 20),
                  Text(
                    "কম্পাস সেন্সর উপলব্ধ নয়",
                    style: GoogleFonts.notoSansBengali(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.teal.shade600),
                  const SizedBox(height: 20),
                  Text(
                    "কম্পাস ক্যালিব্রেট করা হচ্ছে...",
                    style: GoogleFonts.notoSansBengali(fontSize: 14),
                  ),
                ],
              ),
            );
          }

          double? deviceHeading = snapshot.data!.heading ?? 0;
          double relativeAngle = (qiblaDirection - deviceHeading);
          double relativeAngleRadians = relativeAngle * (math.pi / 180.0);
          double deviceHeadingRadians = deviceHeading * (math.pi / 180.0);

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "কিবলার দিক",
                    style: GoogleFonts.notoSansBengali(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${qiblaDirection.toStringAsFixed(1)}°",
                    style: const TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  const SizedBox(height: 40),

                  // Enhanced Compass UI
                  Container(
                    width: 320,
                    height: 320,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.3),
                            blurRadius: 10,
                            spreadRadius: 2),
                      ],
                      gradient: RadialGradient(
                        colors: [Colors.white, Colors.grey.shade100],
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Border
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.teal.shade400, width: 3),
                          ),
                        ),

                        // NSEW indicators
                        Transform.rotate(
                          angle: -deviceHeadingRadians,
                          child: const Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                top: 15,
                                child: Text("N",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red)),
                              ),
                              Positioned(
                                bottom: 15,
                                child: Text("S",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey)),
                              ),
                              Positioned(
                                right: 15,
                                child: Text("E",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey)),
                              ),
                              Positioned(
                                left: 15,
                                child: Text("W",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey)),
                              ),
                            ],
                          ),
                        ),

                        // Qibla needle
                        Transform.rotate(
                          angle: relativeAngleRadians,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.teal.shade100,
                                ),
                                child: const Icon(Icons.mosque,
                                    size: 50, color: Colors.teal),
                              ),
                              Container(
                                  width: 5,
                                  height: 90,
                                  color: Colors.teal.shade600),
                            ],
                          ),
                        ),

                        // Center dot
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.teal.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.teal.shade200),
                    ),
                    child: Text(
                      "সবুজ মসজিদ আইকন কিবলার দিক নির্দেশ করে। আপনার ফোন ঘোরান যতক্ষণ না এটি সরাসরি উপরে থাকে।",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSansBengali(
                          fontSize: 14, color: Colors.teal.shade800),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
