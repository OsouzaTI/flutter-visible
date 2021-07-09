import 'package:flutter/material.dart';
import 'package:payflow/core/AppColors.dart';
import 'package:payflow/core/AppImages.dart';
import 'package:payflow/core/AppTextStyles.dart';
import 'package:payflow/shared/button/login_social.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(             
        children: [
          Container(
            width: size.width,
            color: AppColors.primary,
            height: size.height * 0.3,
          ),              
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(AppImages.person),
              Image.asset(AppImages.logomini),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                child: Text("Organize seus boletos em um só lugar", 
                  style: AppTextStyles.titleHome,
                  textAlign: TextAlign.center,
                ),
              ),
              SocialMediaButton()
            ],
          )
        ],
      ),
    );
  }
}