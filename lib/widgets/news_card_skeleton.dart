import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:Vanguard/utilities/get_category.dart';
// import 'package:progressive_image/progressive_image.dart';
// import 'package:provider/provider.dart';

// import '../customIcon/custom_icons.dart';
// import '../hiveDB/db_function.dart';
// import '../hivedb/boxes.dart';
import '../pages/news_details_page.dart';
// import '../providers/theme_provider.dart';
import '../utilities/constants.dart';
import '../utilities/responsive_height.dart';
// import 'package:flare_flutter/flare_actor.dart';

class NewsCardSkeleton extends StatefulWidget {
  final String imageUrl, title, shortDescription, content, date, authorName;
  final String? avatarUrl, link;
  final int postId;
  final int? index;

  final List<int> categoryIdNumbers;
  const NewsCardSkeleton({
    Key? key,
    this.index,
    required this.postId,
    this.link,
    required this.imageUrl,
    required this.title,
    required this.shortDescription,
    required this.content,
    required this.date,
    required this.avatarUrl,
    required this.authorName,
    required this.categoryIdNumbers,
  }) : super(key: key);

  @override
  State<NewsCardSkeleton> createState() => _NewsCardSkeletonState();
}

class _NewsCardSkeletonState extends State<NewsCardSkeleton> {
  bool isSave = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final isDarkTheme = Provider.of<ThemeProvider>(context).darkTheme;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double cardHeight = newscardDynamicScreen(screenHeight);
    // final postCategoryName = categoryMap!["${widget.categoryIdNumbers}"];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          // Container(
          //   margin: const EdgeInsets.only(top: 8),
          //   width: 400,
          //   height: 70,
          //   decoration:  const BoxDecoration(
          //     color: Colors.white,
          //   ),
          //   child: const Center(
          //     child: Text(
          //         "ADS",
          //       style: TextStyle(
          //         color: Colors.black,
          //       ),
          //     ),
          //   ),
          // ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewsDetailsPage(
                            postId: widget.postId,
                            link: widget.link,
                            title: widget.title,
                            imageUrl: widget.imageUrl,
                            content: widget.content,
                            date: widget.date,
                            avatarUrl: widget.avatarUrl,
                            authorName: widget.authorName,
                            categoryIdNumbers: widget.categoryIdNumbers,
                            shortDescription: widget.shortDescription,
                          )));
            },
            child: Container(
              height: 100,
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFFE1E1E1),
                ),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 115,
                      height: 100,
                      child: Hero(
                        tag: widget.imageUrl,
                        child:
                          CachedNetworkImage(
                              // width: MediaQuery.of(context).size.width / 2.5,
                              // height: cardHeight,
                            imageUrl: widget.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url){
                              return const CupertinoActivityIndicator(
                                radius: 20,
                                color: kSecondaryColor,
                              );
                            },
                            errorWidget: (context, url, error) => Container(
                              width: MediaQuery.of(context).size.width / 2.5,
                              height: cardHeight,
                              decoration: const BoxDecoration(
                                // borderRadius: BorderRadius.circular(5.0),

                              ),
                              child: Image.asset('assets/images/logo_full.png'),
                            ),
                          ),
                        // ProgressiveImage(
                        //   placeholder:
                        //       const AssetImage('assets/images/loader.gif'),
                        //   thumbnail: NetworkImage(widget.imageUrl),
                        //   image: NetworkImage(widget.imageUrl),
                        //   width: MediaQuery.of(context).size.width / 2.5,
                        //   height: cardHeight,
                        //   // fit: BoxFit.cover,
                        // ),
                      ),
                      // Hero(
                      //                     tag: widget.imageUrl,
                      //                     child: ProgressiveImage(
                      //                       placeholder:
                      //                           const AssetImage('assets/images/splash.png'),
                      //                       thumbnail: NetworkImage(widget.imageUrl),
                      //                       image: NetworkImage(widget.imageUrl),
                      //                       width: MediaQuery.of(context).size.width / 2.5,
                      //                       height: cardHeight,
                      //                     ),
                      //                   ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.8,
                          child: Html(style: {
                            "body": Style(
                              padding: EdgeInsets.zero,
                              margin: EdgeInsets.zero,
                              textOverflow: TextOverflow.clip,
                              maxLines: 1,
                              fontSize: FontSize.small,
                              fontWeight: FontWeight.bold,
                            ),
                          }, data: widget.title),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.8,
                          height: 60,
                          child: Html(style: {
                            "body": Style(
                              padding: EdgeInsets.zero,
                              margin: EdgeInsets.zero,
                              textOverflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              fontSize: FontSize.small,
                            ),
                            "p": Style(
                              padding: EdgeInsets.zero,
                              margin: const EdgeInsets.only(top: 1, bottom: 15),
                            ),
                          }, data: widget.shortDescription),
                        ),
                        // SizedBox(
                        //   width: MediaQuery.of(context).size.width / 1.7,
                        //   child: Text(
                        //     "By ${widget.authorName}",
                        //     overflow: TextOverflow.ellipsis,
                        //     maxLines: 1,
                        //     softWrap: true,
                        //     style: TextStyle(
                        //       fontSize: screenWidth > 300 ? 10 : 7,
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        //   // Row(
                        //   //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   //   children: [
                        //   //     // Row(
                        //   //     //   children: [
                        //   //     //     Icon(
                        //   //     //       CustomIcon.calender,
                        //   //     //       size: screenWidth > 300 ? 10 : 8,
                        //   //     //     ),
                        //   //     //     SizedBox(
                        //   //     //       width: 7,
                        //   //     //     ),
                        //   //     //     Text(
                        //   //     //       widget.date,
                        //   //     //       style: TextStyle(
                        //   //     //         fontSize: screenWidth > 300 ? 10 : 8,
                        //   //     //       ),
                        //   //     //     ),
                        //   //     //   ],
                        //   //     // ),
                        //   //
                        //   //
                        //   //
                        //   //     // Text(
                        //   //     //   timeago.format(
                        //   //     //     recommendation[index]
                        //   //     //         .date,
                        //   //     //   ),
                        //   //     // )
                        //   //     //     .boldSized(10)
                        //   //     //     .colors(colorTextGray),
                        //   //   ],
                        //   // ),
                        // ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.8,
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time_filled_rounded,
                                color: kSecondaryColor,
                                size: screenWidth > 400 ? 12 : 10,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                widget.date,
                                style: TextStyle(
                                  fontSize: screenWidth > 400 ? 9 : 7,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                                child: VerticalDivider(
                                  color: Colors.black,
                                  thickness: 1,
                                ),
                              ),
                              Text(
                                widget.authorName,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: screenWidth > 400 ? 10 : 8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    // return Padding(
    //   padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
    //   child: Card(
    //     color:null,
    //     // isDarkTheme ? kSecondaryColor : null,
    //     elevation: 1,
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(16.0),
    //     ),
    //     child: InkWell(
    //       onTap: () {
    //         Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //                 builder: (context) => NewsDetailsPage(
    //                       postId: widget.postId,
    //                       link: widget.link,
    //                       title: widget.title,
    //                       imageUrl: widget.imageUrl,
    //                       content: widget.content,
    //                       date: widget.date,
    //                       avatarUrl: widget.avatarUrl,
    //                       authorName: widget.authorName,
    //                       categoryIdNumbers: widget.categoryIdNumbers,
    //                       shortDescription: widget.shortDescription,
    //                     )));
    //       },
    //       child: Column(
    //         children: [
    //           Container(
    //             margin: const EdgeInsets.only(top: 8),
    //             width: 400,
    //             height: 150,
    //             decoration: const BoxDecoration(
    //               color: Colors.red,
    //             ),
    //             child: const Center(
    //               child: Text(
    //                   "ADS"
    //               ),
    //             ),
    //           ),
    //           SizedBox(height: 5,),
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               SizedBox(
    //                 width: MediaQuery.of(context).size.width / 2.5,
    //                 height: cardHeight,
    //                 child: ClipRRect(
    //                   borderRadius: BorderRadius.circular(16.0),
    //                   child: Hero(
    //                     tag: widget.imageUrl,
    //                     child: ProgressiveImage(
    //                       placeholder:
    //                           const AssetImage('assets/images/splash.png'),
    //                       thumbnail: NetworkImage(widget.imageUrl),
    //                       image: NetworkImage(widget.imageUrl),
    //                       width: MediaQuery.of(context).size.width / 2.5,
    //                       height: cardHeight,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               Expanded(
    //                 child: Padding(
    //                   padding: const EdgeInsets.all(8.0),
    //                   child: Column(
    //                     mainAxisAlignment: MainAxisAlignment.start,
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Html(style: {
    //                         "body": Style(
    //                           padding: EdgeInsets.zero,
    //                           margin: EdgeInsets.zero,
    //                           textOverflow: TextOverflow.clip,
    //                           maxLines: 2,
    //                           fontSize: FontSize.medium,
    //                           fontWeight: FontWeight.bold,
    //                         ),
    //                       }, data: widget.title),
    //                       Html(style: {
    //                         "body": Style(
    //                           padding: EdgeInsets.zero,
    //                           margin: EdgeInsets.zero,
    //                           textOverflow: TextOverflow.ellipsis,
    //                           maxLines: 2,
    //                           fontSize: FontSize.medium,
    //                         ),
    //                         "p": Style(
    //                           padding: EdgeInsets.zero,
    //                           margin:
    //                               const EdgeInsets.only(top: 10, bottom: 10),
    //                         ),
    //                       }, data: widget.shortDescription),
    //                       Row(
    //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                         children: [
    //                           Align(
    //                               alignment: Alignment.topLeft,
    //                               child: Row(
    //                                 children: [
    //                                   Icon(
    //                                     CustomIcon.calender,
    //                                     size: screenWidth > 300 ? 17 : 15,
    //                                   ),
    //                                   const SizedBox(width: 6),
    //                                   Text(
    //                                     widget.date,
    //                                     style: TextStyle(
    //                                       fontSize: screenWidth > 300 ? 14 : 12,
    //                                     ),
    //                                   ),
    //                                 ],
    //                               )),
    //                           // ValueListenableBuilder(
    //                           //     valueListenable:
    //                           //         Boxes.savePosts().listenable(),
    //                           //     builder: (context, box, _) {
    //                           //       return Align(
    //                           //         alignment: Alignment.topRight,
    //                           //         child: GestureDetector(
    //                           //           onTap: () {
    //                           //             if (Boxes.savePosts().containsKey(
    //                           //                 "${widget.postId}")) {
    //                           //               deleteSavedArticle(
    //                           //                   postId: widget.postId);
    //                           //             } else {
    //                           //               saveArticle(
    //                           //                 postId: widget.postId,
    //                           //                 imageUrl: widget.imageUrl,
    //                           //                 title: widget.title,
    //                           //                 shortDescription:
    //                           //                     widget.shortDescription,
    //                           //                 content: widget.content,
    //                           //                 date: widget.date,
    //                           //                 authorName: widget.authorName,
    //                           //                 avatarUrl: widget.avatarUrl,
    //                           //                 categoryIdNumbers:
    //                           //                     widget.categoryIdNumbers,
    //                           //               );
    //                           //             }
    //                           //           },
    //                           //           child: Boxes.savePosts()
    //                           //                   .containsKey("${widget.postId}")
    //                           //               ? Icon(
    //                           //                   Icons.favorite,
    //                           //                   color:kErrorColor,
    //                           //                   // isDarkTheme
    //                           //                   //     ? kSlideActiveColor
    //                           //                   //     : kErrorColor,
    //                           //                   size:
    //                           //                       screenWidth > 300 ? 24 : 20,
    //                           //                 )
    //                           //               : Icon(
    //                           //                   Icons.favorite_outline,
    //                           //                   size:
    //                           //                       screenWidth > 300 ? 24 : 20,
    //                           //                 ),
    //                           //         ),
    //                           //       );
    //                           //     }),
    //                         ],
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               )
    //             ],
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
