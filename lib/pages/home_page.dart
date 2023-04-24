import 'package:flutter/material.dart';
import 'package:newsgig/utilities/constants.dart';
import 'package:newsgig/providers/theme_provider.dart';
import 'package:newsgig/widgets/home_page_body.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // Change tabs name or add tabs according to you
  static List<Tab> tabs = <Tab>[
    Tab(child: Text("Home".toUpperCase())),
    Tab(child: Text("News".toUpperCase())),
    Tab(child: Text("2023 Elections".toUpperCase())),
    Tab(child: Text("Politics".toUpperCase())),
    Tab(child: Text("Metro".toUpperCase())),
    Tab(child: Text("Business".toUpperCase())),
    Tab(child: Text("Sports".toUpperCase())),
    Tab(child: Text("Editorial".toUpperCase())),
    Tab(child: Text("Columns".toUpperCase())),
    Tab(child: Text("Allure".toUpperCase())),
  ];

  // Give id number according to your category id number
  // Check categories from this url yourWebsiteUrl/wp-json/wp/v2/categories
  final List<Widget> newsCard = const [
    NewsCard(id: 14072),
    NewsCard(id: 6),
    NewsCard(id: 952407),
    NewsCard(id: 12),
    NewsCard(id: 37),
    NewsCard(id: 11),
    NewsCard(id: 13),
    NewsCard(id: 16),
    NewsCard(id: 39),
    NewsCard(id: 6726),
  ];

  //Features - 14072
  // Top Stories - 30762
  // Latest - 8498

  @override
  Widget build(BuildContext context) {
    // final isDarkTheme = Provider.of<ThemeProvider>(context).darkTheme;
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            color: kSecondaryColor,
            child: TabBar(
              tabs: tabs,
              isScrollable: true,
              indicatorColor: kContentColorLightTheme,
              indicatorPadding: const EdgeInsets.only(top: 45),
            ),
          ),
        ),
        body: TabBarView(children: newsCard),
      ),
    );
  }
}
