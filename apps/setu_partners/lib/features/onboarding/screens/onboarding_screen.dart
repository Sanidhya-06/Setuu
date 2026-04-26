import 'package:flutter/material.dart';
import 'onboarding_page1.dart';
import 'onboarding_page2.dart';
import 'onboarding_page3.dart';
import '../widgets/next_button.dart';
import '../widgets/progress_indicator.dart';
import '../onboarding_controller.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final OnboardingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = OnboardingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Column(
              children: [
                // ── Top Bar ────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      // Logo
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: Color(0xFF5A4EFF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.volunteer_activism,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'SETU',
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1C1C1C),
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Page counter
                      Text(
                        '${_controller.currentPage + 1}/${_controller.totalPages}',
                        style: const TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF6B6B6B),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Page Content ───────────────────────────────────────────
                Expanded(
                  child: PageView(
                    controller: _controller.pageController,
                    onPageChanged: _controller.onPageChanged,
                    physics: const ClampingScrollPhysics(),
                    children: [
                      SingleChildScrollView(
                        child: OnboardingPage1(controller: _controller),
                      ),
                      SingleChildScrollView(
                        child: OnboardingPage2(controller: _controller),
                      ),
                      const SingleChildScrollView(
                        child: OnboardingPage3(),
                      ),
                    ],
                  ),
                ),

                // ── Bottom Bar ─────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                  child: Column(
                    children: [
                      NextButton(
                        label: _controller.currentPage == 2
                            ? "Let's Go!"
                            : 'Next',
                        onPressed: _controller.currentPage == 2
                            ? () => _controller.finish(context)
                            : _controller.nextPage,
                      ),
                      const SizedBox(height: 16),
                      OnboardingProgressIndicator(
                        currentPage: _controller.currentPage,
                        totalPages: _controller.totalPages,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}