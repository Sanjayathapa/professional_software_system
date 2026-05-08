import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class TwoFactorScreen extends StatefulWidget {
  const TwoFactorScreen({Key? key}) : super(key: key);

  @override
  State<TwoFactorScreen> createState() => _TwoFactorScreenState();
}

class _TwoFactorScreenState extends State<TwoFactorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _verifyCode() async {
    if (_formKey.currentState!.validate()) {
    
      
    
      
      // if (mounted && success) {
      //   Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (_) => const HomeScreen()),
      //   );
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
   
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Two-Factor Authentication'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.security,
                size: 80,
                color: Colors.grey,
              ),
              const SizedBox(height: 24),
              Text(
                'Verification Required',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Please enter the verification code sent to your email or authentication app.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _codeController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 6,
                      decoration: const InputDecoration(
                        labelText: 'Verification Code',
                        counterText: '',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the verification code';
                        }
                        if (value.length < 6) {
                          return 'Code must be 6 digits';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: (){ _verifyCode();},
                      child: Text('Verify'),
                    ),
                 
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

