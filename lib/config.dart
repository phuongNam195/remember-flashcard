import 'package:flutter/material.dart';
import 'package:remember/models/my_exception.dart';

import 'models/app_theme.dart';

class Config with ChangeNotifier {
  //Singleton pattern
  static final Config _instance = Config._internal();
  factory Config() => _instance;
  Config._internal();

  static const DOMAIN_DB =
      'https://remember-antoneus-default-rtdb.asia-southeast1.firebasedatabase.app/';

  bool onlyPrimaryWord = false;
  bool waitLongPressKey = false;

  final List<AppTheme> _listAppTheme = [
    AppTheme(
        id: '01',
        name: 'Dark',
        textColor: Colors.white,
        solid: Color.fromRGBO(3, 3, 3, 1)),
    AppTheme(
        id: '02',
        name: 'Light',
        textColor: Colors.black,
        solid: Color.fromRGBO(252, 252, 252, 1)),
    AppTheme(
        id: '03',
        name: 'Sel',
        textColor: Colors.white,
        gradient: LinearGradient(colors: [
          Color.fromRGBO(86, 193, 68, 1),
          Color.fromRGBO(0, 56, 106, 1)
        ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
    AppTheme(
        id: '04',
        name: 'Dusk',
        textColor: Colors.white,
        gradient: LinearGradient(
            colors: [Color(0xffa8c0ff), Color(0xff3f2b96)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight)),
    AppTheme(
        id: '05',
        name: 'Nimvelo',
        textColor: Colors.white,
        gradient: LinearGradient(
          colors: [Color(0xff314755), Color(0xff26a0da)],
        )),
    AppTheme(
        id: '06',
        name: 'Anamisar',
        textColor: Colors.white,
        gradient: LinearGradient(
            colors: [Color(0xff9796f0), Color(0xfffbc7d4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight)),
    AppTheme(
        id: '07',
        name: 'Leafs',
        textColor: Colors.white,
        imageUrl:
            'https://images.pexels.com/photos/3573841/pexels-photo-3573841.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
    AppTheme(
        id: '08',
        name: 'Twilight',
        textColor: Colors.white,
        imageUrl:
            'https://images.pexels.com/photos/306344/pexels-photo-306344.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
    AppTheme(
        id: '09',
        name: 'Plant',
        textColor: Colors.black,
        imageUrl:
            'https://images.pexels.com/photos/305821/pexels-photo-305821.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
  ];

  int _selectedTheme = 0;
  int _currentUndarkTheme = 1;
  AppTheme get theme => _listAppTheme[_selectedTheme];
  List<AppTheme> get allThemes => [..._listAppTheme];
  int get currentThemeIndex => _selectedTheme;
  // bool get isDarkTheme => _listAppTheme[_selectedTheme].textColor == Colors.white;
  bool get isDarkMode => _selectedTheme == 0;

  void toggleOnlyPrimaryWord() {
    onlyPrimaryWord = !onlyPrimaryWord;
    notifyListeners();
  }

  void toggleWaitLongPressKey() {
    waitLongPressKey = !waitLongPressKey;
    notifyListeners();
  }

  void toggleDarkMode() {
    if (_selectedTheme != 0) {
      _selectedTheme = 0;
    } else {
      _selectedTheme = _currentUndarkTheme;
    }
    notifyListeners();
  }

  void changeTheme(int index) {
    if (index < 0 || index >= _listAppTheme.length)
      throw MyException('Index out of bound!');
    _selectedTheme = index;
    if (index != 0) {
      _currentUndarkTheme = index;
    } else {
      _currentUndarkTheme = 1;
    }
    notifyListeners();
  }
}
