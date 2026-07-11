import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:math' show cos, sqrt;

// Prayer time types including nafil and prohibited times
enum PrayerTimeType {
  fajr,
  sunrise,
  dhuhr,
  asr,
  maghrib,
  isha,
  tahajjud,
  ishrak,
  duha,
  prohibitedAfterFajr,
  prohibitedBeforeDhuhr,
  prohibitedAfterAsr,
}

class ExtendedPrayerTime {
  final String name;
  final String nameBn;
  final DateTime time;
  final PrayerTimeType type;
  final bool isProhibited;
  final bool isNafil;

  ExtendedPrayerTime({
    required this.name,
    required this.nameBn,
    required this.time,
    required this.type,
    this.isProhibited = false,
    this.isNafil = false,
  });
}

class PrayerSettings extends ChangeNotifier {
  late SharedPreferences _prefs;

  Coordinates _coordinates = Coordinates(23.8103, 90.4125);
  String _locationName = "ঢাকা, বাংলাদেশ";
  CalculationMethod _calculationMethod = CalculationMethod.karachi;
  Madhab _madhab = Madhab.hanafi;
  bool _isLoading = true;

  Coordinates get coordinates => _coordinates;
  String get locationName => _locationName;
  CalculationMethod get calculationMethod => _calculationMethod;
  Madhab get madhab => _madhab;
  bool get isLoading => _isLoading;

  double get latitude => _coordinates.latitude;
  double get longitude => _coordinates.longitude;

  CalculationParameters get calculationParams {
    final params = _calculationMethod.getParameters();
    params.madhab = _madhab;
    return params;
  }

  String getCalculationMethodName(CalculationMethod method) {
    switch (method) {
      case CalculationMethod.muslim_world_league:
        return "Muslim World League";
      case CalculationMethod.egyptian:
        return "Egyptian General Authority";
      case CalculationMethod.karachi:
        return "University of Islamic Sciences, Karachi";
      case CalculationMethod.umm_al_qura:
        return "Umm al-Qura University, Makkah";
      case CalculationMethod.dubai:
        return "Dubai (UAE)";
      case CalculationMethod.qatar:
        return "Qatar";
      case CalculationMethod.kuwait:
        return "Kuwait";
      case CalculationMethod.singapore:
        return "Singapore";
      case CalculationMethod.north_america:
        return "ISNA (North America)";
      case CalculationMethod.moon_sighting_committee:
        return "Moonsighting Committee";
      case CalculationMethod.tehran:
        return "Tehran";
      default:
        return method.name;
    }
  }

