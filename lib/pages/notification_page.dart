import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vanguard/hivedb/db_function.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../customIcon/custom_icons.dart';
import '../utilities/constants.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // Box? storeData;

  // @override
  // void initState() {
  //   super.initState();
  //   storeData = Hive.box('saveposts');
  // }

  @override
  Widget build(BuildContext context) {
    // final isDarkTheme = Provider.of<ThemeProvider>(context).darkTheme;
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: kSecondaryColor,
        title: Text(AppLocalizations.of(context)!.notfication),
        actions: const [
          IconButton(
            icon: Icon(Icons.cancel_presentation_rounded),
            onPressed: deleteSavedNotifcation,
          ),
        ],
      ),
      body: ValueListenableBuilder<Box>(
        valueListenable: Hive.box('savenotification').listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: (MediaQuery.of(context).size.height) / 2.5,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage("assets/images/notification_empty.png"),
                    )),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppLocalizations.of(context)!.notificationSectionTitle,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    AppLocalizations.of(context)!.notificationSectionMsg,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
                itemCount: box.values.length,
                itemBuilder: (BuildContext context, int index) {
                  final saveNotification = box.getAt(index)!;
                  final notificationData = saveNotification.notificationData;

                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      color: null,
                      // isDarkTheme ? kSecondaryColor : null,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ExpandablePanel(
                            theme: const ExpandableThemeData(
                              iconColor: Colors.black,
                              // isDarkTheme ? Colors.white : Colors.black,
                              hasIcon: true,
                            ),
                            header: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.05),
                                        // isDarkTheme
                                        //     ? kPrimaryColor
                                        //     : Colors.black.withOpacity(0.05),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: const Icon(
                                      CustomIcon.notification,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Vaguard •"),
                                        const SizedBox(height: 2),
                                        Text(
                                          notificationData['title'],
                                          style: TextStyle(
                                              fontSize:
                                                  screenWidth > 360 ? 16 : 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            collapsed: Text(
                              notificationData['body'],
                              softWrap: true,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                            expanded: Text(
                              notificationData['body'],
                              softWrap: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }
        },
      ),
    ));
  }
}
