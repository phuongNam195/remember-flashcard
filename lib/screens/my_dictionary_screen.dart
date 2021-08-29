import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/dictionary.dart';
import '../widgets/vocabulary_item.dart';
import '../config.dart';
import './edit_vocabulary_screen.dart';

class MyDictionaryScreen extends StatefulWidget {
  static const routeName = '/settings/my-dictionary';

  @override
  _MyDictionaryScreenState createState() => _MyDictionaryScreenState();
}

class _MyDictionaryScreenState extends State<MyDictionaryScreen> {
  late final Dictionary dictionary;
  bool _isArchiveDict = false;
  bool _isLoaded = false;
  // final ScrollController controller = ScrollController();
  // final perPage = 20;
  // late int currLength;

  @override
  void initState() {
    // currLength = perPage;
    // controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isLoaded) {
      dictionary = Provider.of<Dictionary>(context, listen: false);
      final argument = ModalRoute.of(context)!.settings.arguments;
      if (argument != null) {
        _isArchiveDict = argument as bool;
      }

      void loadData() async {
        await Future.delayed(Duration(milliseconds: 200));
        await dictionary.fetchAndSetData();
        dictionary.syncWithServer();
        setState(() {
          _isLoaded = true;
        });
      }

      loadData();

      // Future.delayed(Duration(milliseconds: 300)).then((_) {
      //   Provider.of<Dictionary>(context, listen: false).fetchAndSetData();
      // }).then((_) {
      //   setState(() {
      //     _isLoaded = true;
      //   });
      // });
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // controller.removeListener(_scrollListener);
    super.dispose();
  }

  // void _scrollListener() {
  //   if (controller.position.extentAfter < 200) {
  //     final dictionary = Dictionary();
  //     setState(() {
  //       currLength += perPage;
  //       if (currLength > dictionary.length) currLength = dictionary.length;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<Config>(context, listen: false);
    final appbarColor = config.isDarkTheme
        ? Color(0xff1b1b38)
        : (_isArchiveDict ? Color(0xff5c3d2e) : null);

    return Scaffold(
        backgroundColor: config.isDarkTheme ? Color(0xff232245) : null,
        appBar: AppBar(
          backgroundColor: appbarColor,
          title: Text(
            _isArchiveDict ? 'Archive' : 'My Dictionary',
            style: TextStyle(fontFamily: 'Sarabun'),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: 22,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: _isArchiveDict
              ? null
              : [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(EditVocabularyScreen.routeName)
                            .then((isChanged) {
                          if (isChanged as bool) {
                            setState(() {});
                          }
                        });
                      },
                    ),
                  ),
                ],
        ),
        body: _isLoaded
            ? RefreshIndicator(
                onRefresh: () async {
                  dictionary.fetchAndSetData();
                  dictionary.syncWithServer();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Consumer<Dictionary>(builder: (_, dict, ch) {
                    final list = _isArchiveDict ? dict.archives : dict.vocabs;
                    if (list.isEmpty)
                      return Center(
                          child: Text(
                        'Nothing!',
                        style: Theme.of(context).textTheme.headline1!.copyWith(
                            color: config.theme.textColor, fontSize: 24),
                      ));
                    return RawScrollbar(
                      thumbColor: config.theme.textColor.withOpacity(0.2),
                      radius: Radius.circular(3),
                      thickness: 8,
                      child: ListView.builder(
                          // controller: controller,
                          // itemCount: currLength,
                          itemCount: list.length,
                          itemBuilder: (ctx, index) {
                            int i = list.length - index - 1;
                            return VocabularyItem(
                              id: list[i].id,
                              title: list[i].en,
                              textColor: config.theme.textColor,
                              isArchived: _isArchiveDict,
                              onChanged: () {
                                setState(() {});
                              },
                            );
                          }),
                    );
                  }),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
