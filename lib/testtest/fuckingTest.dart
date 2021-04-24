import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/box.dart';
import 'package:http/http.dart' as http;
import '../model/modelMock.dart';

class PageExampleLoadDataItem extends StatefulWidget {
  final List<Data> dataList;

  PageExampleLoadDataItem({
    Key key,
    this.dataList,
  }) : super(key: key);

  @override
  PageExampleLoadDataItemState createState() => PageExampleLoadDataItemState();
}

class PageExampleLoadDataItemState extends State<PageExampleLoadDataItem> {
  // List<String> items = ["AA", "BB", "CC", "DD", "EE", "FF", "GG", "HH"];
  List<ModelMock> _transactions = [];
  // bool _lights = false;

  // void _detailPage() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => PageDetail()),
  //   );
  // }

  void _getdata() {
    http
        .get(
      //get ไปเอาข้อมูลที่เดิม แต่ส่งแบบ get แทน
      Uri.parse(
          "https://labtest-68c7d-default-rtdb.firebaseio.com/teamsoft.json"), //return Futre <Response> --> เอา data จาก future ใข้ .then
    )
        .then((response) {
      print(response.body); // ไดข้อมูลมาแล้วว จาก console ด้านล่าง
      final extractedData = json.decode(response.body) as Map<String,
          dynamic>; //parse data จาก firebase ไปใส่ใน list  ของ object ก๊อปไปได้เลย ใช้ http get นะ
      final List<ModelMock> transaction = [];
      extractedData.forEach((prodId, prodData) {
        // loop key value ทื่ได้มาแล้วค่อยไปใส่ใน transaction หรือ ใน list ของ object ของเรา ให้ถูกต้อง
        // print("ProductData: $prodData");
        transaction.add(ModelMock(
          // ปรับแค่ตอนสร้าง object
            description: prodData['description'],
            title: prodData['title'],
            date: DateTime.now(),
            id: prodData['id']));

        setState(() {
          this._transactions = transaction;
        });
      });
      print(transaction);
    });
  }


  @override
  Widget build(BuildContext context) {
    ListTile makeListTile(ModelMock modelMock) => ListTile(
      contentPadding:
      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24))),
        child: Icon(Icons.autorenew, color: Colors.white),
      ),
      title: Text(
        modelMock.title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

      subtitle: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Container(
                // tag: 'hero',
                child: LinearProgressIndicator(
                    backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                    value: modelMock.id.toDouble(),
                    valueColor: AlwaysStoppedAnimation(Colors.green)),
              )),
          Expanded(
            flex: 4,
            child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(modelMock.description,
                    style: TextStyle(color: Colors.white))),
          )
        ],
      ),
      trailing:
      Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => DetailPage(lesson: lesson))
        // );
      },
    );

    Card makeCard(ModelMock modelMock) => Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
        child: makeListTile(modelMock),
      ),
    );

    final makeBody = Container(
      // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: _transactions.length,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(_transactions[index]);
        },
      ),
    );

    /*
    final makeBottom = Container(
      height: 55.0,
      child: BottomAppBar(
        color: Color.fromRGBO(58, 66, 86, 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.blur_on, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.hotel, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.account_box, color: Colors.white),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
    */
    // final topAppBar = AppBar(
    //   elevation: 0.1,
    //   backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
    //   title: Text(widget.dataList),
    //   actions: <Widget>[
    //     IconButton(
    //       icon: Icon(Icons.list),
    //       onPressed: () {},
    //     )
    //   ],
    // );

    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      // appBar: topAppBar,
      body: makeBody,
      // bottomNavigationBar: makeBottom,
    );

  }
}

class Data {
  final int id;
  bool expanded;
  final String title;

  Data(this.id, this.expanded, this.title);
}



/*
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
              child: Text(
                'Please click to download.',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            RaisedButton(
              onPressed: _getdata,
              child: Text('Load data', style: TextStyle(fontSize: 20)),
            ),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              children: _transactions.map((item) {
                return InkWell(
                    onTap: _getdata,
                    child: Card(
                        child: Column(children: [
                      ListTile(
                        title: Text(item.title,
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        subtitle: Text(item.description),
                        leading: null,
                      ),
                    ]
                        )
                    )
                );
              }).toList(),
            ),


            SizedBox(
              height: 10,
            ),



          ],
        )),
      ),
    );
  }
 */