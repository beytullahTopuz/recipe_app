import 'package:flutter/material.dart';

class MyFoodCard extends StatelessWidget {
  final String title;
  final String image;
  final int kacKisilik;
  final String description;
  final String author;
  final Function press;

  const MyFoodCard({
    Key key,
    this.title,
    this.kacKisilik,
    this.image,
    this.description,
    this.author,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: press,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.74,
        child: Card(
          elevation: 3,
          borderOnForeground: true,
          color: Colors.red.withOpacity(0.5),
          // color: Color(0xffF6F5F0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                  child: image != ""
                      ? Image.network(
                          image,
                          width: size.width * 0.74,
                          height: size.height * 0.25,
                          fit: BoxFit.cover,
                        )
                      : Text("fotograf yok"),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text("$kacKisilik kişilik",
                    style: Theme.of(context).textTheme.headline6),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    description,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
