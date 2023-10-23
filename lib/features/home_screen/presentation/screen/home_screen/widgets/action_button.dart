import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      width: 60.0,
      child: FittedBox(
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: const Color(0xFFE71D35),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
