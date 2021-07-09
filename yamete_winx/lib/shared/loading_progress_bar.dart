import 'package:flutter/material.dart';
import 'package:yamete_winx/core/AppColors.dart';
import 'package:yamete_winx/core/AppGradients.dart';

class LoadingCircularProgressBarWidget extends StatelessWidget {
  const LoadingCircularProgressBarWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppGradients.linear02
      ),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.iconColor),
        ),
      ),
    );
  }
}