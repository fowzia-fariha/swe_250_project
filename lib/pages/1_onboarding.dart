import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:food_in_flutter/pages/2_signin_signup.dart';

class OnboardingPageData {
  final String animationAsset;
  final String title;
  final String subtitle;

  OnboardingPageData({
    required this.animationAsset,
    required this.title,
    required this.subtitle,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      animationAsset: 'assets/animations/delivery_bike.json',
      title: 'Fast & Fresh',
      subtitle: 'Get your favorite meals delivered in minutes.',
    ),
    OnboardingPageData(
      animationAsset: 'assets/animations/fresh_salad.json',
      title: 'Endless Options',
      subtitle: 'Explore a wide range of cuisines and restaurants.',
    ),
    OnboardingPageData(
      animationAsset: 'assets/animations/craving_crushers.json',
      title: 'Exclusive Deals',
      subtitle: 'Enjoy special discounts and daily offers.',
    ),
  ];

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
  }

  void _goToSignIn() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFF5E1), Color(0xFFFFE0B2)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Lottie animation
                    SizedBox(
                      height: size.height * 0.5,
                      child: Lottie.asset(
                        page.animationAsset,
                        fit: BoxFit.contain,
                        repeat: true,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title
                    Text(
                      page.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: size.width * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[800],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Subtitle below image
                    Text(
                      page.subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: size.width * 0.045,
                        color: Colors.brown[600],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          // Indicator and skip/done
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                        (idx) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: _currentPage == idx ? 24 : 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _currentPage == idx ? Colors.brown : Colors.brown.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: _goToSignIn,
                    child: Text(
                      _currentPage == _pages.length - 1 ? 'Done' : 'Skip',
                      style: TextStyle(
                        color: Colors.brown[800],
                        fontSize: size.width * 0.045,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
