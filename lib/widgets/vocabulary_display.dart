import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../models/vocabulary.dart';

class VocabularyDisplay extends StatelessWidget {
  final Vocabulary _vocab;
  final Color _textColor;

  VocabularyDisplay(this._vocab, this._textColor);

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      if (_vocab.vi == '~') {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: (MediaQuery.of(context).size.height - 10) * 2 / 7,
              child: FittedBox(
                alignment: Alignment.bottomLeft,
                child: Text(
                  _vocab.en,
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(color: _textColor),
                ),
              ),
            ),
            SizedBox(
              height: 50,
              child: FittedBox(
                child: Text(
                  '~',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: _textColor, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              height: (MediaQuery.of(context).size.height - 10) * 2 / 7,
              child: FittedBox(
                alignment: Alignment.topLeft,
                child: Text(
                  _vocab.en2!,
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(color: _textColor),
                ),
              ),
            ),
          ],
        );
      }

      final onlyPrimaryWord = Provider.of<Config>(context).onlyPrimaryWord;
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(flex: 1),
            (_vocab.en2 != null && !onlyPrimaryWord)
                ? Expanded(
                    flex: 1,
                    child: FittedBox(
                      child: Text(
                        _vocab.en2!,
                        style: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(color: _textColor.withOpacity(0.3)),
                      ),
                    ),
                  )
                : Spacer(),
            Expanded(
              flex: 2,
              child: FittedBox(
                alignment: Alignment.bottomLeft,
                child: Text(
                  _vocab.en,
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(color: _textColor),
                ),
              ),
            ),
            SizedBox(height: 10),
            !onlyPrimaryWord
                ? Expanded(
                    flex: 1,
                    child: FittedBox(
                      child: Text(
                        _vocab.vi,
                        style: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(color: _textColor.withOpacity(0.3)),
                      ),
                    ),
                  )
                : Spacer(),
            (_vocab.vi2 != null && !onlyPrimaryWord)
                ? Expanded(
                    flex: 1,
                    child: FittedBox(
                      child: Text(
                        _vocab.vi2!,
                        style: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(color: _textColor.withOpacity(0.3)),
                      ),
                    ),
                  )
                : Spacer(),
            Spacer(flex: 1),
            (_vocab.extra != null && !onlyPrimaryWord)
                ? Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        _vocab.extra!,
                        style: Theme.of(context)
                            .textTheme
                            .headline3!
                            .copyWith(color: _textColor.withOpacity(0.2)),
                      ),
                    ),
                  )
                : Spacer(),
          ]);
    } else {
      if (_vocab.vi == '~') {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: (MediaQuery.of(context).size.height - 10) * 2 / 11,
              child: FittedBox(
                alignment: Alignment.bottomLeft,
                child: Text(
                  _vocab.en,
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(color: _textColor),
                ),
              ),
            ),
            SizedBox(
              height: 50,
              child: FittedBox(
                child: Text(
                  '~',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: _textColor, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              height: (MediaQuery.of(context).size.height - 10) * 2 / 11,
              child: FittedBox(
                alignment: Alignment.topLeft,
                child: Text(
                  _vocab.en2!,
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(color: _textColor),
                ),
              ),
            ),
          ],
        );
      }

      final onlyPrimaryWord = Provider.of<Config>(context).onlyPrimaryWord;
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
          children: [
            Spacer(flex: 3),
            (_vocab.en2 != null && !onlyPrimaryWord)
                ? Expanded(
                    flex: 1,
                    child: FittedBox(
                      child: Text(
                        _vocab.en2!,
                        style: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(color: _textColor.withOpacity(0.3)),
                      ),
                    ),
                  )
                : Spacer(),
            Expanded(
              flex: 2,
              child: FittedBox(
                alignment: Alignment.bottomLeft,
                child: Text(
                  _vocab.en,
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(color: _textColor),
                ),
              ),
            ),
            SizedBox(height: 10),
            !onlyPrimaryWord
                ? Expanded(
                    flex: 1,
                    child: FittedBox(
                      child: Text(
                        _vocab.vi,
                        style: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(color: _textColor.withOpacity(0.3)),
                      ),
                    ),
                  )
                : Spacer(),
            (_vocab.vi2 != null && !onlyPrimaryWord)
                ? Expanded(
                    flex: 1,
                    child: FittedBox(
                      child: Text(
                        _vocab.vi2!,
                        style: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(color: _textColor.withOpacity(0.3)),
                      ),
                    ),
                  )
                : Spacer(),
            Spacer(flex: 3),
            (_vocab.extra != null && !onlyPrimaryWord)
                ? Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        _vocab.extra!,
                        style: Theme.of(context)
                            .textTheme
                            .headline3!
                            .copyWith(color: _textColor.withOpacity(0.2)),
                      ),
                    ),
                  )
                : Spacer(),
          ]);
    }
  }
}
