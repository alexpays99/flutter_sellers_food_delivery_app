import 'package:flutter/material.dart';
import 'package:sellers_app/global/gloval.dart';
import 'package:sellers_app/model/menus.dart';
import 'package:sellers_app/uploadScreens/items_upload_screen.dart';
import 'package:sellers_app/uploadScreens/menus_upload_screen.dart';
import 'package:sellers_app/widgets/my_drawer.dart';
import 'package:sellers_app/widgets/text_widget_header.dart';

class ItemsScreen extends StatefulWidget {
  final Menus? model;
  const ItemsScreen({Key? key, this.model}) : super(key: key);

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: Text(
          sharedPreferences!.getString('uid')!,
          style: const TextStyle(fontSize: 30, fontFamily: 'Lobster'),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.cyan,
                Colors.amber,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => ItemsUploadScreen(model: widget.model)));
            },
            icon: const Icon(
              Icons.library_add,
              color: Color.fromARGB(255, 255, 248, 218),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: TextWidgetHeader(
              title: 'My ' + widget.model!.menuTitle.toString() + "'s Items",
            ),
          ),
        ],
      ),
    );
  }
}
