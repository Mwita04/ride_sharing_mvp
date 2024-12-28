import 'package:flutter/material.dart';
import '../models/ride_request.dart';
import '../services/auth_service.dart';
import 'sign_in_page.dart';
import 'request_ride_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RideRequest? _currentRideRequest;

  @override
  Widget build(BuildContext context) {
    final user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Sharing MVP'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await authService.signOut();
              if (!mounted) return;
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const SignInPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, ${user?.name ?? "User"}!'),
            const SizedBox(height: 16),
            if (_currentRideRequest == null)
              ElevatedButton(
                onPressed: _requestRide,
                child: const Text('Request a Ride'),
              )
            else
              Column(
                children: [
                  Text('Ride Status: ${_currentRideRequest!.status}'),
                  Text('Pickup: ${_currentRideRequest!.pickup}'),
                  Text('Dropoff: ${_currentRideRequest!.dropoff}'),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestRide() async {
    final result = await Navigator.of(context).push<RideRequest>(
      MaterialPageRoute(builder: (_) => const RequestRidePage()),
    );

    if (result != null) {
      setState(() {
        _currentRideRequest = result;
      });
    }
  }
}
