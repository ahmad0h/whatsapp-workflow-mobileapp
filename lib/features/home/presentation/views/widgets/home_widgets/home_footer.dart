import 'package:flutter/material.dart';

class HomeFooter extends StatelessWidget {
  final double horizontalPadding;

  const HomeFooter({super.key, required this.horizontalPadding});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        vertical: 16,
        horizontal: horizontalPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Powered By ',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: screenWidth > 1200 ? 14 : 12,
            ),
          ),
          Image.asset(
            'assets/footer-logo.png',
            height: screenWidth > 1200 ? 20 : 16,
          ),
        ],
      ),
    );
  }
}
