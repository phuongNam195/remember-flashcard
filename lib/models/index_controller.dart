// Đống hổ lốn

import 'dart:math';

import '../providers/dictionary.dart';

class IndexController {
  //Singleton pattern
  static final IndexController _instance = IndexController._internal();
  factory IndexController() => _instance;
  IndexController._internal() {
    next();
  }

  final List<String> _vocabIDLog = [];
  int _point = -1;
  late int value;

  String get currentId => _vocabIDLog[_point];
  int get point => _point;
  List<String> get log => _vocabIDLog;

  bool next() {
    Dictionary dictionary = Dictionary();
    if (dictionary.length <= 1) return false;

    _point++;
    while (_point < _vocabIDLog.length) {
      final id = _vocabIDLog[_point];
      value = dictionary.findIndexById(id);
      if (value != -1)
        return true;
      else {
        _vocabIDLog.removeAt(_point);
      }
    }

    Random rng = Random();
    while (true) {
      value = rng.nextInt(dictionary.length);
      final id = dictionary.at(value).id;
      if (_checkRecentDuplicate(id) == false) {
        _vocabIDLog.add(id);
        return true;
      }
    }
  }

  bool back() {
    Dictionary dictionary = Dictionary();
    while (_point > 0) {
      _point--;
      final id = _vocabIDLog[_point];
      final index = dictionary.findIndexById(id);
      if (index != -1) {
        value = index;
        return true;
      } else {
        _vocabIDLog.removeAt(_point);
      }
    }
    return false;
  }

  bool _checkRecentDuplicate(String id) {
    Dictionary dictionary = Dictionary();
    int maxRecentItems = 5;
    if (dictionary.length <= 5) maxRecentItems = 1;
    int i = _point - 1;
    int count = 0;
    while (i >= 0 && count < maxRecentItems) {
      if (_vocabIDLog[i] == id) return true;
      i--;
      count++;
    }
    return false;
  }
}
