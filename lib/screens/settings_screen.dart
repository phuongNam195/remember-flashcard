import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './my_dictionary_screen.dart';
import '../widgets/setting_item.dart';
import '../config.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<Config>(context);
    final textColor = config.isDarkTheme ? Colors.white : Color(0xff121628);

    return Scaffold(
      backgroundColor: config.isDarkTheme ? Color(0xff232245) : Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: config.isDarkTheme ? Colors.white : Color(0xff2f2b53),
              ),
              splashColor: Colors.transparent,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            stretch: true,
            snap: true,
            expandedHeight: 200,
            flexibleSpace: Container(
              color: config.isDarkTheme ? Color(0xff232245) : Colors.white,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: FittedBox(
                child: Text('Remember',
                    style: TextStyle(
                        fontFamily: 'Sarabun',
                        color: textColor,
                        fontSize: 50,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: MediaQuery.of(context).size.width > 550 ? 550 : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'About',
                          style: TextStyle(
                              fontFamily: 'Sarabun',
                              color: config.isDarkTheme
                                  ? Colors.white
                                  : Color(0xff1a1d2f),
                              fontSize: 26,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: AssetImage(
                              './assets/images/avatar.png',
                            ),
                            radius: 35,
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Phuong Nam',
                                  style: TextStyle(
                                      fontFamily: 'Sarabun',
                                      color: config.isDarkTheme
                                          ? Colors.white
                                          : Color(0xff1a1d2f),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 4),
                                FittedBox(
                                  child: Text(
                                    'fb.com/NamAntoneus',
                                    style: TextStyle(
                                        fontFamily: 'Sarabun',
                                        color: config.isDarkTheme
                                            ? Colors.white54
                                            : Colors.black54,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Settings',
                          style: TextStyle(
                              fontFamily: 'Sarabun',
                              color: config.isDarkTheme
                                  ? Colors.white
                                  : Color(0xff1a1d2f),
                              fontSize: 26,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(height: 20),
                      SettingItem(
                        title: 'My dictionary',
                        color: textColor,
                        leadingIcon: Icons.book,
                        leadingColor: Color(0xff1ca4eb),
                        type: SettingType.navigate,
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(MyDictionaryScreen.routeName);
                        },
                      ),
                      SettingItem(
                          title: 'Only primary word',
                          color: textColor,
                          leadingIcon: Icons.translate,
                          leadingColor: Color(0xfffd732d),
                          type: SettingType.toggle,
                          value: config.onlyPrimaryWord,
                          onToggled: () {
                            config.toggleOnlyPrimaryWord();
                          }),
                      if (defaultTargetPlatform == TargetPlatform.windows)
                        SettingItem(
                            title: 'Long press key',
                            color: textColor,
                            leadingIcon: Icons.keyboard_alt,
                            leadingColor: Color(0xffAE00FB),
                            type: SettingType.toggle,
                            value: config.waitLongPressKey,
                            onToggled: () {
                              config.toggleWaitLongPressKey();
                            }),
                      SettingItem(
                          title: 'Dark Mode',
                          color: textColor,
                          leadingIcon: Icons.dark_mode,
                          leadingColor: Color(0xff5631fa),
                          type: SettingType.toggle,
                          value: config.isDarkMode,
                          onToggled: () {
                            config.toggleDarkMode();
                          }),
                    ],
                  ),
                ),
              ),
              childCount: 1,
            ),
          ),
        ],
      ),

      // Align(
      //   alignment: Alignment.center,
      //   child: Container(
      //       // color: config.isDarkTheme ? Color(0xff2f2b53) : Colors.white,
      //       width: MediaQuery.of(context).size.width > 550 ? 550 : null,
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Padding(
      //             padding: const EdgeInsets.all(20),
      //             child: IconButton(
      //               icon: Icon(
      //                 Icons.arrow_back_ios_new,
      //                 size: 22,
      //                 color:
      //                     config.isDarkTheme ? Colors.white : Color(0xff2f2b53),
      //               ),
      //               onPressed: () {
      //                 Navigator.of(context).pop();
      //               },
      //             ),
      //           ),
      //           Padding(
      //             padding: const EdgeInsets.only(left: 22, right: 22),
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Padding(
      //                   padding: const EdgeInsets.only(left: 10),
      //                   child: Text('Remember',
      //                       style: TextStyle(
      //                           fontFamily: 'Sarabun',
      //                           color: textColor,
      //                           fontSize: 40,
      //                           fontWeight: FontWeight.w600)),
      //                 ),
      //                 SizedBox(height: 40),
      //                 Padding(
      //                   padding: const EdgeInsets.only(left: 10),
      //                   child: Text(
      //                     'About',
      //                     style: TextStyle(
      //                         fontFamily: 'Sarabun',
      //                         color: config.isDarkTheme
      //                             ? Colors.white
      //                             : Color(0xff1a1d2f),
      //                         fontSize: 26,
      //                         fontWeight: FontWeight.w500),
      //                   ),
      //                 ),
      //                 SizedBox(height: 30),
      //                 Row(
      //                   children: [
      //                     SizedBox(width: 10),
      //                     CircleAvatar(
      //                       backgroundColor: Colors.transparent,
      //                       backgroundImage: AssetImage(
      //                         './assets/images/avatar.png',
      //                       ),
      //                       radius: 35,
      //                     ),
      //                     SizedBox(width: 20),
      //                     Expanded(
      //                       child: Column(
      //                         crossAxisAlignment: CrossAxisAlignment.start,
      //                         children: [
      //                           Text(
      //                             'Phuong Nam',
      //                             style: TextStyle(
      //                                 fontFamily: 'Sarabun',
      //                                 color: config.isDarkTheme
      //                                     ? Colors.white
      //                                     : Color(0xff1a1d2f),
      //                                 fontSize: 20,
      //                                 fontWeight: FontWeight.w500),
      //                           ),
      //                           SizedBox(height: 4),
      //                           FittedBox(
      //                             child: Text(
      //                               'fb.com/NamAntoneus',
      //                               style: TextStyle(
      //                                   fontFamily: 'Sarabun',
      //                                   color: config.isDarkTheme
      //                                       ? Colors.white54
      //                                       : Colors.black54,
      //                                   fontSize: 17,
      //                                   fontWeight: FontWeight.w400),
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                     )
      //                   ],
      //                 ),
      //                 SizedBox(height: 40),
      //                 Padding(
      //                   padding: const EdgeInsets.only(left: 10),
      //                   child: Text(
      //                     'Settings',
      //                     style: TextStyle(
      //                         fontFamily: 'Sarabun',
      //                         color: config.isDarkTheme
      //                             ? Colors.white
      //                             : Color(0xff1a1d2f),
      //                         fontSize: 26,
      //                         fontWeight: FontWeight.w500),
      //                   ),
      //                 ),
      //                 SizedBox(height: 20),
      //                 SettingItem(
      //                   title: 'My dictionary',
      //                   color: textColor,
      //                   leadingIcon: Icons.book,
      //                   leadingColor: Color(0xff1ca4eb),
      //                   type: SettingType.navigate,
      //                   routeName: MyDictionaryScreen.routeName,
      //                 ),
      //                 SettingItem(
      //                     title: 'Only primary word',
      //                     color: textColor,
      //                     leadingIcon: Icons.translate,
      //                     leadingColor: Color(0xfffd732d),
      //                     type: SettingType.toggle,
      //                     value: config.onlyPrimaryWord,
      //                     onToggled: () {
      //                       config.toggleOnlyPrimaryWord();
      //                     }),
      //                 if (defaultTargetPlatform == TargetPlatform.windows)
      //                   SettingItem(
      //                       title: 'Long press key',
      //                       color: textColor,
      //                       leadingIcon: Icons.keyboard_alt,
      //                       leadingColor: Color(0xffAE00FB),
      //                       type: SettingType.toggle,
      //                       value: config.waitLongPressKey,
      //                       onToggled: () {
      //                         config.toggleWaitLongPressKey();
      //                       }),
      //                 SettingItem(
      //                     title: 'Dark Mode',
      //                     color: textColor,
      //                     leadingIcon: Icons.dark_mode,
      //                     leadingColor: Color(0xff5631fa),
      //                     type: SettingType.toggle,
      //                     value: config.isDarkMode,
      //                     onToggled: () {
      //                       config.toggleDarkMode();
      //                     }),
      //               ],
      //             ),
      //           )
      //         ],
      //       )),
      // ),
    );
  }
}
