import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:news/reposetory/apprepository.dart';
import 'package:news/reposetory/impl/apprepositoryimpl.dart';


final getIt = GetIt.instance;

final dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
    contentType: 'application/json',
    receiveDataWhenStatusError: true));

Future<void> setUp() async {
  getIt.registerSingleton<AppRepository>(AppRepositoryImpl());
}