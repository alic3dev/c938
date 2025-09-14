#include <menus/menu_main.h>

#include <menus/menu.h>
#include <menus/menu_item.h>

void menu_main_initialize(
  struct menu* menu
) {
  menu_initialize(menu);

  menu_item_add(
    menu,
    menu_item_type_selection,
    menu_item_action_select,
    (void*)0
  );

  menu_item_add(
    menu,
    menu_item_type_selection,
    menu_item_action_select,
    (void*)0
  );
}
