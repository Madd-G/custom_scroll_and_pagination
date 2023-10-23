import 'package:flutter/material.dart';

class LocationEmailWidget extends StatelessWidget {
  const LocationEmailWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/icons/location.png',
          width: 6.0,
          height: 8.0,
        ),
        const SizedBox(
          width: 10.0,
        ),
        const Text(
          'Jakarta',
          style: TextStyle(
              fontSize: 11.0,
              fontWeight: FontWeight.w400,
              color: Color(0xFF969696)),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Image.asset('assets/icons/email.png'),
        const SizedBox(
          width: 10.0,
        ),
        const Text(
          'alamsyah@gmail.com',
          style: TextStyle(
            fontSize: 11.0,
            fontWeight: FontWeight.w400,
            color: Color(0xFF969696),
          ),
        ),
      ],
    );
  }
}