  // Get all extended prayer times including nafil and prohibited times
  List<ExtendedPrayerTime> getExtendedPrayerTimes(DateTime date) {
    final prayerTimes = PrayerTimes.today(_coordinates, calculationParams);
    final List<ExtendedPrayerTime> times = [];

    // Fajr
    times.add(ExtendedPrayerTime(
      name: 'Fajr',
      nameBn: 'ফজর',
      time: prayerTimes.fajr,
      type: PrayerTimeType.fajr,
    ));

    // Prohibited time after Fajr (from sunrise until Ishrak)
    times.add(ExtendedPrayerTime(
      name: 'Prohibited (After Fajr)',
      nameBn: 'নিষিদ্ধ সময় (ফজরের পর)',
      time: prayerTimes.sunrise,
      type: PrayerTimeType.prohibitedAfterFajr,
      isProhibited: true,
    ));

    // Sunrise
    times.add(ExtendedPrayerTime(
      name: 'Sunrise',
      nameBn: 'সূর্যোদয়',
      time: prayerTimes.sunrise,
      type: PrayerTimeType.sunrise,
    ));

    // Ishrak (15-20 mins after sunrise)
    final ishrakTime = prayerTimes.sunrise.add(const Duration(minutes: 20));
    times.add(ExtendedPrayerTime(
      name: 'Ishrak',
      nameBn: 'ইশরাক',
      time: ishrakTime,
      type: PrayerTimeType.ishrak,
      isNafil: true,
    ));

    // Duha (Mid-morning)
    final duhaTime = prayerTimes.sunrise.add(
      Duration(
        minutes:
            (prayerTimes.dhuhr.difference(prayerTimes.sunrise).inMinutes * 0.4)
                .round(),
      ),
    );
    times.add(ExtendedPrayerTime(
      name: 'Duha',
      nameBn: 'চাশত',
      time: duhaTime,
      type: PrayerTimeType.duha,
      isNafil: true,
    ));

    // Prohibited before Dhuhr (10-15 mins before)
    times.add(ExtendedPrayerTime(
      name: 'Prohibited (Before Dhuhr)',
      nameBn: 'নিষিদ্ধ সময় (জোহরের আগে)',
      time: prayerTimes.dhuhr.subtract(const Duration(minutes: 10)),
      type: PrayerTimeType.prohibitedBeforeDhuhr,
      isProhibited: true,
    ));

    // Dhuhr
    times.add(ExtendedPrayerTime(
      name: 'Dhuhr',
      nameBn: 'যোহর',
      time: prayerTimes.dhuhr,
      type: PrayerTimeType.dhuhr,
    ));

    // Asr
    times.add(ExtendedPrayerTime(
      name: 'Asr',
      nameBn: 'আসর',
      time: prayerTimes.asr,
      type: PrayerTimeType.asr,
    ));

    // Prohibited after Asr (until Maghrib)
    // নিষিদ্ধ সময় শুধুমাত্র সূর্যাস্তের ঠিক আগ মুহূর্তের জন্য (সবসময় নয়)
    final maghribStart = prayerTimes.maghrib;
    times.add(ExtendedPrayerTime(
      name: 'Prohibited (Sunset)',
      nameBn: 'নিষিদ্ধ সময় (সূর্যাস্তের আগে)',
      time: maghribStart.subtract(const Duration(minutes: 15)),
      type: PrayerTimeType.prohibitedAfterAsr,
      isProhibited: true,
    ));

    // Maghrib
    times.add(ExtendedPrayerTime(
      name: 'Maghrib',
      nameBn: 'মাগরিব',
      time: prayerTimes.maghrib,
      type: PrayerTimeType.maghrib,
    ));

    // Isha
    times.add(ExtendedPrayerTime(
      name: 'Isha',
      nameBn: 'ইশা',
      time: prayerTimes.isha,
      type: PrayerTimeType.isha,
    ));

    // Tahajjud
    final nightDurationMinutes =
        prayerTimes.fajr.difference(prayerTimes.isha).inMinutes;
    final tahajjudStart = prayerTimes.isha.add(
      Duration(minutes: ((nightDurationMinutes * 2) / 3).round()),
    );
    times.add(ExtendedPrayerTime(
      name: 'Tahajjud',
      nameBn: 'তাহাজ্জুদ',
      time: tahajjudStart,
      type: PrayerTimeType.tahajjud,
      isNafil: true,
    ));

    return times;
  }

  // Get only the 5 fard prayers
  List<ExtendedPrayerTime> getFivePrayers(DateTime date) {
    final allTimes = getExtendedPrayerTimes(date);
    return allTimes
        .where((time) =>
            !time.isNafil &&
            !time.isProhibited &&
            time.type != PrayerTimeType.sunrise)
        .toList();
  }

  PrayerSettings() {
    _loadSettings();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> updateCalculationMethod(CalculationMethod method) async {
    _calculationMethod = method;
    await _prefs.setString('calculationMethod', method.name);
    notifyListeners();
  }

  Future<void> updateMadhab(Madhab madhab) async {
    _madhab = madhab;
    await _prefs.setString('madhab', madhab.name);
    notifyListeners();
  }

  Future<void> updateManualLocation(
      double latitude, double longitude, String locationName) async {
    _coordinates = Coordinates(latitude, longitude);
    _locationName = locationName;

    await _prefs.setDouble('latitude', latitude);
    await _prefs.setDouble('longitude', longitude);
    await _prefs.setString('locationName', locationName);

    notifyListeners();
  }

  Future<bool> detectCurrentLocation() async {
    _setLoading(true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _setLoading(false);
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _setLoading(false);
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _setLoading(false);
        return false;
      }

      Position? position;

      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
          timeLimit: const Duration(seconds: 10),
        );
      } catch (e) {
        debugPrint("Live GPS failed, using fallback. Error: $e");
        position = await Geolocator.getLastKnownPosition();
      }

