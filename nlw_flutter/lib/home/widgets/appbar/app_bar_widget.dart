import 'package:flutter/material.dart';
import 'package:nlw_flutter/core/app_gradients.dart';
import 'package:nlw_flutter/core/app_images.dart';
import 'package:nlw_flutter/core/app_text_styles.dart';
import 'package:nlw_flutter/home/widgets/score_card/score_card_widget.dart';
import 'package:nlw_flutter/shared/models/user_model.dart';


class AppBarWidget extends PreferredSize {
  final UserModel user;
  AppBarWidget({required this.user}) : super(
    preferredSize: Size.fromHeight(250),
    child: Container(
      height: 250,
      child: Stack(          
        children: [
          Container(
            height: 161,
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              gradient: AppGradients.linear
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: "Olá ",
                    style: AppTextStyles.title,
                    children: [
                      TextSpan(
                        text: user.name,
                        style: AppTextStyles.titleBold
                      )
                    ]
                  )
                ),
                Container(
                  width: 58,
                  height: 58,            
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(user.photoUrl)
                    ),
                    borderRadius: BorderRadius.circular(10)
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment(0.0, 1.0),
            child: ScoreCard()
          )
        ],
      ),
    )
  );
  


}