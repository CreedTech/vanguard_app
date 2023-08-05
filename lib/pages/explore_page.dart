import 'package:vanguard/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:vanguard/utilities/get_category.dart';
import 'package:vanguard/widgets/category_card.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<CategoryCard> categoryCards = [];

  void createListOfCategoryCard() {
    for (var i = 0; i < categoryMap!.length; i++) {
      final categoryName = categoryNames[i];
      final categoryId = categoryIdList[i];
      // print("categoryCards");
      // print(categoryCards);

      categoryCards.add(CategoryCard(
        categoryName: categoryName,
        number: i + 1,
        categoryId: categoryId,
      ));
    }
  }

  @override
  void initState() {
    createListOfCategoryCard();
    super.initState();
  }

  @override
  void dispose() {
    setState(() {
      categoryCards.clear();
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: kSecondaryColor,
          elevation: 0,
          title: const Text(
            'Categories',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          child: Column(
            children: [
              Flexible(
                child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(10),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 1,
                  crossAxisCount: 3,
                  children: categoryCards,
                ),
              ),
            ],
          )
          // Column(children: categoryCards)
          ,
        ),
      ),
    );
  }
}
