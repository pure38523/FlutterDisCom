import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/box.dart';
import 'package:http/http.dart' as http;
import 'model/modelMock.dart';

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
  List<String> items = ["AA", "BB", "CC", "DD", "EE", "FF", "GG", "HH"];
  List<ModelMock> _transactions = [];
  bool _lights = false;

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
                      SwitchListTile(
                        title: null,
                        value: _lights,
                        onChanged: (bool value) {
                          // setState(() {
                          //   _lights = value;
                          // });
                        },
                        secondary: const Icon(Icons.lightbulb_outline),
                      ),
                    ]
                        )
                    )
                );
              }).toList(),
            ),
            SizedBox(
              height: 10,
            )
          ],
        )),
      ),
    );
  }
}

class Data {
  final int id;
  bool expanded;
  final String title;

  Data(this.id, this.expanded, this.title);
}
