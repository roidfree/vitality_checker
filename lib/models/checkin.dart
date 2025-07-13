class CheckIn {
  final String id;
  final String timestamp;
  final String deviceId;

  CheckIn({required this.id, required this.timestamp, required this.deviceId});

  Map<String, dynamic> toMap() {
    return {'id': id, 'timestamp': timestamp, 'device_id': deviceId};
  }

  factory CheckIn.fromMap(Map<String, dynamic> map) {
    return CheckIn(
      id: map['id'],
      timestamp: map['timestamp'],
      deviceId: map['device_id'],
    );
  }

  @override
  String toString() {
    return 'CheckIn{id: $id, timestamp: $timestamp, deviceId: $deviceId}';
  }
}
