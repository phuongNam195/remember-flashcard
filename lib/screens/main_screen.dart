import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/index_controller.dart';
import './settings_screen.dart';
import '../widgets/vocabulary_display.dart';
import '../widgets/theme_picker.dart';
import '../config.dart';
import '../providers/dictionary.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final IndexController _indexManager;
  final FocusNode _focusNode = FocusNode();
  bool _isBacked = false;
  var _isLoaded = false;

  @override
  void didChangeDependencies() {
    // FocusScope.of(context).requestFocus(_focusNode);
    void loadData() async {
      await Provider.of<Dictionary>(context, listen: false).fetchAndSetData();
      _indexManager = IndexController();
      setState(() {
        _isLoaded = true;
      });
    }

    if (_isLoaded == false) {
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
    final config = Provider.of<Config>(context);
    final dictionary = Provider.of<Dictionary>(context);

    void nextVocab() {
      final success = _indexManager.next();
      if (success) {
        setState(() {});
      }
    }

    void prevVocab() {
      final success = _indexManager.back();
      if (success) {
        setState(() {
          _isBacked = true;
        });

        Future.delayed(Duration(milliseconds: 400)).then((_) {
          setState(() {
            _isBacked = false;
          });
        });
      }
    }

    void pickTheme() {
      showDialog(
          context: context,
          builder: (ctx) => ThemePicker(),
          barrierColor: Colors.black26);
    }

    void goToSettings() {
      _focusNode.unfocus();
      Navigator.of(context).pushNamed(SettingsScreen.routeName);
      FocusScope.of(context).requestFocus(_focusNode);
    }

    print('main build');
    return Title(
      color: Colors.blue,
      title: 'Remember',
      child: Scaffold(
        body: Stack(
          children: [
            GestureDetector(
              onTap: () => nextVocab(),
              child: RawKeyboardListener(
                autofocus: true,
                focusNode: _focusNode,
                onKey: (event) {
                  if (config.waitLongPressKey == false) {
                    if (event is RawKeyDownEvent) {
                      if (event.isKeyPressed(LogicalKeyboardKey.arrowRight) ||
                          event.isKeyPressed(LogicalKeyboardKey.enter) ||
                          event.isKeyPressed(LogicalKeyboardKey.space)) {
                        nextVocab();
                      } else if (event
                          .isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
                        prevVocab();
                      } else if (event.isKeyPressed(LogicalKeyboardKey.keyS) ||
                          event.isKeyPressed(LogicalKeyboardKey.escape)) {
                        goToSettings();
                      } else if (event.isKeyPressed(LogicalKeyboardKey.keyT)) {
                        pickTheme();
                      }
                    }
                  } else {
                    if (event is RawKeyUpEvent) {
                      if (event.physicalKey == PhysicalKeyboardKey.arrowRight ||
                          event.physicalKey == PhysicalKeyboardKey.enter ||
                          event.physicalKey == PhysicalKeyboardKey.space) {
                        nextVocab();
                      } else if (event.physicalKey ==
                          PhysicalKeyboardKey.arrowLeft) {
                        prevVocab();
                      } else if (event.physicalKey ==
                          PhysicalKeyboardKey.keyT) {
                        pickTheme();
                      }
                    }
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: config.theme.solid,
                    gradient: config.theme.gradient,
                    image: config.theme.isImage
                        ? DecorationImage(
                            image: NetworkImage(config.theme.imageUrl!),
                            fit: BoxFit.cover)
                        : null,
                  ),
                  child: _isLoaded
                      ? Padding(
                          padding: const EdgeInsets.all(20),
                          child: dictionary.vocabs.isEmpty
                              ? Center(
                                  child: Text(
                                  'None',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .copyWith(
                                        color: config.theme.textColor,
                                      ),
                                ))
                              : VocabularyDisplay(
                                  dictionary.at(_indexManager.value),
                                  config.theme.textColor))
                      : Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            'loading...',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(
                                    color: config.theme.textColor
                                        .withOpacity(0.25)),
                          )),
                ),
              ),
            ),
            Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: GestureDetector(
                    child: Icon(
                      Icons.nightlight,
                      color: config.onlyPrimaryWord
                          ? Colors.transparent
                          : config.theme.textColor.withOpacity(0.3),
                      size: 30,
                    ),
                    onTap: () {
                      config.toggleDarkMode();
                    },
                    onLongPress: () => pickTheme(),
                  ),
                )),
            Align(
              alignment: Alignment.bottomLeft,
              child: GestureDetector(
                onDoubleTap: () {
                  prevVocab();
                },
                child: Container(
                  color: Colors.transparent,
                  height: 37,
                  width: 37,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onDoubleTap: () => goToSettings(),
                child: Container(
                  color: Colors.transparent,
                  height: 37,
                  width: 37,
                ),
              ),
            ),
            if (_isBacked && !config.onlyPrimaryWord)
              Align(
                alignment: Alignment(0, 0.75),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: config.theme.textColor.withOpacity(0.3),
                  size: 40,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
