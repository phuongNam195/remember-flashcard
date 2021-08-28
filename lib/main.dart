import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './providers/dictionary.dart';
import './screens/main_screen.dart';
import './screens/settings_screen.dart';
import 'screens/my_dictionary_screen.dart';
import './screens/edit_vocabulary_screen.dart';
import './config.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final String data =
    //     'on the same page: đồng ý với ai về việc gì đó;beat around the bush: vòng vo tam quốc;best of both worlds: cả 2 được hưởng lợi từ cả 2 tình huống;in your best interest: có lợi cho bạn;learn the ropes: học hỏi để hiểu rõ một công việc cụ thể;adolescent: thanh niên;no other choice but to + V: không có lựa chọn nào ngoài;place/put/lay the emphasis: nhấn mạnh;thoroughly: triệt để;spouse: vợ/chồng;jump sharly: nhảy vọt;risk: rủi ro;risky|little dangerous: rủi ro;hit the coast: đổ bộ vào bờ biển;batter the coast: đổ bộ vào bờ biển;financial plan|budget: ngân sách;expel: trục xuất;expulsion: sự trục xuất;kick (S.O) out of: đuổi ra khỏi;violate: xâm phạm|vi phạm;misunderstanding: hiểu lầm;stress relief: giảm stress;relieve: làm dịu;3rd party: bên thứ 3;compose: biên soạn;influence|affect: ảnh hưởng;pamper: nuông chiều;privilege: đặc ân, đặc quyền;narcissism [n]: tự kiêu;aspire: khao khát;integral part: phần quan trọng;occasion: dịp|cơ hội;mutable|changable: có thể thay đổi;invoke: gọi (hàm, phương thức);revoke: thu hồi;margin: lề;some < quite a bit < a lot: hơn một chút;onboarding: nhập môn;masterpiece: kiệt tác|tác phẩm lớn;engage|involve: liên quan;govern: chi phối|quy định;dispose: vứt bỏ;disposable: dùng một lần vứt;farmers\' market: chợ nông sản;nearby: gần đây;Frence ~ friend;career ~ Korea;created ~ credit;keep up (ki-pờp) ~ KPOP;rarely ~ really';
    // final list = data.split(';');
    // final bd = list.map((item) {
    //   String? extra;
    //   if (item.contains('[')) {
    //     extra = item.substring(item.indexOf('[') + 1, item.indexOf(']'));
    //     item = item.replaceRange(item.indexOf('['), item.indexOf(']') + 1, '');
    //   }
    //   if (item.contains('~')) {
    //     return {
    //       'en': item.substring(0, item.indexOf('~') - 1),
    //       'en2': item.substring(item.indexOf('~') + 2),
    //       'vi': '~',
    //     };
    //   }
    //   var ens = item.substring(0, item.indexOf(':'));
    //   var vis = item.substring(item.indexOf(':') + 2);
    //   var en = ens;
    //   var vi = vis;
    //   String? en2;
    //   String? vi2;
    //   if (ens.contains('|')) {
    //     en = ens.split('|')[0];
    //     en2 = ens.split('|')[1];
    //   }
    //   if (vis.contains('|')) {
    //     vi = vis.split('|')[0];
    //     vi2 = vis.split('|')[1];
    //   }
    //   Map result = {'en': en, 'vi': vi, 'en2': en2, 'vi2': vi2, 'extra': extra};
    //   result.removeWhere((key, value) => value == null);
    //   return result;
    // }).toList();
    // final url = Uri.parse(
    //     'https://toihocflutter-default-rtdb.asia-southeast1.firebasedatabase.app/dictionary.json');
    // bd.forEach((element) {
    //   http.post(url, body: json.encode(element));
    // });
    // return Container();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Dictionary()),
        ChangeNotifierProvider(create: (ctx) => Config()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Raleway',
          textTheme: ThemeData.light().textTheme.copyWith(
                headline1: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
                headline2: TextStyle(
                  // color: Colors.grey[300]!.withOpacity(0.3);
                  fontWeight: FontWeight.w400,
                ),
                headline3: TextStyle(
                  // color: Colors.white12,
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                ),
                subtitle1: TextStyle(
                  // color: Colors.white24,
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              ),
        ),
        // initialRoute: SettingsScreen.routeName,
        routes: {
          MainScreen.routeName: (ctx) => MainScreen(),
          SettingsScreen.routeName: (ctx) => SettingsScreen(),
          MyDictionaryScreen.routeName: (ctx) => MyDictionaryScreen(),
          EditVocabularyScreen.routeName: (ctx) => EditVocabularyScreen(),
        },
      ),
    );
  }
}
