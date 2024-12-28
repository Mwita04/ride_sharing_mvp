import 'package:flutter/material.dart';
import '../models/ride_request.dart';
import '../services/ride_service.dart';
import '../services/auth_service.dart';

class DriverPage extends StatefulWidget {
  const DriverPage({super.key});

  @override
  State<DriverPage> createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
  List<RideRequest> _pendingRequests = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPendingRequests();
  }

  Future<void> _loadPendingRequests() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final requests = rideService.getPendingRideRequests();
      if (mounted) {
        setState(() {
          _pendingRequests = requests;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading requests: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Rides'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPendingRequests,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pendingRequests.isEmpty
              ? const Center(child: Text('No pending ride requests'))
              : ListView.builder(
                  itemCount: _pendingRequests.length,
                  itemBuilder: (context, index) {
                    final request = _pendingRequests[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text('${request.pickup} to ${request.dropoff}'),
                        subtitle: Text('Rider: ${request.rider.name}'),
                        trailing: ElevatedButton(
                          onPressed: () => _acceptRide(request),
                          child: const Text('Accept'),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Future<void> _acceptRide(RideRequest request) async {
    final driver = authService.currentUser;
    if (driver == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to accept rides')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await rideService.acceptRideRequest(request, driver);
      await _loadPendingRequests();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ride accepted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error accepting ride: ${e.toString()}')),
        );
      }
    }
  }
}
