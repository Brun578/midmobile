import 'package:flutter/material.dart';
import 'package:light_level_sensing/Components/color.dart';
import 'package:light_level_sensing/Onboboarding/onboarding_items.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:light_level_sensing/pages/home_page.dart';

class OnboardingView extends StatefulWidget {


  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final controller = OnboardingItems();
  final pageController = PageController();

  bool isLastPage = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomSheet: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
        child: isLastPage ? getStarted() : Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: PageView.builder(
          onPageChanged: (index) => setState(() => isLastPage = controller.items.length - 1 == index),
          itemCount: controller.items.length,
          controller: pageController,
          itemBuilder: (context, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Make image long and stretch across the width
                Container(
                  width: double.infinity,
                  height: 350, // Adjust the height as needed
                  child: Image.asset(
                    controller.items[index].image,
                    fit: BoxFit.cover, // This will ensure the image covers the container
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  controller.items[index].title,
                  style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.orange),
                ),
                const SizedBox(height: 10),
                Text(
                  controller.items[index].descriptions,
                  style: const TextStyle(color: Colors.grey, fontSize: 17),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget getStarted() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.orange,
      ),
      width: MediaQuery.of(context).size.width * .9,
      height: 50,
      child: TextButton(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setBool("onboarding", true);

          if (!mounted) return;
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        },
        child: const Text(
          "Get started",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
