
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starbucks/constants/auth.dart';
import 'package:starbucks/data/dummy_data.dart';
import 'package:starbucks/views/Homepage.dart';
import 'package:starbucks/views/RegisterPage.dart';
import 'package:starbucks/widgets/custom_checkbox.dart';
import 'package:starbucks/widgets/primary_button.dart';
import '../style/_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passwordVisible = false;
  var _dataUser = DummyData.data;
  bool _isLogin = false;
  bool _isDark = false;

  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  late SharedPreferences _prefs;

  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    getLocalData();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  getLocalData() async {
    _prefs = await SharedPreferences.getInstance();
    _isLogin = _prefs.getBool('login') ?? false;

    if (_isLogin == true) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: _isDark ? Colors.black87 : Colors.white,
            padding: EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Login to your\naccount',
                      style: heading2.copyWith(color: _isDark ? textWhiteGrey : textBlack),
                    ),
                    Spacer(),
                    IconButton(
                      color: _isDark ? textWhiteGrey : textBlack,
                      icon: Icon(Icons.light_mode_outlined),
                      onPressed: () async {
                        setState(() {
                          _isDark = !_isDark;
                          _prefs.setBool('dark', _isDark);
                        });
                      },
                      iconSize: 32,
                    ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // Image.asset(
                    //   'assets/images/login.png',
                    //   width: 99,
                    //   height: 4,
                    // ),
                  ],
                ),
                SizedBox(
                  height: 48,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: textWhiteGrey,
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                        child: Container(
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Username tidak boleh kosong';
                              }
                              return null;
                            },
                            controller: _usernameController,
                            decoration: InputDecoration(
                              hintText: 'Username',
                              hintStyle: heading6.copyWith(color: textGrey),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: textWhiteGrey,
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password tidak boleh kosong';
                            }
                            return null;
                          },
                          controller: _passwordController,
                          obscureText: !passwordVisible,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: heading6.copyWith(color: textGrey),
                            suffixIcon: IconButton(
                              color: textGrey,
                              splashRadius: 1,
                              icon: Icon(passwordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined),
                              onPressed: togglePassword,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomCheckbox(),
                    SizedBox(
                      width: 12,
                    ),
                    Text('Remember me', style: regular16pt.copyWith(color: _isDark ? textWhiteGrey : textBlack)),
                  ],
                ),
                SizedBox(
                  height: 32,
                ),
                GestureDetector(
                    onTap: () async {
                      AuthenticationService service = AuthenticationService(FirebaseAuth.instance);
                      String username = _usernameController.text;
                      String password = _passwordController.text;

                      service.signIn(email: username, password: password);

                      bool _showInvalid = false;
                      _dataUser.asMap().forEach((index, dataList) => {
                        if (_formKey.currentState!.validate()) {
                          if ((dataList["username"] == username) && (dataList["password"] == password)) {
                            _isLogin = !_isLogin,
                            _prefs.setBool('login', _isLogin),
                            _prefs.setString('username', dataList["nama"]),
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hallo, ${dataList["nama"]}'), duration: Duration(seconds: 2),)),
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage())),
                          } else {
                            _showInvalid = true
                          }
                        },
                      });

                      if (_showInvalid == true) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Username & Password salah'), duration: Duration(seconds: 2)));
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        color: Colors.blueAccent,
                      ),
                      child: Text("Login", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),),
                    )
                ),
                SizedBox(
                  height: 24,
                ),
                Center(
                  child: Text(
                    'OR',
                    style: heading6.copyWith(color: textGrey),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                GestureDetector(
                  onTap: () async {
                    AuthenticationService service = AuthenticationService(FirebaseAuth.instance);

                    if(await service.signInGoogle()){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sukses Login'), duration: Duration(seconds: 2)));
                    print(FirebaseAuth.instance.currentUser);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      color: Colors.grey.shade300,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network("https://www.freepnglogos.com/uploads/google-logo-png/google-logo-png-webinar-optimizing-for-success-google-business-webinar-13.png", height: 30, ),
                        SizedBox(width: 10,),
                        Text("Login with Google", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                      ],
                    ),
                  )
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: regular16pt.copyWith(color: textGrey),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()));
                      },
                      child: Text(
                        'Register',
                        style: regular16pt.copyWith(color: primaryBlue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }
}