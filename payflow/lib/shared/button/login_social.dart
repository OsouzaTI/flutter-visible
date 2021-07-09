import 'package:flutter/material.dart';
import 'package:payflow/core/AppColors.dart';
import 'package:payflow/core/AppImages.dart';
import 'package:payflow/core/AppTextStyles.dart';

class SocialMediaButton extends StatelessWidget {
  const SocialMediaButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.stroke,
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 1,
            child: Image.asset(AppImages.google)
          ),
          Container(
            color: AppColors.grey,
            height: 56,
            width: 1,
          ),
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Entrar com Google",
                  style: AppTextStyles.buttonBoldGray,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}