import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:recepiesapp/core/models/user.dart';
import 'package:recepiesapp/core/services/authentication_service.dart';
import 'package:recepiesapp/core/services/my_firestore_service.dart';
import 'package:recepiesapp/ui/view/login_page.dart';

class RegisterPAge extends StatefulWidget {
  @override
  _RegisterPAgeState createState() => _RegisterPAgeState();
}

class _RegisterPAgeState extends State<RegisterPAge> {
  final _formkey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _email;
  String _password;
  String _adSoyad;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xffF6F5F0),
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Form(
      key: _formkey,
      child: ListView(
        padding: EdgeInsets.only(left: 25, right: 25),
        children: [
          SizedBox(
            height: 20,
          ),
          Text("REGISTER",
              style: GoogleFonts.adventPro(
                  textStyle: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(fontWeight: FontWeight.bold))),
          SizedBox(
            height: 25,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Boş birakılamaz";
                }
                _email = value;
                return null;
              },
              style: TextStyle(fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  hintText: "e mail",
                  icon: Icon(
                    Icons.mail,
                  )),
            ),
          ),
          SizedBox(
            height: 18,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Boş birakılamaz";
                }
                _password = value;
                return null;
              },
              style: TextStyle(
                  // color: (Color((0xff2196F3))),
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  hintText: "şifre",
                  icon: Icon(
                    Icons.remove_red_eye,
                    // color: Color(0xff2196F3),
                  )),
            ),
          ),
          SizedBox(
            height: 18,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Boş birakılamaz";
                }
                _adSoyad = value;
                return null;
              },
              style: TextStyle(
                  // color: (Color((0xff2196F3))),
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  hintText: "Ad & Soyad", icon: Icon(Icons.person)),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              registerClicted();
            },
            child: Card(
              elevation: 10,
              color: Color(0xffFF3E00),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Container(
                height: 50,
                child: Center(
                  child: Text("HESAP OLUŞTUR",
                      style: Theme.of(context).textTheme.headline5.copyWith(
                            color: Colors.white,
                          )),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 18,
          ),
          SizedBox(
            height: 18,
          ),
          Container(
            height: 3,
            color: Colors.black45,
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                  child: InkWell(
                onTap: () {},
                child: Card(
                  elevation: 5,
                  color: Color(0xffF6F5F0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35)),
                  child: Container(
                      height: 35,
                      child: Center(
                          child: Text("facebook",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold)))),
                ),
              )),
              Expanded(
                  child: InkWell(
                onTap: () {},
                child: Card(
                  elevation: 5,
                  color: Color(0xffF6F5F0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35)),
                  child: Container(
                      height: 35,
                      child: Center(
                          child: Text(
                        "Google",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))),
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      backgroundColor: Color(0xffF6F5F0),
      elevation: 0,
      actions: [
        InkWell(
          onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => LoginScreen(),
          )),
          child: Center(
            child: Text("LOGIN",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: Color(0xffFF3E00))),
          ),
        ),
        SizedBox(
          width: 10,
        )
      ],
    );
  }

  void registerClicted() {
    if (_formkey.currentState.validate()) {
      print("başarili");
      print(_email + _password + _adSoyad);

      _register();
    }
  }

  void _register() async {
    final _yetkilendirmeServisi =
        Provider.of<AuthorizationService>(context, listen: false);
    try {
      var _tempUser =
          await _yetkilendirmeServisi.registerWithEmaiil(_email, _password);

      if (_tempUser != null) {
        UserModel myUser = UserModel(
            userId: _tempUser.userId,
            userMail: _email,
            userAdSoyad: _adSoyad,
            userFotoUrl: "");
        MyFireStoreServisi().addUser(myUser);
      }

      Navigator.of(context).pop();
    } catch (e) {
      uyariGoster(hataKodu: e.code);
    }
  }

  uyariGoster({hataKodu}) {
    String hataMesaji;

    if (hataKodu == "invalid-email") {
      hataMesaji = "Girdiğiniz mail adresi geçersizdir";
    } else if (hataKodu == "email-already-in-use") {
      hataMesaji = "Girdiğiniz mail kayıtlıdır";
    } else if (hataKodu == "weak-password") {
      hataMesaji = "Daha zor bir şifre tercih edin";
    } else {
      hataMesaji = "Bilinemeyen hata";
    }

    var snackBar = SnackBar(content: Text(hataMesaji));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
