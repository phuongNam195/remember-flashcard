import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';

import '../models/app_theme.dart';
import '../config.dart';
import './horizontal_card_pager.dart';

class ThemeItem extends CardItem {
  final AppTheme _theme;
  final BuildContext _context;

  ThemeItem(this._theme, this._context);

  @override
  Widget? buildWidget(double diffPosition) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: FittedBox(
          child: Text(
            _theme.name,
            style: Theme.of(_context)
                .textTheme
                .headline1!
                .copyWith(color: _theme.textColor, fontSize: 16),
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: _theme.solid,
        gradient: _theme.gradient,
        image: _theme.isImage
            ? DecorationImage(
                image: NetworkImage(_theme.imageUrl!), fit: BoxFit.cover)
            : null,
      ),
    );
  }
}

class ThemePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final config = Provider.of<Config>(context, listen: false);
    final themes = config.allThemes;
    final items = themes.map((theme) => ThemeItem(theme, context)).toList();
    return Container(
      height: 200,
      alignment: Alignment.bottomCenter,
      child: HorizontalCardPager(
        items: items,
        onPageChanged: (index) {
          config.changeTheme(index.round());
        },
        onSelectedItem: (index) {
          Navigator.of(context).pop();
        },
        initialPage: config.currentThemeIndex,
      ),
    );
  }
}
