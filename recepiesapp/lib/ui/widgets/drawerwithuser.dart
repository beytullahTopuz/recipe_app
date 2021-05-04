import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';
import 'package:recepiesapp/core/models/user.dart';
import 'package:recepiesapp/core/services/authentication_service.dart';
import 'package:recepiesapp/core/services/my_firestore_service.dart';
import 'package:recepiesapp/core/services/storage_service.dart';
import 'package:recepiesapp/ui/view/add_recepies_page.dart';
import 'package:recepiesapp/ui/view/login_page.dart';
import 'package:recepiesapp/ui/view/register_page.dart';

class DrawerWithUser extends StatefulWidget {
  @override
  _DrawerWithUserState createState() => _DrawerWithUserState();
}

class _DrawerWithUserState extends State<DrawerWithUser> {
  File resim;

  @override
  Widget build(BuildContext context) {
    final _yetkilendirmeServisi =
        Provider.of<AuthorizationService>(context, listen: false);

    return StreamBuilder(
        stream: _yetkilendirmeServisi.durumTakipcisi,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          if (snapshot.hasData) {
            UserModel aktifKullanici = snapshot.data;
            _yetkilendirmeServisi.aktifKullaniciId = aktifKullanici.userId;
            print(aktifKullanici.userId);
            return FutureBuilder(
              future: MyFireStoreServisi().getUser(aktifKullanici.userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return _buildColumnWithUser(snapshot.data, context);
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Center(
                    child: Text("ERROR"),
                  );
                }
              },
            );
          } else {
            return _buildColumn(context);
          }
        });
  }

  Column _buildColumnWithUser(UserModel userModel, context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            SizedBox(
              height: 50,
            ),
            CircleAvatar(
              radius: 65,
              backgroundImage: userModel.userFotoUrl != ""
                  ? NetworkImage(userModel.userFotoUrl)
                  : null,
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () {
                  _resimYukle(context, userModel);
                },
                child: Text("profil resmi değiştir")),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(userModel.userAdSoyad),
            ),
            ListTile(
              leading: Icon(Icons.work),
              title: Text("Mesleği"),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                leading: Icon(Icons.food_bank),
                title: Text("Yayımlanan tariflerim"),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                      builder: (context) => AddRecepiesPage(
                        userID: userModel.userId,
                      ),
                    ))
                    .then((value) => Navigator.pop(context));
              },
              child: ListTile(
                leading: Icon(Icons.add_alert_sharp),
                title: Text("Yemek tarifi yayınla"),
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            Provider.of<AuthorizationService>(context, listen: false).signOut();
          },
          child: ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("ÇIKIŞ YAP"),
          ),
        )
      ],
    );
  }

  void resimkayitFirabase(File f, UserModel u) async {
    try {
      var fotoUrl = await StorageServisi().userimgUpload(f, u.userId);

      UserModel newUser = u;
      newUser.userFotoUrl = fotoUrl;
      MyFireStoreServisi().updateUser(u.userId, newUser);
      setState(() {});
    } catch (e) {
      print(e.code);
    }
  }

  void _resimYukle(BuildContext context, UserModel u) {
    _secimFotoGoster(context, u);
  }

  void _resimSec(ImageSource source, BuildContext context, UserModel u) async {
    final picker = ImagePicker();
    final secilen = await picker.getImage(source: source);

    if (secilen != null) {
      resim = File(secilen.path);
      resimkayitFirabase(resim, u);
    }

    Navigator.pop(context);
  }

  void _secimFotoGoster(BuildContext context, UserModel u) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text("Galeriden Fotoğraf Seç"),
              onTap: () {
                _resimSec(ImageSource.gallery, context, u);
              },
            ),
            ListTile(
              title: Text("Kameradan Fotoğraf Çek"),
              onTap: () {
                _resimSec(ImageSource.camera, context, u);
              },
            ),
          ],
        ),
      ),
    );
  }

  Column _buildColumn(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Text("Recipe App",
                style: GoogleFonts.adventPro(
                    textStyle: Theme.of(context)
                        .textTheme
                        .headline4
                        .copyWith(fontWeight: FontWeight.bold))),
            SizedBox(
              height: 15,
            ),
            Container(
              margin: EdgeInsets.all(5),
              height: 3,
              color: Colors.black45,
            ),
            ListTile(
              leading: Icon(Icons.food_bank_outlined),
              title: Text(
                  "Yemek tarifi yayımlamadan önce giriş yapmanız gerekmektedir"),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                  child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ));
                },
                child: Card(
                  color: Color(0xffFF3E00),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                      height: 35,
                      child: Center(
                          child: Text(
                        "GİRİŞ YAP",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ))),
                ),
              )),
              Expanded(
                  child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RegisterPAge(),
                  ));
                },
                child: Card(
                  color: Color(0xffFF3E00),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                      height: 35,
                      child: Center(
                          child: Text(
                        "KAYIT OL",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ))),
                ),
              )),
            ],
          ),
        )
      ],
    );
  }
}
