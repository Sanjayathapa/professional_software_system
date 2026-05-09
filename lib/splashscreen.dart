

import 'package:flutter/material.dart';
import 'package:principles_ss/provider/api/announcementprovider.dart';
import 'package:principles_ss/view/authscreen/loginscreen.dart';
import 'package:provider/provider.dart';




class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin(); 
      WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider =
          Provider.of<AnnouncementProvider>(context, listen: false);
      await provider.initNotifications();
      await provider.fetchNotifications();
    });
  }
 
    void _navigateToLogin() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        
            Image.asset('assets/images/logo.png'),
            
            const SizedBox(height: 24),
           
            Text(
              'CDU',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Stay connected with CDU',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 48),
         
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

