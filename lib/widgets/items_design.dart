import 'package:flutter/material.dart';
import 'package:sellers_app/mainScreens/items_screen.dart';
import 'package:sellers_app/model/items.dart';
import 'package:sellers_app/model/menus.dart';

class ItemsDesignWidget extends StatefulWidget {
  ItemsDesignWidget({Key? key, this.model, this.context}) : super(key: key);

  Items? model;
  BuildContext? context;

  @override
  State<ItemsDesignWidget> createState() => _ItemsDesignWidgetWidgetState();
}

class _ItemsDesignWidgetWidgetState extends State<ItemsDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //Navigator.push(context,MaterialPageRoute(builder: (c) => ItemsScreen(model: widget.model)),);
      },
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          height: 285,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 1),
              Text(
                widget.model!.title!,
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 20,
                  fontFamily: 'Train',
                ),
              ),
              const SizedBox(height: 2),
              Image.network(
                widget.model!.thumbnailUrl!,
                height: 210.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 2),
              Text(
                widget.model!.shortInfo!,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontFamily: 'Train',
                ),
              ),
              const SizedBox(height: 1),
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
