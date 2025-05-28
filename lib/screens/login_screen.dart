import 'package:flutter/material.dart';
import 'package:exe202_mobile_app/widgets/login_screen_widgets/login_screen_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/LoginBGPicture.png'),
                // Add background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay with form
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 80),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      // adjust the radius as you like
                      child: Image.asset(
                        'assets/logo.png',
                        height: 70,
                        fit: BoxFit
                            .cover, // Optional: make sure image fills rounded area
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'App Chảo',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Your Personal Kitchen Companion',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
                const Spacer(flex: 1),
                Column(
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 22),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Tabs (Login / Sign Up)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    // TODO: Navigate to login screen or switch tab
                                    setState(() {
                                      isLogin = true;
                                    });
                                  },
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      color: isLogin
                                          ? Colors.orange
                                          : Colors.grey,
                                      fontWeight: isLogin
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                // This pushes the next widgets to the end
                                const Text("Don't have an account?"),
                                TextButton(
                                  onPressed: () {
                                    // TODO: Navigate to sign up screen or switch tab
                                    setState(() {
                                      isLogin = false;
                                    });
                                  },
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      color: !isLogin
                                          ? Colors.orange
                                          : Colors.grey,
                                      fontWeight: isLogin
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            isLogin ? LoginForm() : SignInForm(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
