import 'package:cool_dropdown/models/one_dropdown_item.dart';

typedef GetSelectedItem = void Function(int index);
typedef SelectedItemCallback<T> = void Function(OneDropdownItem<T>? item);
