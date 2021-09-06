import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/dictionary.dart';
import '../screens/edit_vocabulary_screen.dart';

class VocabularyItem extends StatelessWidget {
  final String id;
  final String title;
  final Color textColor;
  final Function? onChanged;

  VocabularyItem({
    required this.id,
    required this.title,
    required this.textColor,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width > 550 ? 550 : null,
        child: Dismissible(
          key: ValueKey(id),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                child: ListTile(
                  title: Text(
                    title,
                    style: TextStyle(
                        fontFamily: 'Sarabun',
                        color: textColor,
                        fontWeight: FontWeight.w300),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.grey[400],
                    ),
                    splashColor: Colors.white.withOpacity(0.05),
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(EditVocabularyScreen.routeName,
                              arguments: id)
                          .then((isChanged) {
                        if (isChanged as bool && onChanged != null) {
                          onChanged!();
                        }
                      });
                    },
                  ),
                ),
              ),
              Divider(
                color: Colors.black54,
                height: 0,
              ),
            ],
          ),
          background: Container(
            color: Color(0xffff2442),
            child: Icon(Icons.delete, color: Colors.white),
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              Provider.of<Dictionary>(context, listen: false).deleteVocab(id);
            }
          },
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              return await showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: Text(
                          'Confirm',
                          style: TextStyle(
                              fontFamily: 'Sarabun',
                              fontWeight: FontWeight.w500),
                        ),
                        content: Text(
                          'Delete this vocabulary?',
                          style: TextStyle(
                              fontFamily: 'Sarabun',
                              fontWeight: FontWeight.w300),
                        ),
                        actions: [
                          TextButton(
                            child: Text(
                              'No',
                              style: TextStyle(
                                  fontFamily: 'Sarabun',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          TextButton(
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                  fontFamily: 'Sarabun',
                                  color: Color(0xffff2442),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      ));
            }
          },
        ),
      ),
    );
  }
}
