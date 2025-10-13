import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeFooter extends StatelessWidget {
  // final double horizontalPadding;

  const HomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Powered By',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          Image.asset('assets/footer-logo.png', height: 50),
        ],
      ),
    );
  }
}
