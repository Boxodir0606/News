import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news/models/slider_model.dart';

class Sliders {
  List<sliderModel> sliders = [];

  Future<List<sliderModel>> getSlider() async {
    String url =
        "https://newsapi.org/v2/everything?domains=wsj.com&apiKey=c157803b8337424bb8e57c5cfbf63b58";
    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      jsonData["articles"].forEach((element) {
        if (element["urlToImage"] != null && element['description'] != null) {
          sliderModel slidermodel = sliderModel(
            title: element["title"],
            description: element["description"],
            url: element["url"],
            urlToImage: element["urlToImage"],
            content: element["content"],
            author: element["author"],
          );
          sliders.add(slidermodel);
        }
      });
    }
    return sliders;
  }
}
