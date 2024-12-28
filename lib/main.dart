import 'package:flutter/material.dart';
import 'pages/sign_in_page.dart';
import 'pages/home_page.dart';
import 'pages/driver_page.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const RideSharingApp());
}

class RideSharingApp extends StatelessWidget {
  const RideSharingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ride Sharing MVP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    final user = authService.currentUser;

    if (user == null) {
      return const SignInPage();
    }

    return Scaffold(
      body: user.isDriver ? const DriverPage() : const HomePage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Rider',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.drive_eta),
            label: 'Driver',
          ),
        ],
        currentIndex: user.isDriver ? 1 : 0,
        onTap: (index) {
          setState(() {
            if (index == 0 && user.isDriver) {
              authService.currentUser?.isDriver = false;
            } else if (index == 1 && !user.isDriver) {
              authService.currentUser?.isDriver = true;
            }
          });
        },
      ),
    );
  }
}
