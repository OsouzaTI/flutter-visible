import 'package:flutter/material.dart';
import 'package:nlw_flutter/core/app_text_styles.dart';
import 'package:nlw_flutter/shared/widgets/progress_indicator/progress_indicator_widget.dart';

class QuestionIndicatorWidget extends StatelessWidget {
  const QuestionIndicatorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
             Text("Questão 04", style: AppTextStyles.body,),
             Text(" de 10",  style: AppTextStyles.body),
            ],
          ),
          SizedBox(height: 16,),
          ProgressIndicatorWidget(value: 0.3,)
        ],
      ),
    );
  }
}