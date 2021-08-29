import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/dictionary.dart';
import '../models/vocabulary.dart';
import '../config.dart';

class EditVocabularyScreen extends StatefulWidget {
  static const routeName = '/settings/my-dictionary/edit-vocabulary';

  @override
  _EditVocabularyScreenState createState() => _EditVocabularyScreenState();
}

class _EditVocabularyScreenState extends State<EditVocabularyScreen> {
  final _form = GlobalKey<FormState>();

  final _viFocusNode = FocusNode();
  final _en2FocusNode = FocusNode();
  final _vi2FocusNode = FocusNode();
  final _extraFocusNode = FocusNode();

  var _edittedVocab = Vocabulary(id: '', en: '', vi: '');
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final arguments = ModalRoute.of(context)!.settings.arguments;
      if (arguments != null) {
        final vocabId = arguments as String;
        _edittedVocab =
            Provider.of<Dictionary>(context, listen: false).findById(vocabId);
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _en2FocusNode.dispose();
    _viFocusNode.dispose();
    _vi2FocusNode.dispose();
    _extraFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) return;
    _form.currentState!.save();
    if (_edittedVocab.id != '') {
      await Provider.of<Dictionary>(context, listen: false)
          .updateVocab(_edittedVocab.id, _edittedVocab);
    } else {
      await Provider.of<Dictionary>(context, listen: false)
          .addVocab(_edittedVocab);
    }
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<Config>(context, listen: false);
    final textColor = config.theme.textColor;

    InputDecoration _inputDecoration(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            fontFamily: 'Sarabun',
            color: textColor.withOpacity(0.7),
            fontWeight: FontWeight.w500),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: textColor, width: 1)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: config.isDarkMode ? Colors.amber : Colors.orange,
                width: 1.5)),
      );
    }

    return Scaffold(
        backgroundColor: config.isDarkMode ? Color(0xff2f2b53) : null,
        appBar: AppBar(
          title: Text(
            'Edit vocabulary',
            style: TextStyle(fontFamily: 'Sarabun'),
          ),
          backgroundColor: config.isDarkMode ? Color(0xff232245) : null,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: config.isDarkMode ? Colors.white : Color(0xff2f2b53),
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                icon: Icon(Icons.done, color: Colors.white),
                onPressed: () {
                  _saveForm();
                },
              ),
            ),
          ],
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width > 550 ? 550 : null,
            child: Form(
              key: _form,
              child: ListView(
                children: [
                  TextFormField(
                    autofocus: true,
                    initialValue: _edittedVocab.en,
                    style: TextStyle(fontFamily: 'Sarabun', color: textColor),
                    decoration: _inputDecoration('English'),
                    cursorColor:
                        config.isDarkMode ? Colors.amber : Colors.orange,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_viFocusNode);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Can\'t be empty!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _edittedVocab = Vocabulary(
                        id: _edittedVocab.id,
                        en: value!,
                        vi: _edittedVocab.vi,
                        en2: _edittedVocab.en2,
                        vi2: _edittedVocab.vi2,
                        extra: _edittedVocab.extra,
                      );
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    initialValue: _edittedVocab.vi,
                    style: TextStyle(fontFamily: 'Sarabun', color: textColor),
                    decoration: _inputDecoration('Vietnamese'),
                    cursorColor:
                        config.isDarkMode ? Colors.amber : Colors.orange,
                    textInputAction: TextInputAction.next,
                    focusNode: _viFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_en2FocusNode);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Can\'t be empty!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _edittedVocab = Vocabulary(
                        id: _edittedVocab.id,
                        en: _edittedVocab.en,
                        vi: value!,
                        en2: _edittedVocab.en2,
                        vi2: _edittedVocab.vi2,
                        extra: _edittedVocab.extra,
                      );
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    initialValue: _edittedVocab.en2,
                    style: TextStyle(fontFamily: 'Sarabun', color: textColor),
                    decoration: _inputDecoration('English 2'),
                    cursorColor:
                        config.isDarkMode ? Colors.amber : Colors.orange,
                    textInputAction: TextInputAction.next,
                    focusNode: _en2FocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_vi2FocusNode);
                    },
                    onSaved: (value) {
                      _edittedVocab = Vocabulary(
                        id: _edittedVocab.id,
                        en: _edittedVocab.en,
                        vi: _edittedVocab.vi,
                        en2: value!,
                        vi2: _edittedVocab.vi2,
                        extra: _edittedVocab.extra,
                      );
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    initialValue: _edittedVocab.vi2,
                    style: TextStyle(fontFamily: 'Sarabun', color: textColor),
                    decoration: _inputDecoration('Vietnamese 2'),
                    cursorColor:
                        config.isDarkMode ? Colors.amber : Colors.orange,
                    textInputAction: TextInputAction.next,
                    focusNode: _vi2FocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_extraFocusNode);
                    },
                    onSaved: (value) {
                      _edittedVocab = Vocabulary(
                        id: _edittedVocab.id,
                        en: _edittedVocab.en,
                        vi: _edittedVocab.vi,
                        en2: _edittedVocab.en2,
                        vi2: value!,
                        extra: _edittedVocab.extra,
                      );
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    initialValue: _edittedVocab.extra,
                    style: TextStyle(fontFamily: 'Sarabun', color: textColor),
                    decoration: _inputDecoration('Extra'),
                    cursorColor:
                        config.isDarkMode ? Colors.amber : Colors.orange,
                    textInputAction: TextInputAction.done,
                    focusNode: _extraFocusNode,
                    onFieldSubmitted: (_) {
                      _saveForm();
                    },
                    onSaved: (value) {
                      _edittedVocab = Vocabulary(
                        id: _edittedVocab.id,
                        en: _edittedVocab.en,
                        vi: _edittedVocab.vi,
                        en2: _edittedVocab.en2,
                        vi2: _edittedVocab.vi2,
                        extra: value!,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
