import 'package:news/models/article_model.dart';
import 'package:news/models/show_category.dart';
import 'package:news/models/slider_model.dart';

abstract class AppRepository {

  Future<List<sliderModel>>getSlider();

  Future<List<ArticleModel>> getAllNews();

}