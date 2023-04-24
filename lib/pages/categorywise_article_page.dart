// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:newsgig/utilities/constants.dart';
import 'package:newsgig/widgets/shimmer_effect.dart';
import '../utilities/wp_api_data_access.dart';
import '../widgets/news_card_skeleton.dart';
import 'package:newsgig/utilities/config.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../model/post_data.dart';

class CategoryPosts extends StatefulWidget {
  const CategoryPosts(
      {Key? key, this.categoryName, this.number, this.categoryId})
      : super(key: key);

  final String? categoryName;
  final int? number, categoryId;

  @override
  State<CategoryPosts> createState() => _CategoryPostsState();
}

class _CategoryPostsState extends State<CategoryPosts> {
  ScrollController? scrollController;
  int currentPage = 1;
  List<PostData> posts = [];
  bool refresh = true;

  final RefreshController refreshController = RefreshController();
  Future<bool> getPostData({bool isRefresh = false}) async {
    if (isRefresh) {
      if (mounted) {
        setState(() {});
        currentPage = 1;
        refresh = true;
      }
    }
    final Uri categoryWiseUrls = Uri.parse(
        "${Config.apiURL}${Config.categoryPostURL}${widget.categoryId} &page=$currentPage");

    final response = await http.get(categoryWiseUrls);
    print(response);

    if (response.statusCode == 200) {
      final result = postDataFromJson(response.body);
      print(result);

      if (isRefresh) {
        posts = result;
      } else {
        posts.addAll(result);
      }
      if (mounted) {
        setState(() {});
        currentPage++;
        refresh = false;
      }

      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    getPostData(isRefresh: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              backgroundColor: kSecondaryColor,
              leadingWidth: 62,
              leading: Padding(
                padding: const EdgeInsets.only(left: 6),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              // snap: true,
              pinned: true,
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                collapseMode: CollapseMode.parallax,
                  titlePadding: EdgeInsets.only(bottom: 80),
                  title: Text("${widget.categoryName}"),
                  background: Container(
                    color: kSecondaryColor,
                  ),
              ),
              expandedHeight: (MediaQuery.of(context).size.height) / 4.5,
            ),
          ],
          body: SmartRefresher(
            controller: refreshController,
            enablePullUp: true,
            onRefresh: () async {
              final result = await getPostData(isRefresh: true);
              if (result == true) {
                refreshController.refreshCompleted();
              } else {
                refreshController.refreshFailed();
              }
            },
            onLoading: () async {
              final result = await getPostData(isRefresh: false);
              if (result == true) {
                refreshController.loadComplete();
              } else {
                refreshController.loadNoData();
              }
            },
            child: refresh
                ? ShimmerEffect(slider: false)
                : ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final postData = posts[index];
                      Map apiData = apiDataAccess(postData);

                      return NewsCardSkeleton(
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
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
