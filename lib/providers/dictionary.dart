import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/index_controller.dart';
import '../models/my_exception.dart';
import '../config.dart';
import '../models/vocabulary.dart';

class Dictionary with ChangeNotifier {
  //Singleton pattern
  static final Dictionary _instance = Dictionary._internal();
  factory Dictionary() => _instance;
  Dictionary._internal();

  List<Vocabulary> _vocabs = [];

  List<Vocabulary> get vocabs => [..._vocabs];
  int get length => _vocabs.length;
  Vocabulary at(int index) => _vocabs[index];

  Future<void> fetchAndSetData() async {
    final url = Uri.parse(Config.DOMAIN_DB + 'dictionary.json');
    try {
      final List<Vocabulary> loadedDict = [];
      final response = await http.get(url);
      if (response.statusCode > 400) {
        throw MyException('Not connected');
      }
      final Map<String, dynamic> extractedData = json.decode(response.body);
      extractedData.forEach((vocabId, vocabData) {
        loadedDict.add(Vocabulary.fromMap(vocabId, vocabData));
      });
      _vocabs = [];
      loadedDict.forEach((vocab) {
        _vocabs.add(vocab);
      });
      // notifyListeners();
      print('fetched');
    } catch (error) {
      print(error);
    }
  }

  Future<void> addVocab(Vocabulary newVocab) async {
    final url = Uri.parse(Config.DOMAIN_DB + 'dictionary.json');
    try {
      final response =
          await http.post(url, body: json.encode(newVocab.toMap()));
      if (response.statusCode >= 400) {
        throw MyException('HTTP POST status code >= 400');
      }
      _vocabs.add(newVocab.copyWith(id: json.decode(response.body)['name']));
    } catch (error) {
      String tempId = DateTime.now().toString();
      _vocabs.add(newVocab.copyWith(id: tempId));
      print('Could not add vocabulary to server: ' + error.toString());
    }
  }

  Future<void> updateVocab(String id, Vocabulary newVocab) async {
    final index = findIndexById(id);
    if (index == -1) return;
    _vocabs[index] = newVocab;
    final indexController = IndexController();
    if (indexController.currentId == id) {
      notifyListeners();
    }
    final url = Uri.parse(Config.DOMAIN_DB + 'dictionary/$id.json');
    try {
      final response =
          await http.patch(url, body: json.encode(newVocab.toMap()));
      if (response.statusCode >= 400) {
        throw MyException('HTTP PATCH status code >= 400');
      }
    } catch (error) {
      print('Could not update vocabulary to server: ' + error.toString());
    }
  }

  Future<void> deleteVocab(String id) async {
    int index = findIndexById(id);
    if (index == -1) return;
    _vocabs.removeAt(index);
    final indexController = IndexController();
    if (indexController.currentId == id) {
      indexController.next();
      notifyListeners();
    }
    final url = Uri.parse(Config.DOMAIN_DB + 'dictionary/$id.json');
    try {
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        throw MyException('HTTP DELETE status code >= 400');
      }
    } catch (error) {
      print('Could not delete vocabulary to server: ' + error.toString());
    }
  }

  Vocabulary findById(String id) {
    return _vocabs.firstWhere((vocab) => vocab.id == id, orElse: () {
      throw MyException('ID not found!');
    });
  }

  int findIndexById(String id) {
    return _vocabs.indexWhere((vocab) => vocab.id == id);
  }
}
