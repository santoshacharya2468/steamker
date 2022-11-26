// @dart=2.9
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Services/api.dart';

import '../../../utils/colors.dart';

class Bag extends StatefulWidget {
  const Bag({Key key}) : super(key: key);

  @override
  State<Bag> createState() => _BagState();
}

class _BagState extends State<Bag> {
  Api obj;
  bool first = true;
  bool loading = true;
  List<String> type = [];

  Future<void> fetchData() async {
    bool k = await obj.getStore();
    if (k) {
      setState(() {
        loading = false;
        obj.appStore.forEach((e) {
          if (!type.contains(e.category)) {
            type.add(e.category);
          }
        });
        obj.notify();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    obj = Provider.of<Api>(context);
    if (obj.appStore.length == 0) first = true;
    if (first) {
      loading = true;
      first = false;
      fetchData();
    }
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.32,
                color: purple,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          SizedBox(width: 15),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "My Bag",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Center(
                        child: Image.asset(
                          "assets/images/bag.png",
                          height: 100,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              for (var i = 0; i < type.length; i++)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        type[i].toUpperCase(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    for (var j = 0;
                        j <
                            obj.appStore
                                .where((e) => e.category == type[i])
                                .toList()
                                .length;
                        j++)
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, bottom: 10, right: 10),
                        child: Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            border: Border.all(color: Colors.black),
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            child: Image.network(
                              obj.appStore
                                  .where((e) => e.category == type[i])
                                  .toList()[j]
                                  .image,
                              // fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              Container(height: 50)
            ],
          ),
        ),
      ),
    );
  }
}
