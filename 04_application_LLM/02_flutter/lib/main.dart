import 'package:flutter/material.dart';
import 'package:gdsc_ums_md/fine_tuned_page.dart';
import 'package:gdsc_ums_md/gpt_3_page.dart';
import 'package:gdsc_ums_md/home_page.dart';
import 'package:gdsc_ums_md/streaming_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Capstone MD',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        '/gpt-3': (context) => GPT3Page(),
        '/fine-tuned': (context) => FineTunedPage(),
        '/streaming': (context) => const StreamingPage()
      },
    );
  }
}
