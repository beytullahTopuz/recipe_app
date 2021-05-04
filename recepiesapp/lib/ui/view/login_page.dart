import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:recepiesapp/core/services/authentication_service.dart';
import 'package:recepiesapp/ui/view/register_page.dart';

import 'home_page2.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _email;
  String _password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF6F5F0),
      key: _scaffoldKey,
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
          Text("SIGN IN",
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
            child: Center(
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
          ),
          SizedBox(
            height: 30,
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
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Şifremi Unuttum"),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => RegisterPAge()));
                  },
                  child: Text("Hesabım Yok")),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              loginClicted();
            },
            child: Card(
              elevation: 5,
              color: Color(0xffFF3E00),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Container(
                height: 45,
                child: Center(
                    child: Text(
                  "GİRİŞ",
                  style: Theme.of(context).textTheme.headline5.copyWith(
                        color: Colors.white,
                      ),
                )),
              ),
            ),
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
      centerTitle: true,
      backgroundColor: Color(0xffF6F5F0),
      elevation: 0,
      // title: Text("Tekrar Hoşgeldiniz"),
    );
  }

  void loginClicted() {
    if (_formkey.currentState.validate()) {
      print("başarili");
      print(_email + _password);

      _giris();
    }
  }

  void _giris() async {
    final _yetkilendirmeServisi =
        Provider.of<AuthorizationService>(context, listen: false);

    try {
      await _yetkilendirmeServisi.loginWithEmail(_email, _password);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomePage2(),
      ));
    } catch (e) {
      uyariGoster(hataKodu: e.code);
    }
  }

  uyariGoster({hataKodu}) {
    String hataMesaji;

    if (hataKodu == "user-not-found") {
      hataMesaji = "Böyle bir kullanıcı bulunmuyor";
    } else if (hataKodu == "invalid-email") {
      hataMesaji = "Girdiğiniz mail adresi geçersizdir";
    } else if (hataKodu == "wrong-password") {
      hataMesaji = "Girilen şifre hatalı";
    } else if (hataKodu == "user-disabled") {
      hataMesaji = "Kullanıcı engellenmiş";
    } else {
      hataMesaji = "Tanımlanamayan bir hata oluştu $hataKodu";
    }

    var snackBar = SnackBar(content: Text(hataMesaji));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
