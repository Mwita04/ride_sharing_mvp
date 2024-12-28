import 'package:flutter/material.dart';
import '../services/ride_service.dart';

class RequestRidePage extends StatefulWidget {
  const RequestRidePage({super.key});

  @override
  State<RequestRidePage> createState() => _RequestRidePageState();
}

class _RequestRidePageState extends State<RequestRidePage> {
  final _formKey = GlobalKey<FormState>();
  final _pickupController = TextEditingController();
  final _dropoffController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request a Ride')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _pickupController,
                decoration: const InputDecoration(labelText: 'Pickup Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a pickup location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dropoffController,
                decoration:
                    const InputDecoration(labelText: 'Dropoff Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a dropoff location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _requestRide,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Request Ride'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _requestRide() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final rideRequest = await rideService.createRideRequest(
          _pickupController.text,
          _dropoffController.text,
        );

        if (!mounted) return;

        Navigator.of(context).pop(rideRequest);
      } catch (e) {
        if (!mounted) return;

        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }
}