      if (position == null) {
        _setLoading(false);
        return false;
      }

      _coordinates = Coordinates(position.latitude, position.longitude);

      // Attempt 1: Try to get the real city name from the internet
      bool nameFound = false;
      try {
        List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          geo.Placemark place = placemarks[0];

          // Try to get a meaningful name. Sometimes locality is null, so we check subAdministrativeArea too
          String city = place.locality ?? place.subAdministrativeArea ?? "";
          if (city.isNotEmpty) {
            _locationName = "$city, ${place.country ?? 'বাংলাদেশ'}";
            nameFound = true;
          }
        }
      } catch (e) {
        debugPrint("Geocoding failed: $e");
      }

      // Attempt 2: Mathematical Fallback (If internet geocoding fails)
      if (!nameFound) {
        _locationName =
            _getClosestDistrictName(position.latitude, position.longitude);
      }

      // Save to phone memory
      await _prefs.setDouble('latitude', _coordinates.latitude);
      await _prefs.setDouble('longitude', _coordinates.longitude);
      await _prefs.setString('locationName', _locationName);

      _setLoading(false);
      notifyListeners();

      return true;
    } catch (e) {
      debugPrint("Fatal error detecting location: $e");
      _setLoading(false);
      return false;
    }
  }

  // Add this new function right below detectCurrentLocation()
  String _getClosestDistrictName(double currentLat, double currentLng) {
    // This is a simplified list of your districts for fallback matching
    final List<Map<String, dynamic>> fallbackDistricts = [
      {"name": "ঢাকা", "lat": 23.8103, "lng": 90.4125},
      {"name": "চট্টগ্রাম", "lat": 22.3569, "lng": 91.7832},
      {"name": "রাজশাহী", "lat": 24.3745, "lng": 88.6042},
      {"name": "খুলনা", "lat": 22.8456, "lng": 89.5403},
      {"name": "বরিশাল", "lat": 22.7010, "lng": 90.3535},
      {"name": "সিলেট", "lat": 24.8949, "lng": 91.8687},
      {"name": "রংপুর", "lat": 25.7439, "lng": 89.2752},
      {"name": "ময়মনসিংহ", "lat": 24.7471, "lng": 90.4203},
    ];

    double minDistance = double.infinity;
    String closestName = "অজানা লোকেশন";

    for (var district in fallbackDistricts) {
      double dLat =
          (district["lat"] - currentLat) * 0.0174533; // convert to radians
      double dLng = (district["lng"] - currentLng) * 0.0174533;
      // Simple Pythagorean distance approximation
      double a = dLat * dLat +
          dLng *
              dLng *
              cos(currentLat * 0.0174533) *
              cos(district["lat"] * 0.0174533);
      double distance = sqrt(a);

      if (distance < minDistance) {
        minDistance = distance;
        closestName = "${district["name"]}, বাংলাদেশ";
      }
    }

    return closestName;
  }

  // --- Save & Load ---
  Future<void> _loadSettings() async {
    _setLoading(true);
    _prefs = await SharedPreferences.getInstance();

    double latitude = _prefs.getDouble('latitude') ?? _coordinates.latitude;
    double longitude = _prefs.getDouble('longitude') ?? _coordinates.longitude;
    _coordinates = Coordinates(latitude, longitude);
    _locationName = _prefs.getString('locationName') ?? _locationName;

    String methodName =
        _prefs.getString('calculationMethod') ?? _calculationMethod.name;
    _calculationMethod = CalculationMethod.values.firstWhere(
        (m) => m.name == methodName,
        orElse: () => CalculationMethod.karachi);

    String madhabName = _prefs.getString('madhab') ?? _madhab.name;
    _madhab = Madhab.values
        .firstWhere((m) => m.name == madhabName, orElse: () => Madhab.hanafi);

    _setLoading(false);
  }
}
