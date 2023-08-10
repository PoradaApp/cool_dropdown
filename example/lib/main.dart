import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

List<CoolDropdownItem<String>> dropdownItemList = [];

List<String> pokemons = ['pikachu', 'charmander', 'squirtle', 'bullbasaur', 'snorlax', 'mankey', 'psyduck', 'meowth'];
List<String> fruits = [
  'apple',
  'banana',
  'grapes',
  'lemon',
  'melon',
  'orange',
  'pineapple',
  'strawberry',
  'watermelon',
];

class _MyAppState extends State<MyApp> {
  List<CoolDropdownItem<String>> pokemonDropdownItems = [];
  List<CoolDropdownItem<String>> fruitDropdownItems = [];
  final _formKey = GlobalKey<FormState>();
  final fruitDropdownController = DropdownController();
  final pokemonDropdownController = DropdownController();
  final listDropdownController = DropdownController();

  @override
  void initState() {
    for (var i = 0; i < pokemons.length; i++) {
      pokemonDropdownItems.add(
        CoolDropdownItem<String>(
            label: '${pokemons[i]}',
            icon: Container(
              height: 25,
              width: 25,
            ),
            value: '${pokemons[i]}'),
      );
    }
    /* for (var i = 0; i < fruits.length; i++) {
      fruitDropdownItems.add(CoolDropdownItem<String>(
          label: 'Delicious ${fruits[i]}',
          icon: Container(
            margin: EdgeInsets.only(left: 10),
            height: 25,
            width: 25,
          ),
          selectedIcon: Container(
            margin: EdgeInsets.only(left: 10),
            height: 25,
            width: 25,
          ),
          value: '${fruits[i]}'));
    } */
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF6FCC76),
          title: Text('Cool Drop Down'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              onPressed: () async {
                _formKey.currentState?.validate();
              },
              label: Text('Validate'),
            ),
            SizedBox(
              width: 10,
            ),
            FloatingActionButton.extended(
              onPressed: () async {
                if (fruitDropdownController.isError) {
                  fruitDropdownController.resetError();
                } else {
                  await fruitDropdownController.error();
                }
                fruitDropdownController.open();
              },
              label: Text('Error'),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 70,
            ),
            Center(
              child: WillPopScope(
                onWillPop: () async {
                  if (fruitDropdownController.isOpen) {
                    fruitDropdownController.close();
                    return Future.value(false);
                  } else {
                    return Future.value(true);
                  }
                },
                child: Form(
                  key: _formKey,
                  child: CoolDropdown<String>(
                    controller: fruitDropdownController,
                    dropdownList: fruitDropdownItems,
                    defaultItem: null,
                    hasInputField: true,
                    onChange: (value) async {},
                    hintText: 'Select language',
                    onOpen: (value) {},
                    isMarquee: false,
                    undefinedItem: CoolDropdownItem(label: 'Create with this name', value: 'test'),
                    onValidate: (value) {
                      if (value == null) return null;
                      if (value.isEmpty) return 'gfdgdf';
                      return null;
                    },
                    inputDecoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyan),
                      ),
                      disabledBorder: InputBorder.none,
                      filled: true,
                      fillColor: Colors.transparent,
                      errorStyle: TextStyle(color: Colors.white),
                      hintText: "widget.hintText",
                      counterText: '',
                      labelText: "widget.labelText",
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    resultOptions: ResultOptions(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      width: 700,
                      icon: const SizedBox(
                        width: 10,
                        height: 10,
                        child: CustomPaint(
                          painter: DropdownArrowPainter(),
                        ),
                      ),
                      duration: Duration.zero,
                      render: ResultRender.all,
                      placeholder: "widget.hintText,",
                      isMarquee: false,

                      //isMarquee: true,
                      //inputTextField: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    dropdownOptions: DropdownOptions(
                      top: 8,
                      height: 364,
                      gap: DropdownGap.zero,
                      shadows: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 5, spreadRadius: 1)],
                      borderSide: BorderSide.none,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      align: DropdownAlign.left,
                      animationType:
                          DropdownAnimationType.size, //DropdownAnimation.size has problems with opening above ResultBox
                    ),
                    dropdownTriangleOptions: const DropdownTriangleOptions(
                      height: 0,
                    ),
                    dropdownItemOptions: DropdownItemOptions(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      selectedBoxDecoration: BoxDecoration(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 200,
            ),
            Center(
              child: CoolDropdown<String>(
                controller: pokemonDropdownController,
                dropdownList: pokemonDropdownItems,
                defaultItem: pokemonDropdownItems.last,
                onChange: (a) {
                  pokemonDropdownController.close();
                },
                hasInputField: false,
                resultOptions: ResultOptions(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  width: 100,
                  icon: const SizedBox(
                    width: 10,
                    height: 10,
                    child: CustomPaint(
                      painter: DropdownArrowPainter(),
                    ),
                  ),
                  duration: Duration.zero,
                  render: ResultRender.all,
                  placeholder: "widget.hintText,",
                  isMarquee: false,

                  //isMarquee: true,
                  //inputTextField: TextStyle(color: Colors.black, fontSize: 15),
                ),
                dropdownOptions: DropdownOptions(
                  width: 160,
                ),
                dropdownItemOptions: DropdownItemOptions(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  selectedBoxDecoration: BoxDecoration(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 200,
            ),
            Center(
              child: CoolDropdown(
                controller: listDropdownController,
                dropdownList: pokemonDropdownItems,
                onChange: (dropdownItem) {},
                resultOptions: ResultOptions(
                  width: 50,
                  render: ResultRender.none,
                  icon: Container(
                    width: 25,
                    height: 25,
                    color: Colors.red,
                  ),
                ),
                dropdownItemOptions: DropdownItemOptions(
                  render: DropdownItemRender.icon,
                  selectedPadding: EdgeInsets.zero,
                  mainAxisAlignment: MainAxisAlignment.center,
                  selectedBoxDecoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Colors.black.withOpacity(0.7),
                        width: 3,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 500,
            ),
          ],
        ),
      ),
    );
  }
}
