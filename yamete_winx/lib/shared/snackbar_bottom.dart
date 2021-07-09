import 'package:flutter/material.dart';
import 'package:yamete_winx/core/AppTextStyles.dart';

class SnackBarWidget extends StatelessWidget {
  final String title;
  final String message;
  final Color  color;
  final IconData icon;
  const SnackBarWidget({
    Key key,
    this.title,
    this.message,
    this.color,
    this.icon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: color,
        padding: const EdgeInsets.only(left: 10),
        child: ListTile(
          leading: Icon(this.icon,
            color: AppTextStyles.snackBarColorIcon,
            size: 32,
          ),
          title: Text(title, style: AppTextStyles.snackBarTitle,),
          subtitle: Text(message, style: AppTextStyles.snackBarMessage,),
        )
      ),
    );
  }
}

class MessageTileWidget extends StatelessWidget {
  final String title;
  final String message;
  const MessageTileWidget({
    Key key,
    this.title,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.snackBarTitle,),
          Text(message, style: AppTextStyles.snackBarMessage,), 
        ],
      ),
    );
  }
}