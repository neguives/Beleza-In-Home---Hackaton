import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreai/Salao/product_data_two.dart';
import 'package:compreai/Salao/product_tile_two.dart';
import 'package:compreai/datas/product_data.dart';
import 'package:compreai/tiles/product_tile.dart';
import 'package:compreai/widgets/cart_button.dart';
import 'package:flutter/material.dart';

class Products_ScreenTwo extends StatelessWidget {
  final DocumentSnapshot snapshot;

  Products_ScreenTwo(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          floatingActionButton: CartButton(),
          appBar: AppBar(
            backgroundColor: Colors.blueGrey,
            title: Text(
              snapshot.data["title"],
              style: TextStyle(
                  color: Colors.lightGreen.shade400,
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Colors.lightGreen.shade100,
              tabs: <Widget>[
                Tab(
                    child: Text(
                      "Vizualizar em grade",
                      style: TextStyle(color: Colors.lightGreen.shade100),
                    ),
                    icon: Icon(
                      Icons.grid_on,
                      color: Colors.lightGreen.shade100,
                    )),
                Tab(
                    child: Text(
                      "Compra Rápida",
                      style: TextStyle(color: Colors.lightGreen.shade100),
                    ),
                    icon: Icon(
                      Icons.list,
                      color: Colors.lightGreen.shade100,
                    )),
              ],
            ),
          ),
          body: FutureBuilder<QuerySnapshot>(
            future: Firestore.instance
                .collection("hackaton")
                .document(snapshot.documentID)
                .collection("itens")
                .getDocuments(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else
                return TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    GridView.builder(
                        padding: EdgeInsets.all(5),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                            childAspectRatio: 0.65),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          ProductData data = ProductData.fromDocument(
                              snapshot.data.documents[index]);
                          data.category = this.snapshot.documentID;
                          return ProductTile("grid", data);
                        }),
                    ListView.builder(
                        padding: EdgeInsets.all(4),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          ProductData data = ProductData.fromDocument(
                              snapshot.data.documents[index]);
                          data.category = this.snapshot.documentID;
                          return ProductTile("list", data);
                        })
                  ],
                );
            },
          )),
    );
  }
}
