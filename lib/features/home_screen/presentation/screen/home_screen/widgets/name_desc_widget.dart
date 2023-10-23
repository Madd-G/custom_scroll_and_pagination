import 'package:flutter/material.dart';

class NameDescWidget extends StatelessWidget {
  const NameDescWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Alamsyah',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Image.asset(
              'assets/images/green.png',
              width: 16.0,
              height: 16.0,
            )
          ],
        ),
        const Text(
          'Mobile developer',
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF969696),
          ),
        ),
      ],
    );
  }
}
