import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'welcome.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    // API endpoint for user authentication you can add your api link
    String apiUrl = 'https://api.escuelajs.co/api/v1/auth/login';

    try {
      // Make a POST request to the API
      var response = await http.post(Uri.parse(apiUrl), body: {
        'email': email,
        'password': password,
      });

      // Parse the response
      var data = json.decode(response.body);

      // Check if the login was successful
      //ScaffoldMessenger.of(context)
      // .showSnackBar(SnackBar(content: Text("$data")));
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Navigate to the welcome page if login successful
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WelcomeScreen()),
        );
      } else {
        // Show error message if login failed
        setState(() {
          _errorMessage = data['message'];
        });
      }
    } catch (error) {
      // Handle network or server errors
      print('Error: $error');

      //ScaffoldMessenger.of(context)
      //.showSnackBar(SnackBar(content: Text("$error")));
      setState(() {
        _errorMessage = 'An error occurred. Please try again later.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.eco_rounded,
                  color: Colors.purple,
                  size: 100,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            TypewriterAnimatedTextKit(
              text: ['Secure Login'],
              textStyle: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: () {
                // Perform login logic here
                _login();
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              _errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
