import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/box.dart';
import 'package:http/http.dart' as http;
import 'custom_dialog_box.dart';
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
  // List<String> items = ["AA", "BB", "CC", "DD", "EE", "FF", "GG", "HH"];
  List<ModelMock> _transactions = [];                                           ////Edit Adap model class which should be our data
  var isOwner ;


  @override
  void initState() {
    _transactions = _getdata();                                                 // receive data from api when start app
    super.initState();

  }

  // void _detailPage() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => PageDetail()),
  //   );
  // }

  List _getdata() {                                                             // get data from api
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
    isOwner = true;                                //// Edit State when login checking user type that true or false

    return
      SafeArea(
      child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Visibility(       //// Implement here- Edit State when login checking user type that true or false
            child: FloatingActionButton(
              child: Icon(Icons.add),
                onPressed:(){
                  showCustomDialogBox(context);
                },
            ),
            visible: isOwner,
          ),
         body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Column(
                  children: _transactions
                          ?.map(
                            (entry) => new ListTile(
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0,
                                            color: Colors.blueGrey))),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "https://www.pngfind.com/pngs/m/470-4703547_icon-user-icon-hd-png-download.png"),
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(16.0),
                              title: Text(entry.description),
                              subtitle: Text(entry.title.toString()),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: () {
                                print("test");
                              },
                              // selected: false,
                            ),
                          )
                          ?.toList() ??
                      [],
                ),

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

showCustomDialogBox(BuildContext context) {
  return showGeneralDialog(
      context: context,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          child: child,
          scale: Tween<double>(end: 1.0, begin: 0).animate(CurvedAnimation(
              parent: animation,
              curve: Interval(0.00, 0.50, curve: Curves.linear))),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return CustomDialogBox();
      });
}
