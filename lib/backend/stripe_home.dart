import "package:flutter/material.dart";
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:scarletcart/backend/keys.dart';
import 'package:scarletcart/backend/stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripepublishablekey;
  await Stripe.instance.applySettings();

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(235, 253, 242, 1.0)),
      ),
      home: const PaymentsPage(),
    );
  }
  
}

