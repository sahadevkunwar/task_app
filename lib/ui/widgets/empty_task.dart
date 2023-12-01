import 'package:flutter/material.dart';

class EmptyTask extends StatelessWidget {
  const EmptyTask({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/empty_cart.png',
              height: 200,
              width: MediaQuery.of(context).size.width - 100,
            ),
            const SizedBox(height: 16),
            const Text(
              'No tasks',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}