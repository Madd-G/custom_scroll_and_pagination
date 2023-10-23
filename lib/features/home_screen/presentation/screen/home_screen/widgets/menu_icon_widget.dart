import 'package:flutter/material.dart';

class MenuIconWidget extends StatelessWidget {
  const MenuIconWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/button.png',
      width: 20.0,
      height: 16.5,
    );
  }
}
