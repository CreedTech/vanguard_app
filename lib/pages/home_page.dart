import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:vanguard/utilities/get_category.dart';
import 'package:provider/provider.dart';
import '../model/post_data.dart';
import '../providers/connectivity_provider.dart';
import '../utilities/config.dart';
import '../utilities/constants.dart';
import '../utilities/wp_api_data_access.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../widgets/home_page_body.dart';
import '../widgets/news_card_skeleton.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  // Change tabs name or add tabs according to you
  static const List<Tab> tabs = <Tab>[
    Tab(
      child: Text(
        "Top Stories",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    ),
    Tab(
        child: Text(
      "News",
      style: TextStyle(
        color: Colors.black,
      ),
    )),
    Tab(
        child: Text(
      "Politics",
      style: TextStyle(
        color: Colors.black,
      ),
    )),
    Tab(
        child: Text(
      "Metro",
      style: TextStyle(
        color: Colors.black,
      ),
    )),
    Tab(
        child: Text(
      "Videos",
      style: TextStyle(
        color: Colors.black,
      ),
    )),
    Tab(
        child: Text(
      "Business",
      style: TextStyle(
        color: Colors.black,
      ),
    )),
    Tab(
        child: Text(
      "Entertainment",
      style: TextStyle(
        color: Colors.black,
      ),
    )),
    Tab(
        child: Text(
      "Technology",
      style: TextStyle(
        color: Colors.black,
      ),
    )),
    Tab(
        child: Text(
      "Editorial",
      style: TextStyle(
        color: Colors.black,
      ),
    )),
    Tab(
        child: Text(
      "Columns",
      style: TextStyle(
        color: Colors.black,
      ),
    )),
    Tab(
        child: Text(
      "Allure",
      style: TextStyle(
        color: Colors.black,
      ),
    )),
    Tab(
        child: Text(
      "Cartoons",
      style: TextStyle(
        color: Colors.black,
      ),
    )),
    Tab(
        child: Text(
      "Health",
      style: TextStyle(
        color: Colors.black,
      ),
    )),
    Tab(
        child: Text(
      "Relationships",
      style: TextStyle(
        color: Colors.black,
      ),
    )),
    Tab(
        child: Text(
      "Education",
      style: TextStyle(
        color: Colors.black,
      ),
    )),
    Tab(
        child: Text(
      "Interviews",
      style: TextStyle(
        color: Colors.black,
      ),
    )),
    Tab(
        child: Text(
      "Special Reports",
      style: TextStyle(
        color: Colors.black,
      ),
    )),
    Tab(
        child: Text(
      "Woman's Own",
      style: TextStyle(
        color: Colors.black,
      ),
    )),
    Tab(
        child: Text(
      "Business",
      style: TextStyle(
        color: Colors.black,
      ),
    )),
  ];

  // Give id number according to your category id number
  // Check categories from this url yourWebsiteUrl/wp-json/wp/v2/categories
  final List<Widget> newsCard = const [
    NewsCard(id: 30762),
    NewsCard(id: 6),
    NewsCard(id: 12),
    NewsCard(id: 37),
    NewsCard(id: 71),
    NewsCard(id: 11),
    NewsCard(id: 13),
    NewsCard(id: 20),
    NewsCard(id: 15),
    NewsCard(id: 16),
    NewsCard(id: 39),
    NewsCard(id: 6726),
    NewsCard(id: 6509),
    NewsCard(id: 19),
    NewsCard(id: 29),
    NewsCard(id: 18),
    NewsCard(id: 44320),
    NewsCard(id: 611),
    NewsCard(id: 43933)
  ];

  final RefreshController refreshController =
      RefreshController(initialRefresh: true); // Change initialRefresh to false
  bool isRefresh = true; // Change isRefresh to false
  List<PostData> posts = [];

  Future<bool> fetchData({bool refresh = true}) async {
    // Simulate data fetching delay
    await Future.delayed(const Duration(seconds: 2));

    // Create an instance of Dio
    final dio = Dio();

    try {
      // Fetch data for each category ID
      for (var i = 0; i < homeCategoryIdList.length;) {
        final categoryId = homeCategoryIdList[i];

        // Make the API request
        final Uri categoryWiseUrls = Uri.parse(
            "https://vanguardngr.com/wp-json/wp/v2/posts?_embed&categories=$categoryId");

        final response = await dio.get(categoryWiseUrls.toString());

        if (response.statusCode == 200) {
          // Check if the response data is null or empty list
          // if (response.data != null && response.data is List) {
          // Parse the response JSON
          final List<dynamic> data = response.data;
          final List<PostData> result = data
              .map((item) => PostData.fromJson(item as Map<String, dynamic>))
              .toList();

          if (refresh) {
            posts = result;
          } else {
            posts.addAll(result);
          }
          if (mounted) {
            setState(() {});
            // currentPage++;
          }

          return true;
          // }
        } else {
          return false;
        }
      }
    } catch (e) {
      // Handle any error that occurred during the API request
      if (kDebugMode) {
        print('Error: $e');
      }
    }

    return true;
  }

  void onRefresh() async {
    fetchData();
    getHomeCategory();
    refreshController.refreshCompleted();
    if (Provider.of<ConnectivityProvider>(context, listen: false).isOnline) {
      if (mounted) {
        setState(() {
          isRefresh = true;
        });
      }

      final result = await fetchData(refresh: true);
      if (result == true) {
        if (mounted) {
          setState(() {
            isRefresh = false;
          });
        }
      } else {
        refreshController.refreshFailed();
      }
    }
  }

  void onLoading() async {
    final result = await fetchData(refresh: true);
    if (result == true) {
      refreshController.loadComplete();
    } else {
      refreshController.loadNoData();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final isDarkTheme = Provider.of<ThemeProvider>(context).darkTheme;
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: TabBar(
            tabs: tabs,
            isScrollable: true,
            // indicatorPadding: EdgeInsets.only(top: 25),
            indicatorColor: kSecondaryColor,
            indicatorWeight: 3.0,
          ),
        ),
        body: TabBarView(children: newsCard),
      ),
    );
    // return SmartRefresher(
    //   controller: refreshController,
    //   enablePullUp: true,
    //   onRefresh: onRefresh,
    //   onLoading: onLoading,
    //   header: const WaterDropHeader(
    //     waterDropColor: kSecondaryColor,
    //   ),
    //   footer: CustomFooter(
    //     builder: (BuildContext context, LoadStatus? mode) {
    //       Widget body;
    //       if (mode == LoadStatus.idle) {
    //         body = const Text("Load more");
    //       } else if (mode == LoadStatus.loading) {
    //         body = const CupertinoActivityIndicator(
    //           color: kSecondaryColor,
    //         );
    //       } else if (mode == LoadStatus.failed) {
    //         body = const Text("Load Failed!Click retry!");
    //       } else if (mode == LoadStatus.canLoading) {
    //         body = const Text("release to load more");
    //       } else {
    //         body = const Text("No more Data");
    //       }
    //       return SizedBox(
    //         height: 55.0,
    //         child: Center(child: body),
    //       );
    //     },
    //   ),
    //   child: isRefresh
    //       ? Stack(
    //           fit: StackFit.expand,
    //           children: [
    //             Center(
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: const [
    //                   Padding(
    //                     padding: EdgeInsets.all(8.0),
    //                     child: Text(
    //                       "Loading Please wait...",
    //                       style: TextStyle(color: kSecondaryColor),
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     width: 200,
    //                     // height: 200,
    //                     child: CupertinoActivityIndicator(
    //                       radius: 20,
    //                       color: kSecondaryColor,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ],
    //         )
    //       : ListView(
    //           children: [
    //             for (var i = 0; i < homeCategoryMap!.length; i++)
    //               _buildSection(homeCategoryNames[i], homeCategoryIdList[i])
    //           ],
    //         ),
    // );
  }

  // Widget _buildSection(String categoryName, int categoryId) {
  //   final screenWidth = MediaQuery.of(context).size.width;
  //   List<PostData> sectionPosts = [];

  //   Future<void> postsByCats() async {
  //     final dio = Dio();
  //     final Uri categoryWiseUrls = Uri.parse(
  //         "${Config.apiURL}${Config.categoryPostURL}$categoryId&per_page=5");

  //     final response = await dio.get(categoryWiseUrls.toString());

  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = response.data;
  //       final List<PostData> result = data
  //           .map((item) => PostData.fromJson(item as Map<String, dynamic>))
  //           .toList();

  //       sectionPosts.addAll(result);
  //     } else {
  //       if (kDebugMode) {
  //         print("Error 💥");
  //       }
  //       print(response);
  //     }
  //   }

  //   return Column(
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.all(10.0),
  //         child: Row(
  //           children: [
  //             Expanded(
  //               flex: 4,
  //               child: Container(
  //                 // height: Sizes.dimen_14.h,
  //                 // width: Sizes.dimen_80.w,
  //                 alignment: Alignment.center,
  //                 padding: const EdgeInsets.all(12.0),
  //                 // width: MediaQuery.of(context).size.width * 0.3,
  //                 decoration: const BoxDecoration(
  //                   color: Colors.black,
  //                 ),
  //                 child: FittedBox(
  //                   fit: BoxFit.scaleDown,
  //                   child: Text(
  //                     categoryName.toUpperCase(),
  //                     style: TextStyle(
  //                         color: Colors.white,
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: screenWidth * 0.04),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Expanded(
  //               flex: 6,
  //               child: Container(
  //                 // height: Sizes.dimen_14.h,
  //                 alignment: Alignment.center,
  //                 padding: const EdgeInsets.all(10.0),
  //                 // width: MediaQuery.of(context).size.width * 0.7,
  //                 decoration: const BoxDecoration(
  //                   color: kSecondaryColor,
  //                 ),
  //                 child: const Padding(
  //                   padding: EdgeInsets.symmetric(vertical: 10),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       FutureBuilder(
  //         future: postsByCats(),
  //         builder: (context, snapshot) {
  //           if (snapshot.connectionState == ConnectionState.waiting) {
  //             return const CupertinoActivityIndicator(
  //               color: kSecondaryColor,
  //             );
  //           } else if (snapshot.hasError) {
  //             return Text('Error: ${snapshot.error}');
  //           } else {
  //             if (sectionPosts.isEmpty) {
  //               return const Padding(
  //                 padding: EdgeInsets.all(8.0),
  //                 child: SizedBox(
  //                   width: double.infinity,
  //                   child: Center(child: Text("No posts available")),
  //                 ),
  //               );
  //             } else {
  //               return ListView.builder(
  //                 shrinkWrap: true,
  //                 physics: const NeverScrollableScrollPhysics(),
  //                 itemCount: sectionPosts.length,
  //                 itemBuilder: (context, index) {
  //                   PostData postData = sectionPosts[index];
  //                   Map apiData = apiDataAccess(postData);
  //                   return Column(
  //                     children: [
  //                       const SizedBox.shrink(),
  //                       NewsCardSkeleton(
  //                         postId: apiData["id"],
  //                         link: apiData["link"],
  //                         title: apiData["title"],
  //                         imageUrl: apiData["imageUrl"],
  //                         content: apiData["content"],
  //                         date: apiData["date"],
  //                         avatarUrl: apiData["avatarUrl"],
  //                         authorName: apiData["authorName"],
  //                         categoryIdNumbers: apiData["categoryIdNumbers"],
  //                         shortDescription: apiData["shortDesc"],
  //                       ),
  //                     ],
  //                   );
  //                 },
  //               );
  //             }
  //           }
  //         },
  //       ),
  //       // const Divider(height: 1, color: Colors.grey),
  //     ],
  //   );
  // }
}
