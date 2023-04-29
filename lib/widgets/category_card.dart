import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:Vanguard/utilities/constants.dart';

import '../pages/categorywise_article_page.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard(
      {Key? key, this.categoryName, this.number, this.categoryId})
      : super(key: key);

  final String? categoryName;
  final int? number, categoryId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CategoryPosts(
              categoryName: categoryName,
              number: number,
              categoryId: categoryId,
            );
          }));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: kSecondaryColor,
          ),
          width: double.infinity,
          height: (MediaQuery.of(context).size.height) / 6,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: kSecondaryColor,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                  child:
                  Html(style: {
                    "body": Style(
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.zero,
                      textOverflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      fontSize: FontSize.large,
                        color: const Color.fromARGB(240, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                    ),
                    // "p": Style(
                    //   padding: EdgeInsets.zero,
                    //   margin: EdgeInsets.zero,
                    //   textOverflow: TextOverflow.ellipsis,
                    //   maxLines: 2,
                    //   fontSize: FontSize.large,
                    //   color: Color.fromARGB(240, 255, 255, 255),
                    // ),
                  }, data: categoryName!.toUpperCase()),
              //     Text(
              //   categoryName!.toUpperCase(),
              //   style: const TextStyle(
              //       fontSize: 20.0,
              //       overflow: TextOverflow.ellipsis,
              //       color: Color.fromARGB(240, 255, 255, 255),
              //       fontWeight: FontWeight.bold),
              // ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
