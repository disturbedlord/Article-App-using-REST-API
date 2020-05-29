import 'package:atgapp/feedPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  Map<String, dynamic> data;
  var isLoading = false;
  String msg = "Invalid request";

  Future<int> _fetchData() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(
        "https://www.atg.party/ws-login-user?email=" +
            email.text +
            "&password=" +
            password.text);
    if (response.statusCode == 200) {
      data = json.decode(response.body);

      if (data["msg"] == "Login success") {
        Toast.show(data["msg"], context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

        setState(() {
          isLoading = false;
        });
        return 1;
      } else {
        Toast.show(data["msg"], context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        setState(() {
          isLoading = false;
        });
        return 0;
      }
    } else {
      throw Exception('Failed to load photos');
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1280);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 150.h, bottom: 150.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Image(
                        image: AssetImage("lib/images/logo.png"),
                        height: 150.h,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                margin: EdgeInsets.only(left: 30.w, right: 30.w),
                child: TextField(
                  controller: email,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.mail_outline),
                      labelText: "Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                ),
              ),
              SizedBox(height: 50.h),
              Container(
                margin: EdgeInsets.only(left: 30.w, right: 30.w),
                child: TextField(
                  controller: password,
                  obscureText: true,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline),
                      labelText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                ),
              ),
              SizedBox(
                height: 80.h,
              ),
              GestureDetector(
                onTap: () async {
                  int val = await _fetchData();
                  if (val == 1) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => feedPage()));
                  }
                },
                child: Container(
                  width: 300.w,
                  height: 130.h,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Center(
                    child: Text(
                      "LOGIN",
                      style: GoogleFonts.poppins(
                        fontSize: ScreenUtil().setSp(40),
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 25.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InContentPadding(
                    child: Text(
                      "Register",
                      style: GoogleFonts.poppins(
                          fontSize: ScreenUtil().setSp(30),
                          color: Colors.blueAccent,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => feedPage()));
                  },
                  child: Container(
                    child: Text(
                      "Guest",
                      style: GoogleFonts.poppins(
                          fontSize: ScreenUtil().setSp(30),
                          color: Colors.blueAccent,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class InContentPadding extends StatelessWidget {
  const InContentPadding({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 20.h, right: 20.h), child: child);
  }
}
