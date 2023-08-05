import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../utilities/config.dart';
import '../model/post_data.dart';
import '../utilities/constants.dart';
import '../utilities/wp_api_data_access.dart';
import '../widgets/news_card_skeleton.dart';
// import '../widgets/shimmer_effect.dart';
import 'package:dio/dio.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _textEditingController = TextEditingController();
  ValueNotifier<List<PostData>> searchPosts = ValueNotifier([]);
  String? searchTitle;
  bool isLoading = false;

  Future<bool> getSearchData({searchTittle}) async {
    final dio = Dio();
    final Uri searchesArticle =
        Uri.parse("${Config.apiURL}${Config.searchPosts}$searchTittle");

    try {
      final response = await dio.get(searchesArticle.toString());

      if (response.statusCode == 200) {
        final jsonStr = json.encode(response.data);
        final result = postDataFromJson(jsonStr);
        searchPosts.value = result;
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting search data: $e');
      }
    }

    return false;
  }

  @override
  void dispose() {
    _textEditingController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kSecondaryColor,
          title: const Text("Search"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _textEditingController,
                onSubmitted: (String value) async {
                  if (value.isNotEmpty) {
                    setState(() {
                      isLoading = true;
                    });
                    await getSearchData(searchTittle: value);
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: const Padding(
                    padding: EdgeInsetsDirectional.only(start: 16, end: 10),
                    child: Icon(
                      Icons.search,
                      color: kSecondaryColor,
                    ),
                  ),
                  filled: true,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20.0)),
                  hintText: 'Search',
                ),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                  valueListenable: searchPosts,
                  builder: (context, posts, _) {
                    return isLoading
                        ? Stack(
                            fit: StackFit.expand,
                            children: const [
                              Center(
                                child: SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: SpinKitFadingCircle(
                                    color: kSecondaryColor,
                                    size: 30.0,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            itemCount: searchPosts.value.length,
                            itemBuilder: ((context, index) {
                              final postData = searchPosts.value[index];
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
                            }),
                          );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
