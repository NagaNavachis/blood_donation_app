import 'package:blood_donation/screens/base_url.dart';
import 'package:blood_donation/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewPassword extends StatefulWidget {
  String mobileNo;
  NewPassword({Key? key, required this.mobileNo}) : super(key: key);

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
    bool _passwordObscureText = true;

  
  Future<void> resetPassword(String mobileNo, String newPassword) async {
    final Uri apiUrl = Uri.parse(base_url + 'newPassword');

    try {
      final http.Response response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'mobileNo': mobileNo,
          'password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        // Password reset successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password reset successful.Please Login.'),
            backgroundColor: Colors.green,
          ),
          
        );
         Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Login(),
            ),
          );

        // Navigate to the next screen or perform other actions as needed
      } else {
        // Password reset failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password reset failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle any exceptions that may occur during the HTTP request
      print('Error resetting password: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
               TextFormField(
                controller: _newPasswordController,
                obscureText: _passwordObscureText,
                decoration: InputDecoration(
                  hintText: 'Please Enter Your Password',
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _passwordObscureText = !_passwordObscureText;
                      });
                    },
                    child: Icon(
                      _passwordObscureText
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                hintText: 'Confirm new password',
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Confirm password is required';
                } else if (value != _newPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
       ElevatedButton(
  onPressed: () {
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (newPassword.isNotEmpty && confirmPassword.isNotEmpty) {
      if (newPassword == confirmPassword) {
        if (newPassword.length >= 8) {
          resetPassword(widget.mobileNo, newPassword);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('New password must be at least 8 characters.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Passwords do not match.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Both password fields are required.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  },
  child: const Text(
    'Submit',
    style: TextStyle(fontSize: 16.0),
  ),
),


          ],
        ),
      ),
    );
  }
}
