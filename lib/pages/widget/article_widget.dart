import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/models/article_model.dart';
import 'package:news/pages/article_view.dart';
import 'package:url_launcher/url_launcher.dart';

class article_widget extends StatelessWidget {
  ArticleModel article;

  article_widget({required this.article, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(customPageRoute(ArticleView(blogUrl: article.url ?? "")));

      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, left: 10, right: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(10),
        ),
        height: 320,
        width: double.infinity,
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: NetworkImage(article.urlToImage ?? ""),
                      fit: BoxFit.cover)),
            ),
            Container(
              height: 118,
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          article.description.toString(),
                          style: TextStyle(color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                  Text(
                    article.title ?? "",
                    maxLines: 2,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    overflow: TextOverflow.ellipsis,

                  ),
                ],
              ),
            )
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