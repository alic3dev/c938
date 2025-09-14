#include <menus/menu_item.h>

void menu_item_initialize(
  struct menu_item* menu_item,
  enum menu_item_type type,
  enum menu_item_action action,
  void* data
) {
  menu_item->type = type;
  menu_item->action = action;
  menu_item->data = data;
}
