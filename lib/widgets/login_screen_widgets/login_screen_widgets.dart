import 'package:flutter/material.dart';
import 'package:exe202_mobile_app/api/login_screen_api.dart';
import 'package:exe202_mobile_app/models/DTOs/error_message_reponse.dart';
import 'package:exe202_mobile_app/models/DTOs/customer_login_response.dart';

// Login form UI:
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginScreenService _loginScreenService = LoginScreenService();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        // Email
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.email_outlined),
            hintText: 'Enter your email',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        // Password
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
              ),
            ),
            hintText: 'Enter your password',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 8),
        // Remember me and Forgot password
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (bool? value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                ),
                const Text("Remember me"),
              ],
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                "Forgot Password?",
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Login button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              final email = _emailController.text.trim();
              final password = _passwordController.text;

              if (email.isEmpty || password.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Please fill in both email and password"),
                  ),
                );
                return;
              }

              try {
                final result = await _loginScreenService.login(
                  email,
                  password,
                  _rememberMe,
                );

                if (result is CustomerLoginResponse) {
                  // Success logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Welcome, ${result.Role}")),
                  );

                  // Example: Navigate to home page
                  // Navigator.pushReplacementNamed(context, '/home');
                } else if (result is ErrorMessageResponse) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(result.Message)));
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("An error occurred: $e")),
                );
              }
            },
            child: const Text("Log In", style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(height: 16),
        const Text("Or continue with"),
        const SizedBox(height: 12),
        // Social icons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () async {
                try {
                  final result = await _loginScreenService.signInWithGoogle();

                  if (result is CustomerLoginResponse) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Welcome, ${result.Role}")),
                    );
                  } else if (result is ErrorMessageResponse) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(result.Error)));
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("An error occurred: $e")),
                  );
                }
              },
              icon: const Icon(Icons.g_mobiledata, size: 32),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Sign in form UI:
class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  @override
  Widget build(BuildContext context) {
    return Column();
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
