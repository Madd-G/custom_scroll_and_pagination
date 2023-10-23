import 'package:flutter/material.dart';
import 'widgets.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfilePhotoWidget(),
                  SizedBox(
                    width: 20.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NameDescWidget(),
                      SizedBox(
                        height: 5.0,
                      ),
                      LocationEmailWidget(),
                    ],
                  ),
                ],
              ),
              MenuIconWidget()
            ],
          ),
        ],
      ),
    );
  }

// @override
// double get maxExtent => 100.0;
//
// @override
// double get minExtent => 100.0;
//
// @override
// bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
//   return false;
// }
}
