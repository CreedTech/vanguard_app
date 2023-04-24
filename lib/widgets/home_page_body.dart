import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:newsgig/utilities/constants.dart';
import '../model/post_data.dart';
import '../providers/connectivity_provider.dart';
import '../services/weather.dart';
import '../utilities/config.dart';
import '../utilities/get_category.dart';
import 'package:provider/provider.dart';
import '../utilities/wp_api_data_access.dart';
import 'news_card_skeleton.dart';
import 'package:http/http.dart' as http;
import 'carousel_slider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'shimmer_effect.dart';

class NewsCard extends StatefulWidget {
  const NewsCard({
    Key? key,
    required this.id,
  }) : super(key: key);
  final int? id;

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  WeatherModel weather = WeatherModel();

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  bool isRefresh = true;

  int currentPage = 1;
  List<PostData> sliderPosts = [];
  List<PostData> posts = [];

  Future<bool> getSliderData() async {
    final Uri latestPostUrls = Uri.parse(
        "${Config.apiURL}${Config.categoryPostURL}30762 &page=$currentPage");
    final response = await http.get(latestPostUrls);
    if (response.statusCode == 200) {
      final result = postDataFromJson(response.body);
      sliderPosts = result;
      return true;
    }

    return false;
  }

  Future<bool> getPostData({bool refresh = false}) async {
    if (refresh) {
      if (mounted) {
        setState(() {});
        currentPage = widget.id == 14072 ? 2 : 1;
      }
    }
    final Uri latestPostUrls = Uri.parse(
        "${Config.apiURL}${Config.categoryPostURL}30762 &page=$currentPage");
    final Uri categoryWiseUrls = Uri.parse(
        "${Config.apiURL}${Config.categoryPostURL}${widget.id} &page=$currentPage");

    final response =
        await http.get(widget.id == 14072 ? latestPostUrls : categoryWiseUrls);

    if (response.statusCode == 200) {
      final result = postDataFromJson(response.body);

      if (refresh) {
        posts = result;
      } else {
        posts.addAll(result);
      }
      if (mounted) {
        setState(() {});
        currentPage++;
      }

      return true;
    } else {
      return false;
    }
  }

  void onRefresh() async {
    getCategory();
    refreshController.refreshCompleted();
    if (Provider.of<ConnectivityProvider>(context, listen: false).isOnline) {
      if (mounted) {
        setState(() {
          isRefresh = true;
        });
      }

      var isFirstPage = true;
      // if (widget.id == 0) {
      isFirstPage = await getSliderData();
      // }
      final result = await getPostData(refresh: true);
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
    final result = await getPostData(refresh: false);
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
          : ListView.builder(
              shrinkWrap: true,
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final postData = posts[index];
                Map apiData = apiDataAccess(postData);

                return Column(
                  children: [
                    if (index == 0 && widget.id == 14072)
                      SliderWidget(sliderPosts: sliderPosts)
                    else
                      const SizedBox.shrink(),
                    NewsCardSkeleton(
                      postId: apiData["id"],
                      link: apiData["link"],
                      title: apiData["title"],
                      imageUrl: apiData["imageUrl"],
                      content: apiData["content"],
                      date: apiData["date"],
                      avatarUrl: apiData["avatarUrl"],
                      authorName: apiData["authorName"],
                      categoryIdNumbers: apiData["categoryIdNumbers"],
                      shortDescription: apiData["shortDesc"],
                    ),
                  ],
                );
              },
            ),
    );
  }
}
