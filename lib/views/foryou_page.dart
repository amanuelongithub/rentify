import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yegnabet/controller/home_controller.dart';
import 'package:yegnabet/utils/globals.dart';
import 'package:yegnabet/utils/theme_data.dart';
import 'package:yegnabet/views/widgets/text_decoration.dart';

class ForYouPage extends StatefulWidget {
  const ForYouPage({super.key});

  @override
  State<ForYouPage> createState() => _ForYouPageState();
}

class _ForYouPageState extends State<ForYouPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: GetBuilder<HomeController>(
        builder: (_) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: hPadding),
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(kRadius), gradient: gradient(context)),
                  width: double.infinity,
                  height: 50,
                  child: TextField(
                    style: const TextStyle(color: AppTheme.textColor),
                    cursorColor: AppTheme.secondaryColor,
                    decoration: decorationText("Address, zip code, "),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
