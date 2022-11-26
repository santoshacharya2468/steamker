// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/Services/paypal.dart';
import 'package:streamkar/utils/colors.dart';
import 'package:streamkar/utils/dialog.dart';
import 'package:streamkar/utils/validators.dart';

class TopUp extends StatefulWidget {
  const TopUp({Key key}) : super(key: key);

  @override
  State<TopUp> createState() => _TopUpState();
}

class _TopUpState extends State<TopUp> {
  Api obj;
  @override
  Widget build(BuildContext context) {
    obj = Provider.of<Api>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
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
                            "Top Up",
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
                        child: Column(
                          children: [
                            Container(
                              height: 100,
                              color: Colors.transparent,
                              child: Image.asset(
                                "assets/icons/beans.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Available Beans: ${obj.userModel.beans}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Account ID: ${obj.userModel.name}"),
                  ],
                ),
              ),
              Container(
                height: 3,
                color: Colors.grey.shade400,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            Wallet(type: 'google'),
                      ),
                    );
                  },
                  child: Image.asset(
                    "assets/images/googleTopUp.png",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            Wallet(type: 'paypal'),
                      ),
                    );
                  },
                  child: Image.asset(
                    "assets/images/paypalTopUp.png",
                  ),
                ),
              ),
              // Container(
              //   padding: EdgeInsets.all(20),
              //   child: Center(
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         ElevatedButton(
              //           onPressed: () {
              //             // make PayPal payment

              //             Navigator.of(context).push(
              //               MaterialPageRoute(
              //                 builder: (BuildContext context) =>
              //                     Wallet(type: 'google'),
              //               ),
              //             );
              //           },
              //           child: Text(
              //             'Pay with Google Pay',
              //             textAlign: TextAlign.center,
              //           ),
              //         ),
              //         SizedBox(
              //           height: 20,
              //         ),
              //         ElevatedButton(
              //           onPressed: () {
              //             // make PayPal payment

              //             Navigator.of(context).push(
              //               MaterialPageRoute(
              //                 builder: (BuildContext context) =>
              //                     Wallet(type: 'paypal'),
              //               ),
              //             );
              //           },
              //           child: Text(
              //             'Pay with Paypal',
              //             textAlign: TextAlign.center,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

class Wallet extends StatefulWidget {
  final String type;
  const Wallet({Key key, @required this.type}) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  Map<double, List<int>> prices;

  Api obj;
  TextEditingController amountController = TextEditingController();
  final _paymentItems = [
    PaymentItem(
      label: 'Total',
      amount: '1.99',
      status: PaymentItemStatus.final_price,
    ),
  ];
  void onGooglePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }

  @override
  void initState() {
    if (widget.type == 'paypal') {
      setState(() {
        prices = {
          1: [6000, 3000],
          5: [30000, 15000],
          10: [60000, 30000],
          30: [180000, 90000],
          50: [300000, 150000],
          100: [600000, 300000],
        };
      });
    } else {
      setState(() {
        prices = {
          1.09: [3500, 2300],
          5.49: [17500, 11500],
          10.99: [35000, 23000],
          21.99: [70000, 46000],
          54.99: [175000, 115000],
          109.99: [350000, 230000],
          164.99: [525000, 345000],
        };
      });
    }
    super.initState();
  }

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
          widget.type.toUpperCase(),
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: prices.length,
                itemBuilder: (context, i) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/icons/beans.png",
                                    height: 40,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: prices.values
                                          .toList()[i]
                                          .first
                                          .toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text:
                                              "  + ${prices.values.toList()[i].last.toString()} Bonus",
                                          style: TextStyle(
                                            color: Colors.yellow,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            setState(() {
                                              amountController.text = prices
                                                  .keys
                                                  .toList()[i]
                                                  .toString();
                                            });
                                          },
                                          child: Container(
                                            width: 100,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: pink,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                  width: 2,
                                                  color: Colors.white),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "€ ${prices.keys.toList()[i].toString()}",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  letterSpacing: 0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 1,
                                color: Colors.grey[300],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextFormField(
                    validator: (e) => numberValidator(e),
                    controller: amountController,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 20),
                      filled: true,
                      fillColor: Colors.transparent,
                      hintText: "Other Amount",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20)),
                      hintStyle: TextStyle(
                        fontSize: 17.0,
                        color: Colors.grey.shade700,
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          width: 70,
                          child: Center(
                            child: Image.asset(
                              "assets/icons/beans.png",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Please enter amount betweem 1 - 500",
                  style: TextStyle(
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
              widget.type != 'paypal'
                  ? Center(
                      child: GooglePayButton(
                        width: 300,
                        paymentConfigurationAsset: 'googlePay.json',
                        paymentItems: _paymentItems,
                        style: GooglePayButtonStyle.black,
                        type: GooglePayButtonType.pay,
                        margin: const EdgeInsets.only(top: 15.0),
                        onPaymentResult: onGooglePayResult,
                        loadingIndicator: const Center(
                          child: CircularProgressIndicator(),
                        ),
                        onPressed: () {
                          setState(() {
                            _paymentItems.clear();
                            _paymentItems.add(PaymentItem(
                              label: 'Total',
                              amount: amountController.text ?? '1.09',
                              status: PaymentItemStatus.final_price,
                            ));
                          });
                        },
                      ),
                    )
                  : InkWell(
                      onTap: () async {
                        double quantity;
                        if (double.parse(amountController.text) < 1)
                          return;
                        else {
                          if (!['1', '5', '10', '30', '50', '100']
                              .contains(amountController.text)) {
                            quantity =
                                double.parse(amountController.text) * 9000.0;
                          } else {
                            quantity = double.parse((prices[
                                            double.parse(amountController.text)]
                                        .first +
                                    prices[double.parse(amountController.text)]
                                        .first)
                                .toString());
                          }
                        }
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => PaypalPayment(
                              price: double.parse(
                                  double.parse(amountController.text)
                                      .toString()),
                              onFinish: (number) async {
                                // payment done
                                bool k =
                                    await obj.updateBeans(by: quantity.toInt());
                                if (k) {
                                  CustomSnackBar(
                                      context,
                                      Text(
                                          "order id: $number, Payment Successful"));
                                }
                              },
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          decoration: BoxDecoration(
                            color: pink,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(width: 2, color: Colors.white),
                          ),
                          child: Center(
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                letterSpacing: 0,
                              ),
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
