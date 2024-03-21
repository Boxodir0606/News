import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:news/models/show_category.dart';
import 'package:news/pages/widget/article_search_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<ShowCategoryModel> categories = [];
  List<String> errorList = [];
  TextEditingController text = TextEditingController();

  // TextEditing Controller
  TextEditingController _textEditingController = TextEditingController();

  Future<void> getCategoriesNews(String query) async {
    String url =
        "https://newsapi.org/v2/everything?q=$query&apiKey=c157803b8337424bb8e57c5cfbf63b58";

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      if (jsonData['status'] == 'ok') {
        setState(() {
          categories.clear();
          jsonData["articles"].forEach((element) {
            if (element["urlToImage"] != null &&
                element['description'] != null) {
              ShowCategoryModel categoryModel = ShowCategoryModel(
                title: element["title"],
                description: element["description"],
                url: element["url"],
                urlToImage: element["urlToImage"],
                content: element["content"],
                author: element["author"],
              );
              categories.add(categoryModel);
            }
          });
        });
      }
    } else {
      // Handle errors if needed
      print("Error: ${response.statusCode}");
      return errorList.add(response.statusCode.toString());
    }
  }

  bool isLoad = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black12
                      : Colors.black54,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 20),
                    Image.asset(
                      "assets/search_image.png",
                      height: 20,
                      width: 20,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.white
                          : Colors.white54,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _textEditingController, // TextEditing Controller
                        decoration: InputDecoration(
                          hintText: "Search...",
                          border: InputBorder.none,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _textEditingController.clear();
                                categories.clear();
                              });
                            },
                            child: Icon(Icons.close,
                                color: Theme.of(context).brightness ==
                                    Brightness.light
                                    ? Colors.black54
                                    : Colors.white54),
                          ),
                        ),
                        onSubmitted: (query) {
                          getCategoriesNews(query);
                        },
                        // onChanged: (query) {
                        //   getCategoriesNews(query);
                        // },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: categories.isEmpty
                  ? Center(
                child: Icon(
                  Icons.search,
                  size: 100,
                  color: Colors.grey,
                ),
              )
                  : ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return ArticlSearchWidget(article: categories[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
