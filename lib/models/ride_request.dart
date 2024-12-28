import 'user.dart';

class RideRequest {
  final String id;
  final User rider;
  final String pickup;
  final String dropoff;
  final DateTime createdAt;
  User? driver;
  String status;

  RideRequest({
    required this.id,
    required this.rider,
    required this.pickup,
    required this.dropoff,
    required this.createdAt,
    this.driver,
    this.status = 'pending',
  });
}
