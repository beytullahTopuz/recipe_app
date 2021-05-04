import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recepiesapp/core/models/food.dart';

import 'package:provider/provider.dart';
import 'package:recepiesapp/core/services/authentication_service.dart';
import 'package:recepiesapp/ui/view/vm/home_page_controller.dart';
import 'package:recepiesapp/ui/widgets/drawerwithuser.dart';
import 'package:get/get.dart';

import 'food_detail_page.dart';

class HomePage2 extends StatefulWidget {
  @override
  _HomePage2State createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  String userProfilID;
  final HomePageController homeController = Get.put(HomePageController());
  @override
  void initState() {
    userProfilID = Provider.of<AuthorizationService>(context, listen: false)
        .aktifKullaniciId;
    print(userProfilID);
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: Drawer(
        child: DrawerWithUser(),
      ),
      body: Obx(() => _buildListView(homeController.foodlist)),
    );
  }

  ListView _buildListView(List<Food> foodlist) {
    return ListView.builder(
      itemCount: foodlist.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              Text("Recipe App",
                  style: GoogleFonts.adventPro(
                      textStyle: Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(fontWeight: FontWeight.bold))),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                      child: _option(
                          " Top ", "assets/images/foodlogo/fruit.png", 0)),
                  Expanded(
                      child: _option(
                          " rice ", "assets/images/foodlogo/rice.png", 1)),
                  Expanded(
                      child: _option(" Vegetable ",
                          "assets/images/foodlogo/salad.png", 2)),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildTopCard(
                        context: context,
                        description: "Atıştırmalık",
                        imageUrl:
                            "https://images.freeimages.com/images/large-previews/51f/healthy-food-1328279.jpg",
                        name: "Hamburger"),
                    _buildTopCard(
                        context: context,
                        description: "Yapımı zor",
                        imageUrl:
                            "https://images.freeimages.com/images/large-previews/731/food-1326695.jpg",
                        name: "Mantı"),
                    _buildTopCard(
                        context: context,
                        description: "Vejeteryan",
                        imageUrl:
                            "https://images.freeimages.com/images/large-previews/9ff/fine-dining-food-presentation-1327945.jpg",
                        name: "Brokoli"),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Text("All Recipes",
                        style: GoogleFonts.adventPro(
                            textStyle: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffFF3E00)))),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Container(
            margin: EdgeInsets.all(8),
            child: InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FoodDetailPage(
                  food: foodlist[index - 1],
                ),
              )),
              child: _buildListCard(
                  context: context,
                  description: foodlist[index - 1].recipe,
                  imageUrl: foodlist[index - 1].fotoUrl,
                  name: foodlist[index - 1].foodName),
            ),
          );
        }
      },
    );
  }

  Widget _buildListCard(
      {BuildContext context,
      String name,
      String description,
      String imageUrl}) {
    return Card(
      color: Color(0xffF6F5F0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      child: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    flex: 9,
                    child: CircleAvatar(
                      radius: 90,
                      child: imageUrl != "" ? null : Text("fotograf yok"),
                      backgroundImage:
                          imageUrl != "" ? NetworkImage(imageUrl) : null,
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Container(
                        color: Colors.white,
                        child: Center(
                          child: Text("6 Kişilik",
                              style: GoogleFonts.adventPro(
                                  color: Color(0xffFF3E00),
                                  fontWeight: FontWeight.bold)),
                        ),
                      )),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                name,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Text(description, style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }

  Card _buildTopCard(
      {BuildContext context,
      String name,
      String description,
      String imageUrl}) {
    return Card(
      color: Color(0xffF6F5F0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      child: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(imageUrl),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                name,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Text(description, style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Color(0xffF6F5F0),
      elevation: 0,
      actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
    );
  }

  Widget _option(String text, String image, int index) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
      margin: EdgeInsets.only(left: 3, right: 3),
      color: index == 0 ? Color(0xffFF3E00) : Color(0xffF6F5F0),
      elevation: 5,
      child: Container(
        height: 35,
        child: Row(
          children: [
            SizedBox(
              height: 32,
              width: 32,
              child: Image.asset(
                image,
                color: index == 0 ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              text,
              style: TextStyle(
                color: index == 0 ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
