import 'package:flutter/material.dart';
import 'package:flutter_dsc_project/page_example_loadData.dart';
import 'package:flutter_dsc_project/page_example_loadData_guess.dart';
import 'package:flutter_dsc_project/page_two.dart';



class RouterManager extends StatefulWidget {
  @override
  _RouterManagerState createState() => _RouterManagerState();
}

class _RouterManagerState extends State<RouterManager> {
  final Key keyOne = PageStorageKey('pageOne');
  final Key keyTwo = PageStorageKey('pageTwo');
  final Key keyThree = PageStorageKey('pageThree');

  int currentTab = 0;

  //page that want to load
  PageExampleLoadDataItem one;
  PageTwo two;
  PageExampleLoadDataItemGuess three;

  List<Widget> pages;
  Widget currentPage;

  // List<Data> dataList;
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {

    one = PageExampleLoadDataItem(
      key: keyOne,
    );
    two = PageTwo(
      key: keyTwo,
    );
    three = PageExampleLoadDataItemGuess(
      key : keyThree,
    )
    ;



    pages = [one,two,
      three
    ];

    currentPage = one;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("S23d School"),
      // ),
      body: PageStorage(
        child: currentPage,
        bucket: bucket,
      ),
      bottomNavigationBar: BottomNavigationBar( //nav bar
        currentIndex: currentTab,
        onTap: (int index) {
          setState(() {
            currentTab = index;
            currentPage = pages[index];
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment_sharp),
            title: Text('File List'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text("My Account"),
          ),

        ],
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


