import 'package:flutter/material.dart';

import '../team_list/modify_team_member_dialog.dart';

class DismissableReorderableListView<T> extends StatelessWidget {
  final int itemCount;
  final void Function(int, int) onReorder;
  final List<T> items;
  final String itemKeyPrefix;
  final String Function(T) extractNameFromItem;
  final bool Function(T)? extractItemIsEnabledState;
  final void Function(DismissDirection, int) onItemDismissed;
  final void Function(T) onItemEnableToggle;
  final bool withEnableToggleOption;
  final void Function(T)? onItemTapped;
  final void Function(T, String) onModifyItem;
  final String modifyItemDialogText;

  const DismissableReorderableListView({ 
    super.key, 
    required this.itemKeyPrefix,
    required this.itemCount,
    required this.onReorder,
    required this.items,
    required this.extractNameFromItem,
    required this.onItemDismissed,
    required this.onItemEnableToggle,
    required this.onModifyItem,
    required this.modifyItemDialogText,
    this.withEnableToggleOption = true,
    this.onItemTapped,
    this.extractItemIsEnabledState,
  });

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;

    return ReorderableListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          T item = items[index];

          return ReorderableDelayedDragStartListener(
            key: Key('${itemKeyPrefix}-${extractNameFromItem(item)}'),
            index: index,
            child: Dismissible(
              key: Key(extractNameFromItem(item)),
              direction: DismissDirection.startToEnd,
              background: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.red),
                alignment: Alignment.centerLeft,
                child: const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
              ),
              onDismissed: (direction) => onItemDismissed(direction, index),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10.0),
                  onTap: onItemTapped != null ? () => onItemTapped!(item) : null, // Add onTap action if necessary
                  child: Opacity(
                    opacity: 
                        extractItemIsEnabledState == null ?
                        1.0 :
                          extractItemIsEnabledState != null && extractItemIsEnabledState!(item) ?
                          1.0 :
                          0.3,
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(extractNameFromItem(item))),
                          Visibility(
                            visible: withEnableToggleOption,
                            child: IconButton(
                              icon: Icon(extractItemIsEnabledState != null && extractItemIsEnabledState!(item) ? Icons.done : Icons.do_not_disturb),
                              onPressed: () => onItemEnableToggle(item),
                            )
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ModifyListItemDialog<T>(
                                    items: items,
                                    title: modifyItemDialogText,
                                    actionButtonText: 'Edit',
                                    extractItemName: extractNameFromItem,
                                    onActionButtonPressed: (newName) => onModifyItem(item, newName),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        onReorder: (int oldIndex, int newIndex) => onReorder(oldIndex, newIndex),
      );
  }
}