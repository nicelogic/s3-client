import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final String _label;
  final IconData? _iconData;
  final EdgeInsetsGeometry? _padding;
  final bool _isNeedChevronRight;
  final String _badgeValue;

  const ItemCard(
      {Key? key,
      required String label,
      IconData? iconData,
      EdgeInsetsGeometry? padding,
      bool isNeedChevronRight = true,
      bool isLabelCenter = false,
      String badgeValue = ''})
      : _label = label,
        _padding = padding,
        _iconData = iconData,
        _badgeValue = badgeValue,
        _isNeedChevronRight = isNeedChevronRight,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Card(
                  child: Container(
                      padding:
                          _padding ?? const EdgeInsets.fromLTRB(1, 20, 15, 20),
                      child: Row(children: <Widget>[
                        const SizedBox(width: 20),
                        if (_iconData != null)
                          Icon(
                            _iconData,
                          ),
                        const SizedBox(width: 20),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                              Text(_label,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    // fontWeight: FontWeight.w500
                                  ))
                            ])),
                        Badge(
                          isLabelVisible:
                              _badgeValue.isNotEmpty && _badgeValue != '0',
                          label: Text(
                            _badgeValue,
                          ),
                        ),
                        if (_isNeedChevronRight) const Icon(Icons.chevron_right)
                      ])))
            ]);
  }
}
