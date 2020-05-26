import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    print(email.text);
    final response =
    await http.get("https://www.atg.party/ws-login-user?email=" + email.text + "&password=" + password.text);
    if (response.statusCode == 200) {
      data = json.decode(response.body);

      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load photos');
    }
  }


  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 150.h , bottom: 150.h),
                child: Row(

                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Image(
                        image: AssetImage("lib/images/logo.png"),
                        height: 200.h,
                      ) ,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h,),
              Container(
                margin: EdgeInsets.only(left: 30.w , right: 30.w),
                child: TextField(
                  controller: email,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                          Icons.mail_outline
                      ),
                      labelText: "Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)
                      )
                  ),
                ),
              ),
              SizedBox(height: 50.h),
              Container(
                margin: EdgeInsets.only(left: 30.w , right: 30.w),
                child: TextField(
                  controller: password,
                  obscureText: true,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                          Icons.lock_outline
                      ),
                      labelText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)
                      )
                  ),
                ),
              ),
              SizedBox(height: 100.h,),
              GestureDetector(
                onTap: (){
                  _fetchData();
                },
                child: Container(
                  width: 500.w,
                  height: 130.h,
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(30.0)
                  ),
                  child: Center(
                    child: Text(
                      "LOGIN",
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.white,
                      ),
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
