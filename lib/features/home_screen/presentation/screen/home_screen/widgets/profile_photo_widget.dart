import 'package:flutter/material.dart';

class ProfilePhotoWidget extends StatelessWidget {
  const ProfilePhotoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/Profile.png',
      height: 40.0,
      width: 40.0,
    );
  }
}
