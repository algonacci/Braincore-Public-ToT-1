import 'package:flutter/material.dart';
import 'package:gdsc_ums_md/button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo GDSC UMS'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/gpt-3");
                },
                child: const Button(
                  text: "GPT-3",
                  icon: Icons.account_circle_rounded,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/fine-tuned");
                },
                child: const Button(
                  text: "Fine Tuned",
                  icon: Icons.bubble_chart_outlined,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/streaming");
                },
                child: const Button(
                  text: "Streaming",
                  icon: Icons.bubble_chart_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
