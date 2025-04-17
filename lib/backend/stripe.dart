import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:scarletcart/backend/keys.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  double amount = 20;
  Map <String, dynamic>? intentPaymentData;

  showPaymentSheet() async
  {
    try 
    {
      await Stripe.instance.presentPaymentSheet().then((val){
        intentPaymentData = null;

      }).onError((errorMsg, sTrace){
        if (kDebugMode)
        {
          print(errorMsg.toString() + sTrace.toString());
        }
      });
    }
    on StripeException catch (error)
    {
       if (kDebugMode)
       {
          print (error); 
       }

      showDialog(
        context: context,
        builder: (c)=> const AlertDialog(
          content: Text("Cancelled"),
        )
      );
    }
    catch (errorMsg)
    {
      if (kDebugMode)
      {
        print (errorMsg);
      }

      print(errorMsg.toString());
    }
  }

  makeIntentForPayment(amountToBeCharged, currency) async
  {
    try
    {
      Map<String, dynamic>? paymentInfo = 
      {
        "amount": (int.parse(amountToBeCharged)*100).toString(),
        "currency": currency,
        "payment_method_types[]": "card",
      };

    var responseFromStripeAPI = await http.post(
      Uri.parse("https://api.stripe.com/v1/payment_intents"),
      body: paymentInfo,
      headers: 
      {
        "Authorization": "Bearer $stripesecretKey",
        "Content-Type": "application/x-www-form-urlencoded"
      }
    );
    print ("response from API = " +responseFromStripeAPI.body);
    
    return jsonDecode(responseFromStripeAPI.body);  
    }
    catch (errorMsg)
    {
      if (kDebugMode)
      {
        print(errorMsg);
      }
      print(errorMsg.toString());
  }
  }
  paymentSheetInitialization(amountToBeCharged, currency) async
  {
    try
    {
      intentPaymentData = await makeIntentForPayment(amountToBeCharged, currency);

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          allowsDelayedPaymentMethods: true,
          paymentIntentClientSecret: intentPaymentData!["client_secret"],
          style: ThemeMode.light,
          merchantDisplayName: "Company Name Example",
        )
      ).then((val)
      {
        print(val);
      });

      showPaymentSheet();
      
      
    }
    catch (errorMsg)
    {
      if (kDebugMode)
      {
        print(errorMsg.toString());
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(
          child: ElevatedButton(
            onPressed: (){
              paymentSheetInitialization(
                amount.round().toString(), 
                "USD",
            );
            },
            child: Text(
              "Pay Now USD ${amount.toString()}"
            )),
        ),
        ),
    );
}
}