import '../services/netwroking.dart';
import 'config.dart';

Map<String, String>? categoryMap = {};
Map<String, String>? homeCategoryMap = {};

List<String> categoryNames = [];
List<String> homeCategoryNames = [];

List<int> categoryIdList = [];
List<int> homeCategoryIdList = [];

void getCategory() async {
  NetworkHelper networkHelper = NetworkHelper(
      "${Config.apiURL}${Config.categoryURl}?_embed&per_page=100&orderby=count&order=desc");

  List dataOfCategory = await networkHelper.fetchCategories();
  for (var i = 0; i < dataOfCategory.length; i++) {
    var categoryName = dataOfCategory[i]['name'];
    var categoryidNumber = dataOfCategory[i]['id'];
    categoryNames.add(categoryName);
    categoryIdList.add(categoryidNumber);

    categoryMap!["$categoryidNumber"] = categoryName;
  }
}


void getHomeCategory() async {
  NetworkHelper networkHelper = NetworkHelper(
      "https://www.vanguardngr.com/wp-json/categorylist/v1/cats/");

  List dataOfHomeCategory = await networkHelper.fetchCategories();
  for (var i = 0; i < dataOfHomeCategory.length; i++) {
    var homeCategoryName = dataOfHomeCategory[i]['title'];
    var homeCategoryidNumber = int.parse(dataOfHomeCategory[i]['tag_id']);
    homeCategoryNames.add(homeCategoryName);
    homeCategoryIdList.add(homeCategoryidNumber);

    homeCategoryMap!["$homeCategoryidNumber"] = homeCategoryName;
    // print(homeCategoryIdList);
    // print(homeCategoryidNumber);
    // print(homeCategoryName);
  }
    // print(homeCategoryNames);
}