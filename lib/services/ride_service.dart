import '../models/ride_request.dart';
import '../models/user.dart';
import 'auth_service.dart';

class RideService {
  final List<RideRequest> _rideRequests = [];

  Future<RideRequest> createRideRequest(String pickup, String dropoff) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final user = authService.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final rideRequest = RideRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      rider: user,
      pickup: pickup,
      dropoff: dropoff,
      createdAt: DateTime.now(),
    );

    _rideRequests.add(rideRequest);
    return rideRequest;
  }

  List<RideRequest> getPendingRideRequests() {
    return _rideRequests
        .where((request) => request.status == 'pending')
        .toList();
  }

  Future<void> acceptRideRequest(RideRequest request, User driver) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    request.driver = driver;
    request.status = 'accepted';
  }
}

final rideService = RideService();
