//add flutter feature to validate class  --> foundation come with @require
import 'package:flutter/foundation.dart';

//use for store data as a model class

class ModelMock {
  final int id;
  final String title;
  final String description;
  final DateTime date;

  ModelMock(
      {@required this.id, @required this.title, @required this.description,@required this.date,
      });
}
//@required ใช้บอกว่าตอนจะส่งค่าจาก constructor มา ต้องส่งให้ครบ

// ไปทำ transaction ต่อเลย ที่ main -->import xx.dart
// add ->  final List<Transaction>  varTx = [Transaction(id1: "",id2:", ...] ที่ Class สร้าง widget อันนี้คือ  MyHomePage
