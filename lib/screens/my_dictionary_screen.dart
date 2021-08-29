import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final FocusNode _focusNode = FocusNode();
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    if (!_isLoaded) {
      dictionary = Provider.of<Dictionary>(context, listen: false);

      void loadData() async {
        await Future.delayed(Duration(milliseconds: 200));
        await dictionary.fetchAndSetData();
        setState(() {
          _isLoaded = true;
        });
      }

      loadData();
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<Config>(context, listen: false);
    return RawKeyboardListener(
      autofocus: true,
      focusNode: _focusNode,
      onKey: (event) {
        if (event is RawKeyDownEvent) {
          if (event.isKeyPressed(LogicalKeyboardKey.escape)) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: config.isDarkMode ? Color(0xff232245) : null,
        appBar: AppBar(
          backgroundColor: config.isDarkMode ? Color(0xff1b1b38) : null,
          title: Text(
            'My Dictionary',
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
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _focusNode.unfocus();
                  Navigator.of(context)
                      .pushNamed(EditVocabularyScreen.routeName)
                      .then((isChanged) {
                    if (isChanged as bool) {
                      setState(() {});
                    }
                  });
                  FocusScope.of(context).requestFocus(_focusNode);
                },
              ),
            ),
          ],
        ),
        body: _isLoaded
            ? RefreshIndicator(
                onRefresh: () async {
                  dictionary.fetchAndSetData();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Consumer<Dictionary>(builder: (_, dict, ch) {
                    final list = dict.vocabs;
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
              ),
      ),
    );
  }
}
