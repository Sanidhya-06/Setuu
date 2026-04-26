import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../routes/app_routes.dart'; // ✅ important

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // 🖼 Background Image
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              "assets/images/welcome.jpeg",
              fit: BoxFit.cover,
            ),
          ),

          // 🌫 Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.85),
                  Colors.white.withOpacity(0.55),
                  Colors.transparent,
                  Colors.white.withOpacity(0.6),
                ],
                stops: const [0.0, 0.25, 0.55, 1.0],
              ),
            ),
          ),

          // 📄 Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // 🟣 Logo
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.volunteer_activism,
                      color: AppTheme.primaryColor,
                      size: 36,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // 📝 Title
                  RichText(
                    text: TextSpan(
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.15,
                      ),
                      children: [
                        const TextSpan(text: "Make a\nDifference\n"),
                        TextSpan(
                          text: "Today",
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 📝 Subtitle
                  Text(
                    "Join thousands of volunteers working together for a better tomorrow.",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),

                  const Spacer(),

                  // 🚀 Get Started Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        elevation: 0,
                      ),
                      // ✅ UPDATED NAVIGATION
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.signup),
                      child: const Text(
                        "Get Started",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 🔗 Login Link
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.black54,
                          ),
                        ),
                        GestureDetector(
                          // ✅ UPDATED NAVIGATION
                          onTap: () =>
                              Navigator.pushNamed(context, AppRoutes.login),
                          child: Text(
                            "Log in",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}