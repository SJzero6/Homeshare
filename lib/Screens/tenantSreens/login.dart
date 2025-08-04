import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homeshare/Screens/home.dart';
import 'package:homeshare/services/gmail_auth_service.dart';
import 'package:homeshare/services/phone_auth_service.dart';
import 'package:homeshare/settings/app_routes.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _blobController;
  late AnimationController _cardController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  bool _isSignUp = false;

  @override
  void initState() {
    super.initState();

    _blobController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      _cardController.forward();
    });

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _cardController, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _cardController, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _blobController.dispose();
    _cardController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = Provider.of<OEmailAuthProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          /// 🔵 Blob background
          AnimatedBuilder(
            animation: _blobController,
            builder: (context, _) {
              return CustomPaint(
                painter: BlobPainter(_blobController.value),
                child: Container(),
              );
            },
          ),

          /// 🟢 Login/SignUp UI
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Image.asset('assets/Logo.png', height: 150),
                  const SizedBox(height: 10),

                  /// Card
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.grey[850]
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isSignUp ? "Sign Up" : "Sign In",
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 20),

                            const Text(
                              "Email",
                              style: TextStyle(color: Colors.green),
                            ),
                            const SizedBox(height: 5),
                            _buildTextField(
                              controller: emailController,
                              hintText: "Enter Email",
                              icon: Icons.mail,
                              obscure: false,
                            ),

                            const SizedBox(height: 20),
                            const Text(
                              "Password",
                              style: TextStyle(color: Colors.green),
                            ),
                            const SizedBox(height: 5),
                            _buildTextField(
                              controller: passwordController,
                              hintText: "Enter password",
                              icon: Icons.lock_outline,
                              obscure: true,
                            ),

                            if (_isSignUp) ...[
                              const SizedBox(height: 20),
                              const Text(
                                "Confirm Password",
                                style: TextStyle(color: Colors.green),
                              ),
                              const SizedBox(height: 5),
                              _buildTextField(
                                controller: confirmPasswordController,
                                hintText: "Re-enter password",
                                icon: Icons.lock,
                                obscure: true,
                              ),
                            ],

                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: authProvider.isLoading
                                    ? null
                                    : () async {
                                        final email = emailController.text
                                            .trim();
                                        final password = passwordController.text
                                            .trim();

                                        if (email.isEmpty || password.isEmpty) {
                                          _showError(
                                            "Email and password cannot be empty",
                                          );
                                          return;
                                        }

                                        try {
                                          if (_isSignUp) {
                                            final confirmPassword =
                                                confirmPasswordController.text
                                                    .trim();
                                            await authProvider.signUp(
                                              email,
                                              password,
                                              confirmPassword,
                                            );

                                            // Call dialog separately
                                            _showSignUpSuccessDialog();
                                          } else {
                                            await authProvider.signIn(
                                              email,
                                              password,
                                            );
                                            Navigator.pushReplacementNamed(
                                              context,
                                              AppRoutes.home,
                                            ); // go to home after login
                                          }
                                        } catch (e) {
                                          _showError(e.toString());
                                        }
                                      },

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: authProvider.isLoading
                                    ? CircularProgressIndicator(
                                        color: Colors.green,
                                      )
                                    : Text(
                                        _isSignUp ? "Sign Up" : "Sign In",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  if (!_isSignUp) ...[
                    const SizedBox(height: 20),
                    const Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "OR",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Image.asset('assets/google.png', height: 40),
                          onPressed: () async {
                            try {
                              await Provider.of<GmailAuthProvider>(
                                context,
                                listen: false,
                              ).signInWithGoogle();
                              // Navigate to home screen or show success
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Google Sign-In failed'),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          icon: Image.asset('assets/apple.png', height: 40),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isSignUp
                            ? "Already have an account? "
                            : "Don't have an account? ",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isSignUp = !_isSignUp;
                          });
                        },
                        child: Text(
                          _isSignUp ? "Sign In" : "Sign Up",
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// TextField Builder
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required bool obscure,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.green),
        suffixIcon: obscure
            ? const Icon(Icons.visibility, color: Colors.green)
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.green),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.green, width: 2),
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message.replaceFirst('Exception: ', ''))),
    );
  }

  void _showSignUpSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          "Welcome to HomeShare",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text("Your account has been successfully created."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              setState(() {
                _isSignUp = false; // Switch back to login mode
              });
            },
            child: const Text(
              "Go to Login",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 🎨 BlobPainter (same as yours)
class BlobPainter extends CustomPainter {
  final double progress;
  BlobPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final offset = sin(progress * 2 * pi) * 20;

    final paint1 = Paint()..color = Colors.green.withOpacity(0.3);
    final paint2 = Paint()..color = Colors.greenAccent.withOpacity(0.3);
    final paint3 = Paint()..color = Colors.teal.withOpacity(0.2);
    final paint4 = Paint()..color = Colors.lightGreen.withOpacity(0.2);

    final path1 = Path()
      ..moveTo(0, size.height * 0.8)
      ..cubicTo(
        size.width * 0.25,
        size.height * 0.75 + offset,
        size.width * 0.75,
        size.height * 0.85 - offset,
        size.width,
        size.height * 0.8,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final path2 = Path()
      ..moveTo(0, size.height * 0.9)
      ..cubicTo(
        size.width * 0.3,
        size.height * 0.95 - offset,
        size.width * 0.7,
        size.height * 0.85 + offset,
        size.width,
        size.height * 0.9,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final path3 = Path()
      ..moveTo(0, size.height * 0.85)
      ..cubicTo(
        size.width * 0.2,
        size.height * 0.8 + offset,
        size.width * 0.8,
        size.height * 0.95 - offset,
        size.width,
        size.height * 0.87,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final path4 = Path()
      ..moveTo(0, size.height * 0.88)
      ..cubicTo(
        size.width * 0.1,
        size.height * 0.93 - offset,
        size.width * 0.9,
        size.height * 0.9 + offset,
        size.width,
        size.height * 0.92,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path1, paint1);
    canvas.drawPath(path2, paint2);
    canvas.drawPath(path3, paint3);
    canvas.drawPath(path4, paint4);
  }

  @override
  bool shouldRepaint(covariant BlobPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
