import 'dart:io';
import 'package:uuid/uuid.dart';
import '../database/database_helper.dart';
import '../models/checkin.dart';

class CheckInService {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final Uuid _uuid = const Uuid();
  late String _deviceId;

  CheckInService() {
    _initializeDeviceId();
  }

  void _initializeDeviceId() {
    // Generate a unique device ID for this app installation
    // In a real app, you might want to store this in shared preferences
    _deviceId = _uuid.v7();
  }

  Future<CheckIn> performCheckIn() async {
    final checkIn = CheckIn(
      id: _uuid.v7(), // UUID v7 includes timestamp
      timestamp: DateTime.now().toIso8601String(),
      deviceId: _deviceId,
    );

    await _dbHelper.insertCheckIn(checkIn);
    return checkIn;
  }

  Future<List<CheckIn>> getAllCheckIns() async {
    return await _dbHelper.getAllCheckIns();
  }

  Future<List<CheckIn>> getRecentCheckIns(int limit) async {
    return await _dbHelper.getRecentCheckIns(limit);
  }

  Future<int> getCheckInCount() async {
    return await _dbHelper.getCheckInCount();
  }

  Future<CheckIn?> getLastCheckIn() async {
    return await _dbHelper.getLastCheckIn();
  }

  String get deviceId => _deviceId;
}
