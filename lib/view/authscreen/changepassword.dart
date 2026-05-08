import 'package:ciheapp/provider/password_provider.dart';
import 'package:ciheapp/service/api/loginservice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Change Password",
         
        ),
        
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
            
              // Image.asset(
              //   'assets/images/change.png',
              //   fit: BoxFit.cover,
              //   height: screenHeight * 0.25,
              // ),
              // const SizedBox(height: 20),

             
          
              const SizedBox(height: 30),

           
              _buildLabel("Old Password"),
              Consumer<PasswordVisibilitysProvider>(
                builder: (context, provider, _) {
                  return _buildPasswordField(
                    controller: currentPasswordController,
                    isObscured: provider.isPasswordObscured,
                    toggleVisibility: provider.toggleOldPasswordVisibility,
                    hintText: "Old Password",
                  );
                },
              ),

              const SizedBox(height: 20),

             
              _buildLabel("New Password"),
              Consumer<PasswordVisibilitysProvider>(
                builder: (context, provider, _) {
                  return _buildPasswordField(
                    controller: newPasswordController,
                    isObscured: provider.isNewPasswordObscured,
                    toggleVisibility: provider.toggleNewPasswordVisibility,
                    hintText: "New Password",
                  );
                },
              ),

              const SizedBox(height: 20),

             
              _buildLabel("Confirm Password"),
              Consumer<PasswordVisibilityyProvider>(
                builder: (context, provider, _) {
                  return _buildPasswordField(
                    controller: confirmPasswordController,
                    isObscured: provider.isConfirmPasswordObscured,
                    toggleVisibility: provider.toggleConfirmPasswordVisibility,
                    hintText: "Confirm New Password",
                  );
                },
              ),

              const SizedBox(height: 40),

           
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await _changeUserPassword(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                         
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Submit",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const TextSpan(
              text: ' *',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool isObscured,
    required VoidCallback toggleVisibility,
    required String hintText,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscured,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        hintText: hintText,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(isObscured ? Icons.visibility : Icons.visibility_off),
          onPressed: toggleVisibility,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return' please enter your password';
        }
        if (controller == newPasswordController && value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        if (controller == confirmPasswordController &&
            value != newPasswordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }


  Future<void> _changeUserPassword(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    UserService userService = UserService();
    final success = await userService.changePassword(
      currentPasswordController.text.trim(),
      newPasswordController.text.trim(),
      confirmPasswordController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (success) {
      _clearFields();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password changed successfully'),
          backgroundColor: Color.fromARGB(255, 1, 126, 5),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(userService.errorMessage.isNotEmpty
              ? userService.errorMessage
              : 'Failed to change password'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  void _clearFields() {
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }
}
