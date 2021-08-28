import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/local_storage.dart';
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
  List<Vocabulary> _archives = [];

  List<String> _waitForAddVocabs = [];
  List<String> _waitForUpdateVocabs = [];
  List<String> _waitForDeleteVocabs = [];

  List<Vocabulary> get vocabs => [..._vocabs];
  List<Vocabulary> get archives => [..._archives];
  int get length => _vocabs.length;
  Vocabulary at(int index) => _vocabs[index];
  bool isArchived(String id) =>
      _archives.indexWhere((vocab) => vocab.id == id) != -1;

  Future<void> loadData() async {
    await importNonVocabsFromLocal();
    final successful = await fetchAndSetData();
    if (!successful) {
      await importVocabsFromLocal();
    } else {
      exportVocabsToLocal();
    }
  }

  Future<bool> importVocabsFromLocal() async {
    final fileName = 'vocabularies.json';
    try {
      final data = await Storage.read(fileName);
      final Map<String, dynamic> extractedData = json.decode(data);
      extractedData
          .forEach((key, value) => _vocabs.add(Vocabulary.fromMap(key, value)));
      return true;
    } catch (error) {
      print('Could not read \'$fileName\' <- ' + error.toString());
    }
    return false;
  }

  Future<bool> importNonVocabsFromLocal() async {
    final fileName = 'non_vocabs.json';
    try {
      final data = await Storage.read(fileName);
      final Map<String, dynamic> extractedData = json.decode(data);
      extractedData['archives'].forEach(
          (key, value) => _archives.add(Vocabulary.fromMap(key, value)));
      extractedData['waitAdd']
          .forEach((_, value) => _waitForAddVocabs.add(value));
      extractedData['waitUpd']
          .forEach((_, value) => _waitForUpdateVocabs.add(value));
      extractedData['waitDel']
          .forEach((_, value) => _waitForDeleteVocabs.add(value));
      return true;
    } catch (error) {
      print('Could not read \'$fileName\' <- ' + error.toString());
    }
    return false;
  }

  Future<bool> exportVocabsToLocal() async {
    final fileName = 'vocabularies.json';
    try {
      final mapVocabs =
          Map.fromIterable(_vocabs, key: (v) => v.id, value: (v) => v.toMap());
      final dataVocabs = JsonEncoder.withIndent('\t').convert(mapVocabs);
      await Storage.write(fileName, dataVocabs);
      return true;
    } catch (error) {
      print('Could not write \'$fileName\' <- ' + error.toString());
    }
    return false;
  }

  Future<bool> exportNonVocabsToLocal() async {
    final fileName = 'non_vocabs.json';
    try {
      final mapArchives = Map.fromIterable(_archives,
          key: (v) => v.id, value: (v) => v.toMap());
      final mapW4Add = Map.fromIterables(
          List<String>.generate(_waitForAddVocabs.length, (i) => i.toString()),
          _waitForAddVocabs);
      final mapW4Upd = Map.fromIterables(
          List<String>.generate(
              _waitForUpdateVocabs.length, (i) => i.toString()),
          _waitForUpdateVocabs);
      final mapW4Del = Map.fromIterables(
          List<String>.generate(
              _waitForDeleteVocabs.length, (i) => i.toString()),
          _waitForDeleteVocabs);
      final mapNonVocabs = {
        'archives': mapArchives,
        'waitAdd': mapW4Add,
        'waitUpd': mapW4Upd,
        'waitDel': mapW4Del,
      };
      final dataNonVocabs = JsonEncoder.withIndent('\t').convert(mapNonVocabs);
      await Storage.write('non_vocabs.json', dataNonVocabs);
      return true;
    } catch (error) {
      print('Could not write \'$fileName\' <- ' + error.toString());
    }
    return false;
  }

  Future<bool> fetchAndSetData() async {
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
      final archiveIDs = _archives.map((vocab) => vocab.id).toList();
      _vocabs = [];
      _archives = [];
      loadedDict.forEach((vocab) {
        if (archiveIDs.contains(vocab.id)) {
          _archives.add(vocab);
        } else {
          _vocabs.add(vocab);
        }
      });
      // notifyListeners();
      print('fetched');
      return true;
    } catch (error) {
      print(error);
    }
    return false;
  }

  Future<void> syncWithServer() async {
    // // delete duplicate elements
    // _waitForAddVocabs = _waitForAddVocabs.toSet().toList();
    // _waitForDeleteVocabs = _waitForDeleteVocabs.toSet().toList();
    // _waitForUpdateVocabs = _waitForUpdateVocabs.toSet().toList();
    // // delete 'deleted elements'
    // int i = 0;
    // while (i < _waitForDeleteVocabs.length) {
    //   final id = _waitForDeleteVocabs[i];
    //   final j = _waitForAddVocabs.indexOf(id);
    //   final k = _waitForUpdateVocabs.indexOf(id);
    //   if (j != -1) {
    //     _waitForAddVocabs.removeAt(j);
    //     _waitForDeleteVocabs.removeAt(i);
    //   }
    //   if (k != -1) {
    //     _waitForUpdateVocabs.removeAt(k);
    //   }
    //   i++;
    // }
    // // merge 'added element' vs. 'updated element'
    // i = 0;
    // while (i < _waitForAddVocabs.length) {
    //   final id = _waitForAddVocabs[i];
    //   final j = _waitForUpdateVocabs.indexOf(id);
    //   if (j != -1) {
    //     _waitForUpdateVocabs.removeAt(j);
    //   }
    //   i++;
    // }

    try {
      // ADD
      final urlForAdd = Uri.parse(Config.DOMAIN_DB + 'dictionary.json');
      while (_waitForAddVocabs.length > 0) {
        final id = _waitForAddVocabs.last;
        final vocab = findById(id);
        final response =
            await http.post(urlForAdd, body: json.encode(vocab.toMap()));
        if (response.statusCode < 400) {
          final realId = json.decode(response.body)['name'];
          final index = findIndexById(id);
          if (isArchived(id)) {
            _archives[index] = _archives[index].copyWith(id: realId);
          } else {
            _vocabs[index] = _vocabs[index].copyWith(id: realId);
          }
          _waitForAddVocabs.removeLast();
        } else {
          throw MyException('Could not sync with server!');
        }
      }

      // UPDATE
      while (_waitForUpdateVocabs.length > 0) {
        final id = _waitForUpdateVocabs.last;
        final vocab = findById(id);
        final url = Uri.parse(Config.DOMAIN_DB + 'dictionary/$id.json');
        final response =
            await http.patch(url, body: json.encode(vocab.toMap()));
        if (response.statusCode < 400) {
          _waitForAddVocabs.removeLast();
        } else {
          throw MyException('Could not sync with server!');
        }
      }

      // DELETE
      while (_waitForDeleteVocabs.length > 0) {
        final id = _waitForDeleteVocabs.last;
        final url = Uri.parse(Config.DOMAIN_DB + 'dictionary/$id.json');
        final response = await http.delete(url);
        if (response.statusCode < 400) {
          _waitForAddVocabs.removeLast();
        } else {
          throw MyException('Could not sync with server!');
        }
      }
      exportNonVocabsToLocal();
      print('synced');
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
      _waitForAddVocabs.add(tempId);
      exportNonVocabsToLocal();
      print('Could not add vocabulary to server <- ' + error.toString());
    } finally {
      exportVocabsToLocal();
    }
  }

  Future<void> updateVocab(String id, Vocabulary newVocab) async {
    final index = findIndexById(id);
    if (index == -1) return;
    if (isArchived(id)) {
      _archives[index] = newVocab;
    } else {
      _vocabs[index] = newVocab;
      final indexController = IndexController();
      if (indexController.currentId == id) {
        notifyListeners();
      }
    }
    final url = Uri.parse(Config.DOMAIN_DB + 'dictionary/$id.json');
    try {
      final response =
          await http.patch(url, body: json.encode(newVocab.toMap()));
      if (response.statusCode >= 400) {
        throw MyException('HTTP PATCH status code >= 400');
      }
    } catch (error) {
      if (!_waitForAddVocabs.contains(id)) {
        _waitForUpdateVocabs.add(id);
      }
      exportNonVocabsToLocal();
      print('Could not update vocabulary to server <- ' + error.toString());
    } finally {
      exportVocabsToLocal();
    }
  }

  Future<void> deleteVocab(String id) async {
    int index = findIndexById(id);
    if (index == -1) return;
    if (isArchived(id)) {
      _archives.removeAt(index);
    } else {
      _vocabs.removeAt(index);
      final indexController = IndexController();
      if (indexController.currentId == id) {
        indexController.next();
        notifyListeners();
      }
    }
    final url = Uri.parse(Config.DOMAIN_DB + 'dictionary/$id.json');
    try {
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        throw MyException('HTTP DELETE status code >= 400');
      }
    } catch (error) {
      if (_waitForAddVocabs.contains(id)) {
        _waitForAddVocabs.removeWhere((vocabId) => vocabId == id);
      } else {
        _waitForDeleteVocabs.add(id);
      }
      exportNonVocabsToLocal();
      print('Could not delete vocabulary to server <- ' + error.toString());
    } finally {
      exportVocabsToLocal();
    }
  }

  void toggleArchived(String id) {
    if (isArchived(id)) {
      final index = _archives.indexWhere((vocab) => vocab.id == id);
      _vocabs.add(_archives[index]);
      _archives.removeAt(index);
    } else {
      final index = _vocabs.indexWhere((vocab) => vocab.id == id);
      _archives.add(_vocabs[index]);
      _vocabs.removeAt(index);
      final indexController = IndexController();
      if (indexController.currentId == id) {
        indexController.next();
        notifyListeners();
      }
    }
    exportVocabsToLocal();
    exportNonVocabsToLocal();
  }

  Vocabulary findById(String id) {
    return _vocabs.firstWhere((vocab) => vocab.id == id, orElse: () {
      return _archives.firstWhere((vocab) => vocab.id == id, orElse: () {
        throw MyException('ID not found! ($id)');
      });
    });
  }

  int findIndexById(String id) {
    int index = _vocabs.indexWhere((vocab) => vocab.id == id);
    if (index != -1) return index;
    return _archives.indexWhere((vocab) => vocab.id == id);
  }
}
