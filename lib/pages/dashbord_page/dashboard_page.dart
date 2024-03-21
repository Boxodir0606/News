import 'package:flutter/material.dart';
import 'package:news/pages/category_page/category_page.dart';
import 'package:news/pages/search/search.dart';
import 'package:news/pages/settings/settings.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../home/home.dart';

class DashboardPage extends StatefulWidget {
  final int currentPage;

  const DashboardPage({super.key, required this.currentPage});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final PageStorageBucket bucket = PageStorageBucket();
  int currentTab = 0;
  Widget currentScreen = const Home();

  final List<Widget> screens = [
    const Home(),
    const CategoryPage(),
    const SearchPage(),
    const SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(bucket: bucket, child: currentScreen),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: currentTab,
        onTap: (index) {
          setState(() {
            currentScreen = screens[index];
            currentTab = index;
          });
        },

        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.home_rounded,

             color: Theme.of(context).brightness == Brightness.light
                ? Colors.red
                : Colors.red,),
            title: Text("Home"),
            selectedColor:  Theme.of(context).brightness == Brightness.light
        ? Colors.red
        : Colors.red,
            // <-- Title (yangi qo'shilgan qism)
          ),

          SalomonBottomBarItem(
            icon: Image.asset("assets/category.png",color: Color(0xffDEA600FF), height: 20, width: 20),
            title: Text('Category'),
            selectedColor:  Theme.of(context).brightness == Brightness.light
                ? Color(0xffDEA600FF)
                : Color(0xffDEA600FF),
            // <-- Title (yangi qo'shilgan qism)
          ),

          SalomonBottomBarItem(
            icon: Icon(Icons.search,color:Colors.green),
            title: Text("Search"), // <-- Title (yangi qo'shilgan qism)
            selectedColor:  Theme.of(context).brightness == Brightness.light
                ? Colors.green
                : Colors.green,
          ),

          SalomonBottomBarItem(
            icon: Icon(Icons.settings,color:Colors.pinkAccent),
            title: Text('Settings'), // <-- Title (yangi qo'shilgan qism)
            selectedColor:  Theme.of(context).brightness == Brightness.light
                ? Colors.pinkAccent
                : Colors.pinkAccent,
          ),

        ],
      ),
    );
  }
}
