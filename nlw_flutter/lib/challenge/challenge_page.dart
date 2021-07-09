import 'package:flutter/material.dart';
import 'package:nlw_flutter/challenge/widgets/question_indicator_widget.dart';
import 'package:nlw_flutter/challenge/widgets/quiz/quiz_widget.dart';

class ChallengePage extends StatefulWidget {
  ChallengePage({Key? key}) : super(key: key);

  @override
  _ChallengePageState createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: SafeArea(
          child: QuestionIndicatorWidget()
        ),
      ),
      body: QuizWidget(title: "Come meu cuzinho"),
    );
  }
}