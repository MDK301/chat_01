import 'package:flutter/material.dart';

import '../color.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onPress;
  final Color color, textColor;
  final bool loading ;

  const RoundButton(
      {super.key,
      required this.title,
      required this.onPress,
       this.color=AppColors.primaryColor,
       this.textColor=AppColors.whiteColor,
      this.loading=false,
      });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading ? null : onPress,

      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
            child: loading? CircularProgressIndicator(color: Colors.white,) : Text(
          title,
          style:
              Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16,color: textColor),
        )),
      ),
    );
  }
}
