import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:Vanguard/utilities/get_category.dart';
import 'package:provider/provider.dart';
import '../model/post_data.dart';
import '../providers/connectivity_provider.dart';
import '../utilities/config.dart';
import '../utilities/constants.dart';
import '../utilities/wp_api_data_access.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: true);
  bool isRefresh = true;
  List<PostData> posts = [];
  // bool isDataLoaded = false;
  // bool isMounted = false;

  // @override
  // void initState() {
  //   super.initState();
  //   isMounted = true;
  //   fetchData();
  // }

  // @override
  // void dispose() {
  //   isMounted = false;
  //   super.dispose();
  // }

  Future<bool> fetchData({bool refresh = false}) async {
    if (refresh) {
      if (mounted) {
        setState(() {});
        // currentPage = 1;
      }
    }
    // Simulate data fetching delay
    // await Future.delayed(const Duration(seconds: 2));

    // Create an instance of Dio
    final dio = Dio();

    try {
      // Fetch data for each category ID
      for (var i = 0; i < homeCategoryIdList.length; i++) {
        final categoryId = homeCategoryIdList[i];

        // Make the API request
        final Uri categoryWiseUrls = Uri.parse(
            "https://vanguardngr.com/wp-json/wp/v2/posts?_embed&categories=$categoryId");

        final response = await dio.get(categoryWiseUrls.toString());

        if (response.statusCode == 200) {
          // Check if the response data is null or empty list
          if (response.data != null && response.data is List) {
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
          }
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

    // if (isMounted) {
    //   setState(() {
    //     isDataLoaded = true;
    //   });
    // }
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

      var isFirstPage = true;
      // if (widget.id == 0) {
      // isFirstPage = await getSliderData();
      // }
      final result = await fetchData(refresh: true);
      if (result == true && isFirstPage == true) {
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: refreshController,
      enablePullUp: true,
      onRefresh: onRefresh,
      onLoading: onLoading,
      header: const WaterDropHeader(
        waterDropColor: kSecondaryColor,
      ),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = const Text("pull up load");
          } else if (mode == LoadStatus.loading) {
            body = const CupertinoActivityIndicator(
              color: kSecondaryColor,
            );
          } else if (mode == LoadStatus.failed) {
            body = const Text("Load Failed!Click retry!");
          } else if (mode == LoadStatus.canLoading) {
            body = const Text("release to load more");
          } else {
            body = const Text("No more Data");
          }
          return SizedBox(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      child: isRefresh
          ? Stack(
              fit: StackFit.expand,
              children: const [
                Center(
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: CupertinoActivityIndicator(
                      radius: 20,
                      color: kSecondaryColor,
                    ),
                  ),
                ),
              ],
            )
          : ListView(
              children: [
                for (var i = 0; i < homeCategoryMap!.length; i++)
                  _buildSection(homeCategoryNames[i], homeCategoryIdList[i])
              ],
            ),
    );
  }

  Widget _buildSection(String categoryName, int categoryId) {
    List<PostData> sectionPosts = [];

    Future<void> postsByCats() async {
      final dio = Dio();
      final Uri categoryWiseUrls = Uri.parse(
          "${Config.apiURL}${Config.categoryPostURL}$categoryId&per_page=1");

      final response = await dio.get(categoryWiseUrls.toString());

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final List<PostData> result = data
            .map((item) => PostData.fromJson(item as Map<String, dynamic>))
            .toList();

        sectionPosts.addAll(result);
      } else {
        if (kDebugMode) {
          print("Error 💥");
        }
        print(response);
      }
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            categoryName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        FutureBuilder(
          future: postsByCats(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sectionPosts.length,
                itemBuilder: (context, index) {
                  PostData postData = sectionPosts[index];
                  Map apiData = apiDataAccess(postData);
                  return ListTile(
                    title: Text(apiData["title"]),
                    // subtitle: Text(postData.description),
                  );
                },
              );
            }
          },
        ),
        const Divider(height: 1, color: Colors.grey),
      ],
    );
  }
}
