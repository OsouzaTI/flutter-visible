import 'package:flutter/material.dart';
import 'package:yamete_winx/core/AppColors.dart';

class ButtomWidget extends StatelessWidget {
  final String title;
  final Function onClick;
  const ButtomWidget({Key key, this.title, this.onClick}) : super(key: key);

  IconData getIcon(){
    switch (title) {
      case "favorite": return Icons.star_border;break;
      case "shared":  return Icons.share_rounded;break;
      case "read": return Icons.menu_book_outlined;break;
      case "chapters": return Icons.library_books_outlined;break;
      default: return Icons.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(      
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(          
          borderRadius: BorderRadius.circular(50)
        ),
        // child: Text(title, style: AppTextStyles.font20,),
        child: Icon(getIcon(), color: AppColors.iconColor,),
      ),
    );
  }
}