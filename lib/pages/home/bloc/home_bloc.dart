import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:news/di/app_di.dart';
import 'package:news/models/article_model.dart';
import 'package:news/models/category_model.dart';
import 'package:news/models/slider_model.dart';
import 'package:news/reposetory/apprepository.dart';
import 'package:news/services/slider_data.dart';
import 'package:news/utilse/status.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState()) {

    final repo = getIt<AppRepository>();
    final List<String> list = [];
    on<HomeInitEvent>((event, emit)async{
      emit(state.copyWith(status: Status.LOADING));


      try{
        final response = await repo.getAllNews();
        

        print("----------------------");
      print(response.length);


        emit(state.copyWith(status: Status.SUCCESS,slider: list,list: response));

      }catch(e){
        emit(state.copyWith(status: Status.ERROR));
        
      }
    });
  }
}
