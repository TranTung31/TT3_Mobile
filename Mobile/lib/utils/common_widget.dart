import 'package:flutter/material.dart';

import 'color_utils.dart';

class CommonWidget {
  static Widget customDropDownSelectedItem(BuildContext context, String? item,
      {String? hint, bool enable = true}) {
    if (item == null || item.isEmpty) {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          enabled: enable,
          // tileColor: ColorUtils.gray.withOpacity(0.4),
          // this does not work - throws 404 error
          // backgroundImage: NetworkImage(item.avatar ?? ''),
          title: Text(
            hint ?? "",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }

    return Container(
      child: ListTile(
        enabled: enable,
        contentPadding: EdgeInsets.all(0),
        tileColor: enable ? Colors.white : ColorUtils.gray.withOpacity(0.4),
        // this does not work - throws 404 error
        // backgroundImage: NetworkImage(item.avatar ?? ''),
        title: Text(
          item,
          style: (item.isEmpty
              ? Theme.of(context).textTheme.bodyMedium
              : Theme.of(context).textTheme.bodyLarge)?.copyWith(
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  static Widget customDropdownPopupItem(
      BuildContext context, String? item, bool isSelected, bool unselectable) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color:
            isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(8.0), // Thêm góc tròn cho container
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0), // Clip để cắt bỏ phần thừa
        child: ListTile(
          selected: false, // Tắt selection mặc định
          selectedTileColor: Colors.transparent, // Làm trong suốt màu selection
          title: Text(
            item ?? '',
            style: unselectable
                ? Theme.of(context).textTheme.bodyLarge
                : Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}
