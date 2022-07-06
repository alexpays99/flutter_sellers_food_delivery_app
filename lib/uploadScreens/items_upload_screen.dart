import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sellers_app/global/gloval.dart';
import 'package:sellers_app/mainScreens/home_screen.dart';
import 'package:sellers_app/model/menus.dart';
import 'package:sellers_app/widgets/error_dialog.dart';
import 'package:sellers_app/widgets/progress_bar.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;
//import 'package:cached_network_image/cached_network_image.dart';

class ItemsUploadScreen extends StatefulWidget {
  final Menus? model;
  const ItemsUploadScreen({Key? key, this.model}) : super(key: key);

  @override
  State<ItemsUploadScreen> createState() => _ItemsUploadScreenState();
}

class _ItemsUploadScreenState extends State<ItemsUploadScreen> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  bool uploading = false;
  String uniqueIdName = DateTime.now().microsecondsSinceEpoch.toString();

  defaultScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add New Item',
          style: TextStyle(fontSize: 30, fontFamily: 'Lobster'),
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
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (c) => const HomeScreen()),
            );
          },
        ),
      ),
      body: Container(
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.shop_two,
                color: Colors.white,
                size: 200,
              ),
              ElevatedButton(
                child: const Text(
                  'Add New Item',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.amber),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                onPressed: () {
                  takeImage(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  takeImage(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text(
              'Menu Image',
              style:
                  TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                child: const Text(
                  'Capture with Camera',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                onPressed: captureImageWithCamera,
              ),
              SimpleDialogOption(
                child: const Text(
                  'Select from Gallery',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                onPressed: pickImageFromGallery,
              ),
              SimpleDialogOption(
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  captureImageWithCamera() async {
    Navigator.pop(context);

    imageXFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }

  pickImageFromGallery() async {
    Navigator.pop(context);

    imageXFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 680,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }

  itemsUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Uploading New Item',
          style: TextStyle(fontSize: 20, fontFamily: 'Lobster'),
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
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            clearMenuUploadForm();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              uploading ? null : validateUploadForm();
            },
            child: const Text(
              'Add',
              style: TextStyle(
                color: Colors.cyan,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: 'Varela',
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          uploading == true ? linearProgress() : const Text(''),
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(
                        File(imageXFile!.path),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.amber,
            thickness: 2,
          ),
          ListTile(
            leading:
                const Icon(Icons.perm_device_information, color: Colors.cyan),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(
                  color: Colors.black,
                ),
                controller: shortInfoController,
                decoration: const InputDecoration(
                  hintText: 'Info',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.amber,
            thickness: 2,
          ),
          ListTile(
            leading: const Icon(Icons.title, color: Colors.cyan),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(
                  color: Colors.black,
                ),
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.amber,
            thickness: 2,
          ),
          ListTile(
            leading: const Icon(Icons.description, color: Colors.cyan),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(
                  color: Colors.black,
                ),
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Description',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.amber,
            thickness: 2,
          ),
          ListTile(
            leading: const Icon(Icons.price_change, color: Colors.cyan),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(
                  color: Colors.black,
                ),
                keyboardType: TextInputType.number,
                controller: priceController,
                decoration: const InputDecoration(
                  hintText: 'Price',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.amber,
            thickness: 2,
          ),
        ],
      ),
    );
  }

  clearMenuUploadForm() {
    setState(() {
      shortInfoController.clear();
      titleController.clear();
      imageXFile = null;
    });
  }

  validateUploadForm() async {
    if (imageXFile != null) {
      if (shortInfoController.text.isNotEmpty &&
          titleController.text.isNotEmpty) {
        setState(() {
          uploading = true;
        });
        // upload image
        String downloadUrl = await uploadImage(File(imageXFile!.path));
        // save info to firebase
        saveInfo(downloadUrl);
      } else {
        showDialog(
          context: context,
          builder: (c) {
            return const ErrorDialog(
              message: 'Please write title and menu info.',
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (c) {
          return const ErrorDialog(
            message: 'Please pick an image',
          );
        },
      );
    }
  }

  saveInfo(String downloadUrl) {
    final ref = FirebaseFirestore.instance
        .collection('sellers')
        .doc(sharedPreferences!.getString('uid'))
        .collection('menus');

    ref.doc(uniqueIdName).set({
      'menuID': uniqueIdName,
      'sellerUID': sharedPreferences!.getString('uid'),
      'menuInfo': shortInfoController.text.toString(),
      'menuTitle': titleController.text.toString(),
      'publishedDate': DateTime.now(),
      'status': 'available',
      'thumbnailUrl': downloadUrl,
    });

    clearMenuUploadForm();

    setState(() {
      uniqueIdName = DateTime.now().microsecondsSinceEpoch.toString();
      uploading = false;
    });
  }

  uploadImage(mImageFile) async {
    storageRef.Reference reference =
        storageRef.FirebaseStorage.instance.ref().child('menus');
    storageRef.UploadTask uploadTask =
        reference.child(uniqueIdName + '.jpg').putFile(mImageFile);
    storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    return imageXFile == null ? defaultScreen() : itemsUploadFormScreen();
  }
}
