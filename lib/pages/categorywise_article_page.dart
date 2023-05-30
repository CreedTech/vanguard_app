// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:Vanguard/utilities/constants.dart';
// import 'package:Vanguard/widgets/shimmer_effect.dart';
import '../utilities/wp_api_data_access.dart';
import '../widgets/news_card_skeleton.dart';
import 'package:Vanguard/utilities/config.dart';
import 'package:http/http.dart' as http;
// import 'package:dio/dio.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../model/post_data.dart';
import 'package:dio/dio.dart';

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
  
  final dio = Dio();
  try {
    final response = await dio.get(categoryWiseUrls.toString());
  
    if (kDebugMode) {
      print(response);
    }
  
    if (response.statusCode == 200) {
      final jsonStr = json.encode(response.data);
      final result = postDataFromJson(jsonStr);
  
      if (kDebugMode) {
        print(result);
      }
  
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
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error getting post data: $e');
    }
  }

  return false;
}

  @override
  void initState() {
    getPostData(isRefresh: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kSecondaryColor,
        title: Text("${widget.categoryName}"),
        centerTitle: true,
      ),
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
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
    );
  }
}
