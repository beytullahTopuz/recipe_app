import 'package:flutter/material.dart';
import 'package:recepiesapp/core/models/food.dart';

class FoodDetailPage extends StatefulWidget {
  final Food food;

  const FoodDetailPage({Key key, this.food}) : super(key: key);

  @override
  _FoodDetailPageState createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(appBar: _buildAppBar(), body: _buildBody(size, context));
  }

  Widget _buildBody(Size size, BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 24,
          child: Container(
            width: size.width,
            child: Image.network(
              widget.food.fotoUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Spacer(
          flex: 2,
        ),
        Expanded(
          flex: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                widget.food.foodName,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                "6 Kişilik",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 40,
          child: _listView(),
        ),
      ],
    );
  }

  ListView _listView() {
    return ListView.builder(
      itemCount: (widget.food.foodMaterials.length) + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _tarif();
        } else {
          return Container(
            height: 40,
            margin: EdgeInsets.all(8),
            child: Center(
                child: Text(
              widget.food.foodMaterials[index - 1],
            )),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.red),
            ),
          );
        }
      },
    );
  }

  Widget _tarif() {
    return Container(
      margin: EdgeInsets.all(15),
      child: Column(
        children: [
          Text(
            "Tarifi",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          Text(widget.food.recipe)
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        "FoodDetailPAge",
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
