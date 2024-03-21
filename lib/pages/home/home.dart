import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:news/pages/all_news.dart';
import 'package:news/pages/article_view.dart';
import 'package:news/pages/category_news/category_news.dart';
import 'package:news/pages/home/bloc/home_bloc.dart';
import 'package:news/pages/widget/article_short_form_widget.dart';
import 'package:news/pages/widget/article_widget.dart';
import 'package:news/pages/widget/default_article_shimmer.dart';
import 'package:news/utilse/status.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final bloc = HomeBloc();

  int activeIndex = 0;

  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    getConnectivity();
    bloc.add(HomeInitEvent());
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );

  bool isShorts = false;

  Future<void> reflesh() async {
    print("=============================================================");

    print(bloc.state.list?.length);

    bloc.state.list?.clear();
    bloc.state.slider?.clear();
    bloc.state.categoryList?.clear();

    setState(() {});

    bloc.add(HomeInitEvent());
  }

  DateTime now = new DateTime.now();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state.status == Status.LOADING) {
              return Center(
                  child: Scaffold(
                body: Center(
                  child: LoadingAnimationWidget.prograssiveDots(
                    color: Colors.blueAccent,
                    size: 100,
                  ),
                ),
              ));


            } else if (state.status == Status.SUCCESS) {

              return Scaffold(
                  body: Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Text(
                        "News",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Trending News!",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),

                          
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                  customPageRoute(AllNews(news: "Trending")));
                            },
                            child: Text(
                              "View All",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Container(
                        height: 52,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.grey.withOpacity(0.4)),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Bugun,  ",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    "${now.day}.${now.month}.${now.year}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        isShorts = false;
                                        setState(() {});
                                      },
                                      icon: Icon(Icons.splitscreen_rounded)),
                                  IconButton(
                                      onPressed: () {
                                        isShorts = true;
                                        setState(() {});
                                      },
                                      icon: Icon(Icons.menu_open_sharp))
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    

                    const SizedBox(
                      height: 12,
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        child: SmartRefresher(
                          onRefresh: reflesh,
                          controller: _refreshController,
                          header: WaterDropMaterialHeader(
                            backgroundColor: Colors.red,
                          ),
                          child: ListView.builder(
                              itemCount: state.list?.length ?? 0,
                              itemBuilder: (context, index) {
                                // return BlogTile(
                                //     url: state.list?[index].url ?? "",
                                //     desc: state.list?[index].description ??
                                //         "",
                                //     imageUrl:
                                //         state.list?[index].urlToImage ?? "",
                                //     title: state.list?[index].title ?? "",
                                //     isFavorit: false,
                                //     onClick: () {});  

                                return isShorts
                                    ? articleShortFormWidet(
                                        article: state.list![index])
                                    : article_widget(
                                        article: state.list![index]);
                              }),
                        ),
                      ),
                    ),
                  ])));
            } else if (state.status == Status.ERROR) {
              return Center(
                child: Lottie.asset("assets/error_animation.json",
                    height: 150, width: 150),
              );
            } else {
              return Text("");
            }
          }),
    );
  }

  Widget buildImage(String image, int index, String name) => Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      child: Stack(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            height: 250,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            imageUrl: image,
          ),
        ),
        Container(
          height: 250,
          padding: EdgeInsets.only(left: 10.0),
          margin: EdgeInsets.only(top: 170.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          child: Center(
            child: Text(
              name,
              maxLines: 2,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        )
      ]));

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: 5,
        effect: SlideEffect(
            dotWidth: 15, dotHeight: 15, activeDotColor: Colors.blue),
      );

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('No Connection'),
          content: const Text('Please check your internet connectivity'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => isAlertSet = false);
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected && isAlertSet == false) {
                  showDialogBox();
                  setState(() => isAlertSet = true);
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );

  Route customPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.linear;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}

class CategoryTile extends StatelessWidget {
  final image, categoryName;

  CategoryTile({this.categoryName, this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(customPageRoute(CategoryNews(name: categoryName)));
      },
      child: Container(
        margin: EdgeInsets.only(right: 8),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                image,
                width: double.infinity,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black38,
              ),
              child: Center(
                  child: Text(
                categoryName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              )),
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

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}

class BlogTile extends StatefulWidget {
  String imageUrl, title, desc, url;
  bool isFavorit;

  void Function() onClick;

  BlogTile(
      {required this.desc,
      required this.imageUrl,
      required this.title,
      required this.url,
      required this.isFavorit,
      required this.onClick});

  @override
  State<BlogTile> createState() => _BlogTileState();
}

class _BlogTileState extends State<BlogTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ArticleView(blogUrl: widget.url)));
      },
      child: Container(
          margin: EdgeInsets.only(bottom: 10.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Material(
              elevation: 3.0,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: widget.imageUrl,
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ))),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Flexible(
                      flex: 2,
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 1.7,
                            child: Text(
                              widget.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            height: 7.0,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.7,
                            child: Text(
                              widget.desc,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                        onTap: widget.onClick,
                        child: Icon(
                          Icons.favorite,
                          color: widget.isFavorit ? Colors.red : Colors.black,
                        ))
                    // Set the color of the icon
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
