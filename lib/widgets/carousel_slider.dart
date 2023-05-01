import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:carousel_slider/carousel_slider.dart';
// import 'package:progressive_image/progressive_image.dart';
// import 'package:provider/provider.dart';

import '../model/post_data.dart';
import '../pages/news_details_page.dart';
// import '../providers/theme_provider.dart';
import '../utilities/constants.dart';
import '../utilities/responsive_height.dart';
import '../utilities/wp_api_data_access.dart';

class SliderWidget extends StatefulWidget {
  const SliderWidget({
    Key? key,
    required this.sliderPosts,
  }) : super(key: key);

  final List<PostData> sliderPosts;

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  int currentPos = 0;

  @override
  Widget build(BuildContext context) {
    // final isDarkTheme = Provider.of<ThemeProvider>(context).darkTheme;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double sliderHeight = sliderDynamicScreen(screenHeight);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
          child: Container(
            // margin: const EdgeInsets.only(top: 8),
            width: double.infinity,
            height: 150,
            decoration:  const BoxDecoration(
              color: Colors.white,
                // border: Border.all(color: Colors.redAccent),
              borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
              ),
            ),
            child: Image.asset("assets/images/categorybackground/image5.jpg", fit: BoxFit.cover,),
          ),
        ),
        CarouselSlider.builder(
          itemCount: widget.sliderPosts.length,
          itemBuilder: (context, indexOfSlider, realIndex) {
            final sliderPostData = widget.sliderPosts[indexOfSlider];
            Map apiData = apiDataAccess(sliderPostData);

            return Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewsDetailsPage(
                                  postId: apiData["id"],
                                  link: apiData["link"],
                                  title: apiData["title"],
                                  imageUrl: apiData["imageUrl"],
                                  content: apiData["content"],
                                  date: apiData["date"],
                                  avatarUrl: apiData["avatarUrl"],
                                  authorName: apiData["authorName"],
                                  categoryIdNumbers:
                                      apiData["categoryIdNumbers"],
                                  shortDescription: apiData["shortDesc"],
                                )));
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: CachedNetworkImage(
                          width: double.infinity,
                          height: double.infinity,
                          imageUrl: apiData["imageUrl"] ?? '',
                          fit: BoxFit.cover,
                          placeholder: (context, url){
                            return Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: const BoxDecoration(
                                  // borderRadius: BorderRadius.circular(5.0),

                                ),
                                child: const CupertinoActivityIndicator(
                                  radius: 20,
                                  color: kSecondaryColor,
                                ),);
                          },
                          errorWidget: (context, url, error) => Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: const BoxDecoration(
                              // borderRadius: BorderRadius.circular(5.0),

                            ),
                            child: Image.asset('assets/images/logo_full.png'),
                          ),
                        ),
                        // ProgressiveImage(
                        //   placeholder:
                        //       const AssetImage('assets/images/splash.png'),
                        //   thumbnail: NetworkImage(apiData["imageUrl"]),
                        //   image: NetworkImage(apiData["imageUrl"]),
                        //   width: double.infinity,
                        //   height: double.infinity,
                        // ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 13, top: 10, bottom: 10, right: 10),
                          height: sliderHeight / 2.2,
                          width: (MediaQuery.of(context).size.width) - 28,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.60),
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(16.0),
                                bottomRight: Radius.circular(16.0)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Html(style: {
                                "body": Style(
                                    padding: EdgeInsets.zero,
                                    margin: EdgeInsets.zero,
                                    textOverflow: TextOverflow.clip,
                                    maxLines: 2,
                                    fontFamily: "Poppins",
                                    fontSize: screenWidth > 400
                                        ? FontSize.large
                                        : FontSize.medium,
                                    color: Colors.white),
                              }, data: apiData["title"]),
                              const SizedBox(height: 5),
                              Expanded(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.schedule_outlined,
                                      color: Colors.white,
                                      size: screenWidth > 400 ? 24 : 20,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      apiData["date"],
                                      style: TextStyle(
                                        fontSize: screenWidth > 400 ? 14 : 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                      child: VerticalDivider(
                                        color: Colors.white,
                                        thickness: 1,
                                      ),
                                    ),
                                    Text(
                                      apiData["authorName"],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidth > 400 ? 14 : 12,
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
                ),
              ),
            );
          },
          options: CarouselOptions(
            onPageChanged: ((index, reason) {
              setState(() {
                currentPos = index;
              });
            }),
            height: sliderHeight + 50,
            enlargeCenterPage: true,
            viewportFraction: 1,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.sliderPosts.map((url) {
            int index = widget.sliderPosts.indexOf(url);
            return Container(
              width: currentPos == index ? 24.0 : 12,
              height: 6.5,
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                shape: BoxShape.rectangle,
                color: kPrimaryColor,
                // isDarkTheme
                //     ? currentPos == index
                //         ? kSlideActiveColor
                //         : kPrimaryColor
                //     : currentPos == index
                //         ? Colors.red
                //         : kPrimaryColor,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
