import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recepiesapp/core/models/food.dart';
import 'package:recepiesapp/core/services/storage_service.dart';
import 'package:recepiesapp/ui/view/vm/add_recepies_vm.dart';
import 'package:recepiesapp/ui/view/vm/home_page_controller.dart';

class AddRecepiesPage extends StatefulWidget {
  final String userID;

  const AddRecepiesPage({Key key, this.userID}) : super(key: key);
  @override
  _AddRecepiesPageState createState() => _AddRecepiesPageState();
}

class _AddRecepiesPageState extends State<AddRecepiesPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formkey = GlobalKey<FormState>();

  String _foodName;
  String _foodRecepies;

  AddRecepiesVM vm = AddRecepiesVM();

  var malzemeEkleController1 = TextEditingController();
  var malzemeEkleController2 = TextEditingController();
  var malzemeEkleController3 = TextEditingController();
  var malzemeEkleController4 = TextEditingController();
  var malzemeEkleController5 = TextEditingController();

  File resim;
  String tempFotoUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF6F5F0),
      key: _scaffoldKey,
      //  floatingActionButton: _buildFloatingActionButton(),

      appBar: _buildAppBar(),
      body: Form(
        key: _formkey,
        child: ListView(
          padding: EdgeInsets.only(left: 15, right: 15),
          //   padding: EdgeInsets.all(15),
          children: [
            Container(
                height: 200,
                width: double.infinity,
                child: resim == null
                    ? Center(
                        child: Text("Resim Yok"),
                      )
                    : Image(image: FileImage(resim))),
            SizedBox(
              height: 20,
            ),
            OutlineButton(
              child: Text("Fotograf Yükle"),
              onPressed: () {
                _resimYukle(context, widget.userID);
              },
            ),
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Boş birakılamaz";
                }
                _foodName = value;
                return null;
              },
              style: TextStyle(
                  // color: (Color((0xff2196F3))),
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: "Yemek Adı",
              ),
            ),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Boş birakılamaz";
                }
                _foodRecepies = value;
                return null;
              },
              style: TextStyle(
                  // color: (Color((0xff2196F3))),
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: "Yemek Tarifi",
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(child: Text("Gerekli malzemeler")),
            SizedBox(
              height: 10,
            ),
            Center(
              child:
                  //Text(malzemeYazdir()),
                  Obx(() {
                String tmp = vm.malzemeYazdir();
                return Text(tmp);
              }),
            ),
            SizedBox(
              height: 10,
            ),
            OutlineButton(
              child: Text("Malzeme Ekle"),
              onPressed: () {
                _showBottomSheet();
              },
            ),
            SizedBox(
              height: 10,
            ),
            OutlineButton(
              child: Text("Kaydı Tamamla"),
              onPressed: () {
                if (_formkey.currentState.validate()) {
                  if (tempFotoUrl != null) {
                    _foodSaveDB();
                  } else {
                    uyariGoster(msg: "Yemek resmi yükleyiniz");
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }

  void _resimYukle(BuildContext context, String userID) {
    _secimFotoGoster(context, userID);
  }

  void _resimSec(
      ImageSource source, BuildContext context, String userID) async {
    final picker = ImagePicker();
    final secilen = await picker.getImage(source: source);

    if (secilen != null) {
      resim = File(secilen.path);
      setState(() {});
      Navigator.pop(context);
      tempFotoUrl = await StorageServisi().foodImageUpload(resim, userID);
    }
  }

  void _secimFotoGoster(BuildContext context, String userID) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text("Galeriden Fotoğraf Seç"),
              onTap: () {
                _resimSec(ImageSource.gallery, context, userID);
              },
            ),
            ListTile(
              title: Text("Kameradan Fotoğraf Çek"),
              onTap: () {
                _resimSec(ImageSource.camera, context, userID);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _foodSaveDB() {
    List<String> _list = vm.mList;

    Food f = Food(
        authorId: widget.userID,
        foodId: "",
        foodName: _foodName,
        fotoUrl: tempFotoUrl,
        recipe: _foodRecepies,
        foodMaterials: _list);

    var homeController = Get.find<HomePageController>();
    try {
      homeController.addFood(f);
    } catch (e) {
      print(e.code());
    }
    Navigator.of(context).pop();
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Color(0xffF6F5F0),
      centerTitle: true,
      title: Text(
        "ADD RECIPES",
        style: TextStyle(color: Color(0xffFF3E00)),
      ),
    );
  }

  void _showBottomSheet() {
    _scaffoldKey.currentState.showBottomSheet((context) => Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height * 0.4,
          child: Column(
            children: [
              TextField(
                controller: malzemeEkleController1,
                style: TextStyle(
                    // color: (Color((0xff2196F3))),
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    hintText: "Malzeme Ekle",
                    icon: Icon(
                      Icons.fastfood,
                      // color: Color(0xff2196F3),
                    )),
              ),
              TextField(
                controller: malzemeEkleController2,
                style: TextStyle(
                    // color: (Color((0xff2196F3))),
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    hintText: "Malzeme Ekle",
                    icon: Icon(
                      Icons.fastfood,
                      // color: Color(0xff2196F3),
                    )),
              ),
              TextField(
                controller: malzemeEkleController3,
                style: TextStyle(
                    // color: (Color((0xff2196F3))),
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    hintText: "Malzeme Ekle",
                    icon: Icon(
                      Icons.fastfood,
                      // color: Color(0xff2196F3),
                    )),
              ),
              TextField(
                controller: malzemeEkleController4,
                style: TextStyle(
                    // color: (Color((0xff2196F3))),
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    hintText: "Malzeme Ekle",
                    icon: Icon(
                      Icons.fastfood,
                      // color: Color(0xff2196F3),
                    )),
              ),
              TextField(
                controller: malzemeEkleController5,
                style: TextStyle(
                    // color: (Color((0xff2196F3))),
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    hintText: "Malzeme Ekle",
                    icon: Icon(
                      Icons.fastfood,
                      // color: Color(0xff2196F3),
                    )),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45))),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xffFC8B56))),
                onPressed: () {
                  if (malzemeEkleController1.text != "") {
                    vm.malzemeEkle(malzemeEkleController1.text);
                    malzemeEkleController1.text = null;
                  }
                  if (malzemeEkleController2.text != "") {
                    vm.malzemeEkle(malzemeEkleController2.text);
                    malzemeEkleController2.text = null;
                  }
                  if (malzemeEkleController3.text != "") {
                    vm.malzemeEkle(malzemeEkleController3.text);
                    malzemeEkleController3.text = null;
                  }
                  if (malzemeEkleController4.text != "") {
                    vm.malzemeEkle(malzemeEkleController4.text);
                    malzemeEkleController4.text = null;
                  }
                  if (malzemeEkleController5.text != "") {
                    vm.malzemeEkle(malzemeEkleController5.text);
                    malzemeEkleController5.text = null;
                  }
                  Navigator.of(context).pop();
                },
                child: Text("Ekle"),
              )
            ],
          ),
        ));
  }

  uyariGoster({msg}) {
    var snackBar = SnackBar(content: Text(msg));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
