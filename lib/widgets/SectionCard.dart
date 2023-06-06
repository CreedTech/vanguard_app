import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/post_data.dart';
import '../providers/connectivity_provider.dart';
import '../utilities/config.dart';
import '../utilities/constants.dart';
import '../utilities/get_category.dart';
import '../utilities/wp_api_data_access.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SectionCard extends StatefulWidget {
  const SectionCard({
    super.key,
    required this.categoryName,
    required this.categoryId,
  });

  final String categoryName;
  final int categoryId;

  @override
  State<SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<SectionCard> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  bool isRefresh = true;
  List<PostData> sectionPosts = [];

  Future<bool> postsByCats({bool refresh = false}) async {
    if (refresh) {
      if (mounted) {
        setState(() {});
        // currentPage = 1;
      }
    }
    final dio = Dio();
    final Uri categoryWiseUrls = Uri.parse(
        "${Config.apiURL}${Config.categoryPostURL}${widget.categoryId}&per_page=1");

    final response = await dio.get(categoryWiseUrls.toString());

    if (response.statusCode == 200) {
      final jsonStr = json.encode(response.data);
      final result = postDataFromJson(jsonStr);

      if (refresh) {
        sectionPosts = result;
      } else {
        sectionPosts.addAll(result);
      }
      if (mounted) {
        setState(() {});
        // currentPage++;
      }

      return true;
    } else {
      print("error");
      print(response);
      return false;
    }
  }

  void onRefresh() async {
    getCategory();
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
      final result = await postsByCats(refresh: true);
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
    final result = await postsByCats(refresh: false);
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
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    widget.categoryName,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
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
            ),
    );
  }
}
