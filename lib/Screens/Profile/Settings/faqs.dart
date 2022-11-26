import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/utils/starAnimations.dart';

import '../../../utils/colors.dart';

class Faqs extends StatefulWidget {
  const Faqs({Key? key}) : super(key: key);

  @override
  State<Faqs> createState() => _FaqsState();
}

class _FaqsState extends State<Faqs> {
  Api? obj;
  Map<String, String> myStringWithLinebreaks = {
    "Account Basics": '''
1. How do I sign up?
Users can sign up via Facebook, Instagram, Twitter and Google Account (for the purpose of authenticating accounts and providing a better social experience).

2.How to change my personal information?
You can change profile picture directly by clicking it on the profile and user name by the Edit option available on the profile page.

3. Can I use the B4 Live logo as my profile picture?
Unfortunately, we prohibit use of our official logo, name or likeness as part of a user's account information.

4. How do I follow a talent?
Simply click the "+" button in the upper left hand corner of a talent's showroom and you will be following them. That's it.

      ''',
    "Level": '''
1. What is "wealth level"?
The wealth level ranks of the standard users who have spent the most beans. The more beans a user has spent, the higher their wealth level.

2. What is "star level"?
The star level ranks talents based on how many gifts they have received. The talent with the highest "star level" rank has received the most virtual currency gifts.
      ''',
    "Beans, Gems, Gifts and Cash Out": '''
2. How do I buy beans?
You may purchase beans by visiting your profile page and tapping on “Top-up”.

3. What are Beans and Gems?
Beans are the virtual currency of the B4 Live platform. They can be used to send gifts to B4 Live talents, purchase VIP packages or any other service available on our platform. Gems are received through gifting. Once you have enough gems, you can convert them back into beans.

4. I bought beans, but never received them!
If you have purchased beans on B4 Live but they have not showed up in your account, we are happy to help. Please provide us the receipt from PayPal, PayTM, Easypaisa, App Store, Google Play store, as well as a screenshot of your profile page for us to track your order quickly.

5. Why have some gift options disappeared from the Gift Shop?
We have many gift ideas, but due to the limited availability of the gift shop slots, we may replace some gifts with new ones from time to time. Please try out the new ones that are equally fun!.
      ''',
    "Shop": '''
1. What is the purpose of shop?
There are some features in the shop like Garage, VIP, Guardian. By purchasing these features you can make your appearance in B4 Live more entertaining.
      ''',
    "Free Points": '''
1. How can I get free points in app? what are the benefits?
You can get points by doing daily task. For daily task you can visit “My task” option on your profile page as well as in play center. Each task has its own points and by completing those task will provide you some points which can be used to send gifts to your favorite talents,these points will not count in talents/users earning. Moreover, these points will increase crown level of talents & wealth level of users.
      ''',
  };

  @override
  Widget build(BuildContext context) {
    obj = Provider.of<Api>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: 16,
            color: Colors.black,
          ),
        ),
        title: Text(
          "FAQ",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: myStringWithLinebreaks.length,
        itemBuilder: ((context, index) {
          return ListTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                myStringWithLinebreaks.keys.toList()[index],
                style: TextStyle(color: pink, fontWeight: FontWeight.bold),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: LineSplitter.split(
                        myStringWithLinebreaks.values.toList()[index])
                    .map((o) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          o,
                          style: TextStyle(
                            color: Colors.grey.shade800,
                          ),
                        ),
                      )
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        }),
      ),
    );
  }
}
