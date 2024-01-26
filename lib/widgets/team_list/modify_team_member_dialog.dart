import 'package:flutter/material.dart';

class ModifyListItemDialog<T> extends StatefulWidget {
  final List<T> items;
  final String title;
  final String actionButtonText;
  final String Function(T) extractItemName;
  final void Function(String) onActionButtonPressed;

  const ModifyListItemDialog(
    {
      Key? key,
      required this.title,
      required this.actionButtonText,
      required this.onActionButtonPressed,
      required this.extractItemName,
      required this.items
    }) : super(key: key);

  @override
  _ModifyListItemDialogState<T> createState() => _ModifyListItemDialogState<T>();
}

class _ModifyListItemDialogState<T> extends State<ModifyListItemDialog<T>> {
  final TextEditingController _controller = TextEditingController();
  bool _showEmptyError = false;
  bool _showNameExistsError = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          SizedBox(height: 8.0),
          Text(
            _showEmptyError
                ? 'Please enter a non empty name'
                : _showNameExistsError
                    ? 'Please enter a non-existing name'
                    : '',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            String newMemberName = _controller.text.trim();
            String lowerCaseMemberName = newMemberName.toLowerCase();

            setState(() {
              _showEmptyError = newMemberName.isEmpty;
              _showNameExistsError =
                  newMemberName.isNotEmpty
                  && widget.items.any((e) => widget.extractItemName(e).toLowerCase() == lowerCaseMemberName);
            });

            if (!_showEmptyError && !_showNameExistsError) {
              widget.onActionButtonPressed(newMemberName);
              Navigator.pop(context);
            }
          },
          child: Text(widget.actionButtonText),
        ),
      ],
    );
  }
}
