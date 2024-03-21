
import 'package:flutter/material.dart';
import 'package:news/models/show_category.dart';
import 'package:news/pages/article_view.dart';

// ignore: must_be_immutable
class ArticlSearchWidget extends StatefulWidget {
  ShowCategoryModel article;

  ArticlSearchWidget({required this.article, Key? key}) : super(key: key);

  @override
  State<ArticlSearchWidget> createState() => _ArticlSearchWidgetState();
}

class _ArticlSearchWidgetState extends State<ArticlSearchWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) =>
        //             ArticleView(blogUrl: article?.url ?? "")));

        Navigator.of(context).push(customPageRoute(ArticleView(blogUrl: widget.article.url ?? "")));


      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 12, left: 10, right: 10),
        padding: const EdgeInsets.all(12),
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
                  margin: const EdgeInsets.only(right: 6),
                  height: 16,
                  width: 3,
                  color: Colors.pink,
                ),
                Flexible(
                    flex: 1,
                    child: Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      widget.article.description.toString(),
                      style: const TextStyle(color: Colors.grey),
                    )),
              ],
            ),
            Row(
              children: [
                Flexible(
                  flex: 4,
                  // ignore: avoid_unnecessary_containers
                  child: Container(
                    child: Text(
                      widget.article.title ?? "",
                      maxLines: 3,
                      style:
                      // ignore: prefer_const_constructors
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
                              image: NetworkImage(widget.article.urlToImage ?? ""),
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