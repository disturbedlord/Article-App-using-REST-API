import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:atgapp/fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';

class feedPage extends StatefulWidget {
  @override
  _feedPageState createState() => _feedPageState();
}

class _feedPageState extends State<feedPage> {
  // print("fetching...");
  Map<String, dynamic> data;
  bool dataLoaded = false;
  static int index = 0;
  List<Widget> tags = new List<Widget>();
  List<Widget> groups = new List<Widget>();
  SwiperController controller = new SwiperController();
  String mainData = "";
  bool profileImageExist;
  bool profilePictureExist;
  int dir = 0;
  int liked = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData(index);
    print("fetching...");
  }

  void resetVariables() {
    data = new Map<String, dynamic>();
    dataLoaded = false;
    tags = new List<Widget>();
    groups = new List<Widget>();
    mainData = "";
    profileImageExist = false;
    profilePictureExist = false;
    liked = 0;
  }

  void conCat(String s) {
    if (s == " " && s[s.length - 1] != "\n") {
      mainData += "\n";
    } else
      mainData += s;
  }

  void fetchData(int index) async {
    data = await getArticles(index);
    if (data.length > 1) {
      // validate profile Image
      // profileImageExist = validateImage(data["profile_image"]);

      // // validate profile picture
      // profilePictureExist = validateImage(data["profile_picture"]);
      Timer(
        Duration(seconds: 1),
        () => {
          setState(
            () {
              dataLoaded = true;

              dynamic desc = data["description"];

              // fill the main Content
              for (int i = 0; i < desc.length; i++) {
                if (i == desc.length - 1 && desc[i]["data"] == " ") continue;
                conCat(desc[i]["data"]);
                // conCat(desc[i]);
              }

              // fill the groups section
              for (int i = 0; i < data["groups"].length; i++) {
                groups.add(
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20.h),
                      ),
                      child: Text(
                        data["groups"][i]["group_name"],
                        style: GoogleFonts.poppins(
                            fontSize: ScreenUtil().setSp(30)),
                      ),
                    ),
                  ),
                );
              }

              if (groups.length == 0) {
                groups.add(Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20.h),
                    ),
                    child: Text(
                      "Dummy Text",
                      style:
                          GoogleFonts.poppins(fontSize: ScreenUtil().setSp(30)),
                    ),
                  ),
                ));
              }
              // fill the tags section
              for (int i = 0; i < data["tags"].length; i++) {
                tags.add(
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Container(
                      // height: 200.h,
                      padding: EdgeInsets.only(
                          top: 10.h, bottom: 10.h, left: 15.h, right: 15.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.h),
                          border: Border(
                              bottom: BorderSide(color: Colors.grey),
                              top: BorderSide(color: Colors.grey),
                              left: BorderSide(color: Colors.grey),
                              right: BorderSide(color: Colors.grey))),
                      child: Center(
                          child: Text(
                        data["tags"][i]["tag_name"],
                        style: GoogleFonts.poppins(
                            fontSize: ScreenUtil().setSp(30)),
                      )),
                    ),
                  ),
                );
              }

              if (tags.length == 0) {
                tags.add(Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Container(
                    // height: 200.h,
                    padding: EdgeInsets.only(
                        top: 10.h, bottom: 10.h, left: 15.h, right: 15.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.h),
                        border: Border(
                            bottom: BorderSide(color: Colors.grey),
                            top: BorderSide(color: Colors.grey),
                            left: BorderSide(color: Colors.grey),
                            right: BorderSide(color: Colors.grey))),
                    child: Center(
                      child: Text(
                        "Dummy Tag",
                        style: GoogleFonts.poppins(
                            fontSize: ScreenUtil().setSp(30)),
                      ),
                    ),
                  ),
                ));
              }

              profileImageExist = data["profile_image"] == "" ? false : true;
              profilePictureExist =
                  data["profile_picture"] == "" ? false : true;
            },
          )
        },
      );
    } else {
      print("Could not load data");
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1280);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: Text(
            "Feed",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () async {},
              icon: Icon(
                Icons.share,
                color: Colors.black,
              ),
            )
          ],
        ),
        body: Swiper(
          onIndexChanged: (v) {
            setState(() {
              dataLoaded = false;
            });
            print(v);
            index = v;
            if (index < 10)
              index = index;
            else
              index = 0;
            resetVariables();
            fetchData(index);
          },
          controller: controller,
          itemBuilder: (BuildContext context, int index) {
            return dataLoaded == false
                ? Center(
                    child: Container(
                      height: 100.h,
                      width: 100.h,
                      child: LoadingIndicator(
                        indicatorType: Indicator.ballBeat,
                        color: Colors.black,
                      ),
                    ),
                  )
                : Container(
                    child: ListView(
                    children: <Widget>[
                      Container(
                        child: profileImageExist == true
                            ? Image(
                                image: NetworkImage(data["profile_image"]),
                              )
                            : Container(),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 20.h, left: 20.h, right: 20.h),
                        child: TitleWidget(title: data["title"]),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      InContentPadding(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 50.h,
                                  backgroundColor: Colors.greenAccent,
                                  child: CircleAvatar(
                                    radius: 45.h,
                                    backgroundImage: profilePictureExist == true
                                        ? NetworkImage(data["profile_picture"])
                                        : AssetImage(
                                            "lib/images/user-placeholder.png"),
                                  ),
                                ),
                                SizedBox(
                                  width: 15.w,
                                ),
                                AuthorText(
                                  txt: data["name"],
                                  color: Colors.black,
                                  fontSize: ScreenUtil().setSp(30),
                                ),
                                SizedBox(
                                  width: 15.w,
                                ),
                                data["min_read"] != ""
                                    ? FaIcon(
                                        FontAwesomeIcons.circle,
                                        color: Colors.grey,
                                        size: 20.h,
                                      )
                                    : Container(),
                                SizedBox(
                                  width: 15.w,
                                ),
                                AuthorText(
                                  txt: data["min_read"],
                                  color: Colors.grey,
                                  fontSize: ScreenUtil().setSp(30),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      InContentPadding(
                        child: Text(
                          mainData,
                          style: GoogleFonts.poppins(
                              fontSize: ScreenUtil().setSp(34)),
                        ),
                      ),
                      SizedBox(height: 25.h),
                      Container(
                        height: 130.h,
                        child: ListView(
                          shrinkWrap: true,
                          // This next line does the trick.
                          scrollDirection: Axis.horizontal,
                          children: tags,
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      InContentPadding(
                        child: Text("Groups",
                            style: GoogleFonts.poppins(
                                fontSize: ScreenUtil().setSp(35),
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(height: 25.h),
                      Wrap(
                        children: groups,
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      InContentPadding(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text("16k likes",
                                    style: GoogleFonts.rubik(
                                        fontSize: ScreenUtil().setSp(30),
                                        color: Colors.blueAccent)),
                                SizedBox(
                                  width: 15.w,
                                ),
                                Text("26 Comments",
                                    style: GoogleFonts.rubik(
                                        fontSize: ScreenUtil().setSp(30),
                                        color: Colors.blueAccent)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {},
                                  child: Icon(
                                    FontAwesomeIcons.thumbsUp,
                                    size: 45.h,
                                  ),
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Icon(
                                    FontAwesomeIcons.thumbsDown,
                                    size: 45.h,
                                  ),
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Icon(
                                    FontAwesomeIcons.ellipsisV,
                                    size: 45.h,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(15.h),
                          child: TextField(
                            decoration: InputDecoration(
                                labelText: "Comment...",
                                labelStyle: GoogleFonts.poppins(
                                    fontSize: ScreenUtil().setSp(35)),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                suffixIcon: IconButton(
                                    onPressed: () {}, icon: Icon(Icons.send)),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    // radius: ,
                                    backgroundImage: profilePictureExist
                                        ? NetworkImage(data["profile_picture"])
                                        : AssetImage(
                                            "lib/images/user-placeholder.png"),
                                  ),
                                )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      InContentPadding(
                        child: Container(
                          child: Text("Comments",
                              style: GoogleFonts.poppins(
                                  fontSize: ScreenUtil().setSp(40),
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      CommentWidget(),
                      SizedBox(
                        height: 25.h,
                      ),
                      CommentWidget(),
                      SizedBox(
                        height: 25.h,
                      ),
                      CommentWidget(),
                      SizedBox(
                        height: 25.h,
                      ),
                    ],
                  ));
          },
          itemCount: 10,
        ),
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  const CommentWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InContentPadding(
      child: Container(
        height: 120.h,
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(20.h)),
      ),
    );
  }
}

class AuthorText extends StatelessWidget {
  const AuthorText(
      {Key key,
      @required this.txt,
      @required this.color,
      @required this.fontSize})
      : super(key: key);
  final String txt;
  final Color color;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: GoogleFonts.poppins(
        fontSize: fontSize,
        color: color,
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
        padding: EdgeInsets.only(left: 20.w, right: 20.w), child: child);
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.poppins(
          fontSize: ScreenUtil().setSp(44), fontWeight: FontWeight.bold),
    );
  }
}
