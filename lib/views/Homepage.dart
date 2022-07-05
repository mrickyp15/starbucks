import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starbucks/constants/auth.dart';
import 'package:starbucks/style/_theme.dart';
import 'package:starbucks/views/premium_page.dart';
import '../data/CoffeeItemList.dart';
import '../data/ProductTypeList.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _coffeeItemList = CoffeeItemList;
  final _productTypeList = ProductTypeList;
  var selectedItem = 'Espressos';
  int _counter = 0;

  late SharedPreferences _prefs;
  late String _nama;
   bool _isDark = false;

  @override
  void initState() {
    super.initState();
    getLocalData();
  }

  getLocalData() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _nama = _prefs.getString('username') ?? "";
      _isDark = _prefs.getBool('dark') ?? false;
    });
  }

  void _plusTotalItems() {
    setState(() {
      _counter++;
    });
  }

  void _minTotalItems() {
    setState(() {
      if (_counter <= 0) {
        _counter = 0;
      } else {
        _counter--;
      }
    });
  }

  void selectedProduct(prodName) {
    setState(() {
      selectedItem = prodName;
    });
  }

  Future getValidationLogin() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    var _obtainedLogin = _prefs.getBool('_isLogin');
    var _status;
    setState(() {
      _status = _obtainedLogin;
    });
    print(_status);
  }

  // String extractName(fullname) {
  //   final _firstname = fullname.split(" ")[0];
  //   final _capitalizeFirstName = _firstname[0].toUpperCase() + _firstname.toLowerCase().substring(1);
  //   return _capitalizeFirstName;
  // }

  @override
  Widget build(BuildContext context) {
    String _firstname = FirebaseAuth.instance.currentUser?.displayName ?? "User";

    return Scaffold(
        body: Container(
          color: _isDark ? Colors.black87 : Colors.white,
          child: ListView(
      children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.arrow_back),
                        color: _isDark ? textWhiteGrey : textBlack,
                        onPressed: () async {
                          AuthenticationService service = AuthenticationService(FirebaseAuth.instance);
                          _prefs.remove('login');
                          _prefs.remove('username');
                          service.logoutAccount();
                          service.logoutGoogle();
                          Navigator.pop(context);
                        }),
                    Container(
                      child: Row(
                        children: [
                          Text("Hallo, " , style: TextStyle(color: _isDark ? textWhiteGrey : textBlack, fontSize: 18, fontWeight: FontWeight.w500)),
                          Text(_firstname, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue),)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, right: 15.0),
                child: Stack(
                  children: [
                    Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.transparent),
                    ),
                    Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Color(0xFF116D51)),
                      child: Center(
                        child: Icon(
                          Icons.shopping_basket,
                          color: Colors.white,
                          size: 20.0,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 25.0,
                      right: 30.0,
                      child: Container(
                        height: 20.0,
                        width: 20.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.red),
                        child: InkWell(
                          onTap: _minTotalItems,
                          child: Center(
                              child: Text(
                            '$_counter',
                            style: TextStyle(
                                fontFamily: 'Raleway', color: Colors.white),
                          )),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0, top: 15.0, bottom: 10.0),
            child: Text(
              'Kategori Menu',
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 16.0,
                  color: _isDark ? textWhiteGrey : textBlack,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            height: 90.0,
            margin: EdgeInsets.only(left: 15.0, bottom: 10.0),
            // paste here
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              itemCount: _productTypeList.length,
              itemBuilder: (context, i) {
                return Container(
                  margin: EdgeInsets.only(right: 15.0),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: _productTypeList[i].type == selectedItem
                            ? Color(0xFF116D51)
                            : Colors.grey.withOpacity(0.3),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 4.0,
                              spreadRadius: 2.0,
                              color: _productTypeList[i].type == selectedItem
                                  ? Color(0xFF116D51).withOpacity(0.4)
                                  : Colors.transparent)
                        ]),
                    height: 50.0,
                    width: 125.0,
                    child: InkWell(
                      onTap: () {
                        selectedProduct(_productTypeList[i].type);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10.0, top: 10.0),
                            child: Text(
                              _productTypeList[i].type,
                              style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w700,
                                  color: _productTypeList[i].type == selectedItem
                                      ? Colors.white
                                      : _isDark ? textWhiteGrey : textBlack),
                            ),
                          ),
                          SizedBox(height: 7.0),
                          Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                _productTypeList[i].totalItemType.toString() + " Items",
                                style: TextStyle(
                                    fontFamily: 'Raleway',
                                    fontSize: 13.0,
                                    color: _productTypeList[i].type == selectedItem
                                        ? Colors.white
                                        : _isDark ? textWhiteGrey : textBlack),
                              ))
                        ],
                      ),
                    ),
                  ),
                );
              })
          ),
          Container(
            height: 370,
            child: ListView.builder(
                padding: EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: _coffeeItemList.length,
                itemBuilder: (context, i) {
                  return Container(
                      margin: EdgeInsets.only(right: 20.0),
                      width: 225.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 4.0,
                                blurRadius: 4.0)
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 200.0,
                            width: 225.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.0),
                                    topRight: Radius.circular(15.0)),
                                image: DecorationImage(
                                    image:
                                        NetworkImage(_coffeeItemList[i].imgPath),
                                    fit: BoxFit.cover)),
                          ),
                          SizedBox(height: 25.0),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                              _coffeeItemList[i].productName,
                              style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.0),
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                              _coffeeItemList[i].productType,
                              style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontSize: 14.0,
                                  color: Colors.grey),
                            ),
                          ),
                          SizedBox(height: 15.0),
                          Padding(
                              padding: EdgeInsets.only(left: 10.0, right: 10.0),
                              child: Container(
                                height: 0.4,
                                color: Colors.grey.withOpacity(0.4),
                              )),
                          SizedBox(height: 15.0),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$' + _coffeeItemList[i].price,
                                  style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19.0),
                                ),
                                InkWell(
                                  onTap: _plusTotalItems,
                                  child: Container(
                                    height: 40.0,
                                    width: 40.0,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15.0),
                                        color: Colors.grey.withOpacity(0.2)),
                                    child: Center(
                                      child: Icon(Icons.add, color: Colors.grey),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ));
                }),
          ),
      ],
    ),

        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );


  }
}
