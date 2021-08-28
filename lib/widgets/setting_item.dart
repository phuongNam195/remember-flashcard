import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum SettingType {
  navigate,
  toggle,
}

class SettingItem extends StatefulWidget {
  final String title;
  final Color color;
  final IconData leadingIcon;
  final Color leadingColor;
  final SettingType type;
  final Function? onTap;
  final bool? value;
  final Function? onToggled;

  SettingItem({
    required this.title,
    required this.color,
    required this.leadingIcon,
    required this.leadingColor,
    required this.type,
    this.onTap,
    this.value,
    this.onToggled,
  });
  @override
  _SettingItemState createState() => _SettingItemState();
}

class _SettingItemState extends State<SettingItem> {
  bool switchValue = false;

  @override
  void initState() {
    if (widget.value != null) switchValue = widget.value!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.black.withOpacity(0.05),
      onTap: () {
        if (widget.type == SettingType.navigate) {
          widget.onTap!();
        } else {
          setState(() {
            switchValue = !switchValue;
          });
          widget.onToggled!();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // color: Color(0xff1ca4eb).withOpacity(0.1)),
                    color: widget.leadingColor.withOpacity(0.1)),
                child: Icon(
                  //Icons.book,
                  widget.leadingIcon,
                  size: 20,
                  // color: Color(0xff1ca4eb).withOpacity(0.8),
                  color: widget.leadingColor.withOpacity(0.8),
                )),
            SizedBox(width: 20),
            Text(
              widget.title,
              style: TextStyle(
                  fontFamily: 'Sarabun',
                  color: widget.color,
                  fontSize: 19,
                  fontWeight: FontWeight.w500),
            ),
            Spacer(),
            Container(
              height: 30,
              width: 70,
              alignment: Alignment.center,
              child: widget.type == SettingType.navigate
                  ? Icon(
                      Icons.chevron_right,
                      size: 30,
                      color: widget.color,
                    )
                  : CupertinoSwitch(
                      value: switchValue,
                      onChanged: (_) {
                        setState(() {
                          switchValue = !switchValue;
                        });
                        widget.onToggled!();
                      }),
            ),
          ],
        ),
      ),
    );
  }
}
