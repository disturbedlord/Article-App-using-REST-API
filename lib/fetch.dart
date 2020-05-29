import 'package:http/http.dart' as http;
import 'dart:convert';

List<String> articleId = [
  "33100",
  "33101",
  "33102",
  "33103",
  "33104",
  "33105",
  "33106",
  "33107",
  "33108",
  "33109",
];

Future<bool> validateImage(String url) async {
  if (url == "" || url == " ") {
    return false;
  }

  final img = await http.get(url);
  if (img.statusCode == 200) {
    return true;
  }
  return false;
}

Future<Map<String, dynamic>> getArticles(int index) async {
  if (index == 0) return tempData();

  print("calleddd");
  String apiLink =
      "https://www.atg.party/ws-feed-detail?user_id=83&feed_id=${articleId[index - 1]}&type=article";
  Map<String, dynamic> data;

  Map<String, dynamic> returnData = new Map<String, dynamic>();

  try {
    final response = await http.get(apiLink);

    print(response.statusCode);
    if (response.statusCode == 200) {
      data = json.decode(response.body);
      if (data.length == 2) print(data["message"]);
      print(data);
      if (data["msg"] == "Success") {
        data = data["PostDetail"];
        returnData["title"] = data["title"];
        returnData["profile_image"] = data["profile_image"];
        returnData["profile_picture"] = data["profile_picture"];
        returnData["name"] = data["first_name"] + " " + data["last_name"];
        returnData["description"] = data["description"];
        returnData["tags"] = data["arr_tag"];
        returnData["groups"] = data["posted_by"];
        returnData["min_read"] = data["min_read"];
        print(data["groups"]);
        return returnData;
      }
    }
  } catch (e) {
    print("internet Issue");
  }
  return {"msg": "Invalid Request"};
}

Future<Map<String, dynamic>> tempData() async {
  Map<String, dynamic> data = new Map<String, dynamic>();

  data["title"] = "Rockwood Energy Search: Best Energy Recruiter Agency in US";
  data["profile_image"] = await validateImage(
          "https://pagedesignshop.com/wp-content/uploads/2018/06/write.jpg")
      ? "https://pagedesignshop.com/wp-content/uploads/2018/06/write.jpg"
      : "";
  data["profile_picture"] = await validateImage(
          "https://s3.ap-south-1.amazonaws.com/atg-test-s3/assets/Frontend/user/profile_pics/83/thumb/1523276847.png")
      ? "https://s3.ap-south-1.amazonaws.com/atg-test-s3/assets/Frontend/user/profile_pics/83/thumb/1523276847.png"
      : "";

  data["name"] = "Saurabh Bassi";
  data["description"] = [
    {
      "data":
          "Energy recruitment is one of the first places a top tiered employee goes if he or she is looking to make a career move. Many of these executives are already well known in their respective industries and for an employee at these level, positions like these are generally communicated through elite circles and rarely ever hit the mass job market. The great advantage of having energy recruiters is it is at no cost to the client, but will cost the employer a percentage of what the base salary will be for the hired future employee. This is one of the reasons why so many gifted individuals prefer going to an executive recruiter right from the beginning. Finding the right recruiter that will listen to the needs and wants of the clients is just as important and should be the ideal fit for both the employer and employee.",
      "type": "text"
    },
    {"data": " ", "type": "text"},
    {"data": " ", "type": "text"},
    {"data": " ", "type": "text"},
    {
      "data":
          "Meeting with any energy recruiters can make anyone nervous but it is important to put one's best foot forward and make a lasting impression so they stand out from the rest of the crowd. Getting enough rest the night before can help make the situation a calmer and pleasant experience for everyone involved. An executive recruiter's job is not an easy one when it comes to bringing forward the best talents to any firm. He or she will have to thoroughly screen each and every applicant who fits the requirements, as well as check references and interview the potential employee. This can be a very time consuming and stressful process especially if there is a deadline to meet. Finding the right person to work with when one is job hunting can be a very stressful time, but it would alleviate that stress if the individual has found the perfect recruiter who can come up with many choices and options.",
      "type": "text"
    },
    {"data": " ", "type": "text"},
    {"data": " ", "type": "text"},
    {"data": " ", "type": "text"},
    {
      "data":
          "In any world class working environment there is always a human resources division who handles executive recruitment. Some of these individuals require additional outside resources and will work with many different agencies to see what kind of candidates they can come up with. This is most important for any firm that is in search for a top shelf mover and shaker. In the end, going through a recruitment agency is the best method to go about benefiting your situation, because you are not simply looking for a job as you're looking for a career. The energy recruiters can help you achieve this task, and find what is best suited for your wants and needs.",
      "type": "text"
    },
    {"data": " ", "type": "text"},
    {"data": " ", "type": "text"},
    {"data": " ", "type": "text"}
  ];

  data["tags"] = [
    {"tag_name": "Energy recruiters"},
    {"tag_name": " solar energy jobs"},
    {"tag_name": " solar site selection"},
    {"tag_name": " solar permitting"},
    {"tag_name": " energy jobs"}
  ];
  data["groups"] = [
    {
      "group_name": "Human Resource",
      "id": 212,
      "icon_img":
          "https://s3.ap-south-1.amazonaws.com/atg-test-s3/assets/Backend/img/group_img/icon/thumb/human resource.PNG"
    },
    {
      "group_name": "Career Counselling",
      "id": 321,
      "icon_img":
          "https://s3.ap-south-1.amazonaws.com/atg-test-s3/assets/Backend/img/group_img/icon/thumb/career counselling_iconpng"
    }
  ];
  data["min_read"] = "47 sec read";

  return data;
}
