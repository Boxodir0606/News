import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/models/article_model.dart';
import 'package:news/pages/article_view.dart';
import 'package:url_launcher/url_launcher.dart';

class articleShortFormWidet extends StatelessWidget {
  ArticleModel? article;

  articleShortFormWidet({required this.article, Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) =>
        //             ArticleView(blogUrl: article?.url ?? "")));

        Navigator.of(context).push(customPageRoute(ArticleView(blogUrl: article?.url ?? "")));


      },

      child: Container(
        margin: EdgeInsets.only(bottom: 12, left: 10, right: 10),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(10)),
        height: 150,
        width: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 6),
                  height: 16,
                  width: 3,
                  color: Colors.pink,
                ),
                Flexible(
                    flex: 1,
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      article?.description.toString() ?? "",
                      style: TextStyle(color: Colors.grey),
                    )),
              ],
            ),
            Row(
              children: [
                Flexible(
                  flex: 4,
                  child: Container(
                    child: Text(
                      article?.title ?? "",
                      maxLines: 3,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: NetworkImage(article?.urlToImage ?? ""),
                              fit: BoxFit.cover)),
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Route customPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.linear;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

}
