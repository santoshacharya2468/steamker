// @dart=2.9
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Models/userModel.dart';
import 'package:streamkar/Screens/Common/userProfile.dart';
import 'package:streamkar/Services/api.dart';

class Datasearch extends SearchDelegate<String> {
  Api obj;

  @override
  List<Widget> buildActions(BuildContext context) {
    // actions for app bar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // leading icon on the left of the app bar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //show results based on selection
    final suggestion = query.isEmpty ? "" : query;

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => SearchResults(query: suggestion),
          //   ),
          // );
        },
        leading: query.isEmpty ? null : Icon(Icons.search),
        title: RichText(
          text: TextSpan(
            text: suggestion.substring(0, query.length),
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: suggestion.substring(query.length),
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
      itemCount: 1,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //show when someone searches for something
    final suggestion = query.isEmpty ? "" : query;
    obj = Provider.of<Api>(context);

    List<UserModel> us = obj.appUsers
        .where((user) =>
            user.id.contains(suggestion) ||
            user.name.contains(suggestion) ||
            user.phone.toString() == suggestion)
        .toList();

    return ListView.builder(
        itemCount: us.length,
        itemBuilder: (context, i) {
          return InkWell(
            onTap: us[i].id == obj.userModel.id
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => UserProfile(
                          userModel: us[i],
                        ),
                      ),
                    );
                  },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 5),
                Container(
                  height: 60,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 55,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 23,
                                backgroundImage: NetworkImage(
                                  us[i].photoURL,
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    us[i].name,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 2),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                            color: Colors.green),
                                        child: Text(
                                          "Lv.1",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 8,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 2),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                            color: Colors.orange[300]),
                                        child: Text(
                                          "❤️ 0",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 8,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Last online:2 day(s) ago",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 1,
                          color: Colors.grey.withOpacity(0.2),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          );
        });
  }
}
