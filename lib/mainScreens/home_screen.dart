import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sellers_app/authentication/auth_screen.dart';
import 'package:sellers_app/global/gloval.dart';
import 'package:sellers_app/model/menus.dart';
import 'package:sellers_app/uploadScreens/menus_upload_screen.dart';
import 'package:sellers_app/widgets/info_design.dart';
import 'package:sellers_app/widgets/my_drawer.dart';
import 'package:sellers_app/widgets/progress_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sellers_app/widgets/text_widget_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const MenusUploadScreen()));
            },
            icon: const Icon(
              Icons.post_add,
              color: Color.fromARGB(255, 255, 248, 218),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: TextWidgetHeader(title: 'My Menus'),
          ),
          SliverToBoxAdapter(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('sellers')
                  .doc(sharedPreferences!.getString('uid'))
                  .collection('menus')
                  .orderBy('publishedDate', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? Center(
                        child: circularProgress(),
                      )
                    : StaggeredGridView.countBuilder(
                        shrinkWrap: true,
                        crossAxisCount: 1,
                        staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                        itemBuilder: (context, index) {
                          Menus menuModel = Menus.fromJson(
                            snapshot.data!.docs[index].data()!
                                as Map<String, dynamic>,
                          );

                          return InfoDesignWidget(
                            model: menuModel,
                            context: context,
                          );
                        },
                        itemCount: snapshot.data!.docs.length,
                      );
              },
            ),
          )
        ],
      ),
    );
  }
}
