#ifndef __menus_menu_item_h
#define __menus_menu_item_h

struct menu_item;

typedef void (*menu_item_on_action)(struct menu_item*);

enum menu_item_type {
  menu_item_type_display,
  menu_item_type_submenu,
  menu_item_type_selection
};

enum menu_item_action {
  menu_item_action_none,
  menu_item_action_select
};

struct menu_item {
  enum menu_item_type type;
  enum menu_item_action action;
  void* data;
};

void menu_item_initialize(
  struct menu_item*,
  enum menu_item_type,
  enum menu_item_action,
  void*
);

#endif
