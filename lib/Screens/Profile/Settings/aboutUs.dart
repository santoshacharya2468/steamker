import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/utils/starAnimations.dart';

import '../../../utils/colors.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  Api? obj;
  Map<String, String> myStringWithLinebreaks = {
    "No Nudity or Sexual Content": '''
B4 Live expressly forbids our broadcasters from engaging in, or broadcasting any of the following sex-related content that promotes sexual activity, exploitation and/or assault. Sexually implied content or activities are also prohibited, although additional content may be permitted for educational content or pre-approved, but in each case, additional restrictions must be observed. Anything related to minors should be cautious and prohibit any content involving minor eroticism. We reserve the right to report misuse of inappropriate content to relevant law enforcement agencies.
      ''',
    "No Bullying & Harassment": '''
Regardless of whether the target is on B4 Live, we prohibit the use of B4 Live for all bullying, harassment and hate speech. We do not allow individuals, communities or organizations that perform such behavior to use our services. The type of this content, including but not limited to the following:

Discriminatory or humiliating remarks based on: race or ethnic origin, religion or faith, disability, gender, age, nationality, appearance or physical attributes, or sexual orientation/gender identity.
Displaying altered images of an individual meant to degrade that individual, or sharing photos or videos of physical bullying of a person for the purpose of shaming the victim.
Sharing/displaying personal info of an individual for the purpose of blackmail or harassment.
Profanity and/or vulgarity of any kind.
      ''',
    "No Illegal or Criminal Activities": '''
Contenting connection with the use, mention or display of illicit drugs and/or drug paraphernalia is strictly prohibited. Content highlighting tobacco and/or alcohol consumption by users is also strongly discouraged on B4 Live. Use good judgment, as we reserve the right to punish the account and work with law enforcement when we believe there is a legitimate risk of physical harm or direct threat to public safety, including but not limited to the following:

Content in connection with the use, mention or display of illicit drugs and/or drug paraphernalia.
Smoking or drinking during a broadcast.
Cause physical or financial harm to people, animals, property, or businesses directly or indirectly.
Used by or in the presence of a minor during a broadcast.
      ''',
    "No Violence": '''
B4 Live has zero tolerance for attempts or threats to harm or kill others. You are ultimately responsible for your own physical and psychological health and well-being, but as a community, we must be respectful of others who may be disturbed or offended by your Content or message. Therefore, we strictly prohibit the following behaviors, including but not limited to:

Advocate or encourage suicide and self-injury.
Promote or encourage physical violence, sensational or shocking acts that tend to cause harm or discomfort towards yourself / others / child or animals.
Dangerous or distracted driving.
Over-focusing on extreme or unreasonable bloody or violent content..
      ''',
    "No Private Content": '''
B4 Live respects the privacy of others, and we work hard to ensure that the information you share with us is secure. Determinations of unauthorized private Content will be determined on a case-by-case basis by B4 Live in our sole discretion. Please do the same and refrain from the use of Content which invades another person’s privacy or which divulges their private or confidential information. Examples of private information may include, but not limited to the following:

Personal addresses or locations that are considered or treated private, and/or non-public personal phone numbers and email addresses.
Social security or other national identity numbers or credit card information.
Intimate videos or photos taken or distributed without the subject’s consent.
Videos or images that are considered private under applicable laws.
      ''',
    "No Spamming": '''
B4 Live prohibits users from making commercial profit through our platform. Please do not use misleading or incorrect information, and please avoid the following behaviors, including but not limited to:

Deliberately collect likes, tracking Numbers, free virtual currency, or contact other users for commercial purposes without consent.
Advertise any product or service, whether it is legal or illegal, through live content or any user information, fields, etc.
Publish or distribute unauthorized ads, duplicate messages, or user reports.
Phishing.
Spread malware or viruses.
Sell or share user accounts;
Resell B4 Live services or features.
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
          "About Us",
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
