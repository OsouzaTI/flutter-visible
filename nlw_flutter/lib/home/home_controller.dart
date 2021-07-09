import 'package:flutter/cupertino.dart';
import 'package:nlw_flutter/core/app_images.dart';
import 'package:nlw_flutter/home/home_state.dart';
import 'package:nlw_flutter/shared/models/awnser_model.dart';
import 'package:nlw_flutter/shared/models/question_model.dart';
import 'package:nlw_flutter/shared/models/quiz_model.dart';
import 'package:nlw_flutter/shared/models/user_model.dart';

class HomeController {
  
  final stateNotifier = ValueNotifier<HomeState>(
    HomeState.empty
  );
  set state(HomeState state) => stateNotifier.value = state;
  HomeState get state => stateNotifier.value;

  UserModel? user;
  List<QuizModel>? quizzes;

  void getUser() async {
    state = HomeState.loading;
    await Future.delayed(Duration(seconds: 2));    
    user = UserModel(
      name: "Ozéias",
      score: 0,
      photoUrl: "https://cdn.discordapp.com/attachments/620091805203038238/834536128270172190/unknown.png",
    );
    state = HomeState.success;
  }

  void getQuizzes() async {
    state = HomeState.loading;
    await Future.delayed(Duration(seconds: 2));
    quizzes = [
      QuizModel(
        title: "NLW 5 flutter",
        imagem: AppImages.blocks,
        questionAnswered: 1,
        level: Level.facil,
        questions: [
          QuestionModel(
            title: "Tudo em flutter é um componente ?",
            awnsers: [
              AwnserModel(title: "Sim", isRight: true),
              AwnserModel(title: "Não"),
              AwnserModel(title: "Não"),
              AwnserModel(title: "Não"),
            ]            
          ),
          QuestionModel(
            title: "Tudo em flutter é um componente ?",
            awnsers: [
              AwnserModel(title: "Sim", isRight: true),
              AwnserModel(title: "Não"),
              AwnserModel(title: "Não"),
              AwnserModel(title: "Não"),
            ]            
          )
        ]
      ),
    ];
    state = HomeState.success;
  }
}