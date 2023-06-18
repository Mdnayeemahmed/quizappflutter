import 'package:flutter/material.dart';

import '../utilities/app_colors.dart';

class common_container extends StatelessWidget {
  const common_container({
    super.key, required this.tittle, required this.onTap,
  });
  final String tittle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8)
        ),child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            tittle,textAlign: TextAlign.center,
          ),
        ),
      ),
      ),
    );
  }
}
