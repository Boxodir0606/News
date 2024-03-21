part of 'home_bloc.dart';

class HomeState {
  List<ArticleModel>? list;
  Status? status;
  List<String>? slider;

  List<CategoryModel>? categoryList;

  HomeState({this.list, this.status, this.slider, this.categoryList});

  HomeState copyWith(
          {List<ArticleModel>? list,
          Status? status,
          List<String>? slider,
          List<CategoryModel>? categoryList}) =>
      HomeState(
          list: list ?? this.list,
          status: status ?? this.status,
          slider: slider ?? this.slider,
          categoryList: categoryList ?? this.categoryList);
}
