import 'package:get/get.dart';
import 'package:rentify/utils/globals.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rentify/utils/image_constants.dart';
import 'package:rentify/views/filter_page.dart';

class MainAppbar extends StatelessWidget {
  const MainAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: hPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 42,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [getTheme(context).secondary.withValues(alpha: 0.3), Colors.white.withValues(alpha: 0.1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider("https://i.pinimg.com/1200x/69/78/19/69781905dd57ba144ab71ca4271ab294.jpg"),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: .center,
            children: [
              Text("Location"),
              Row(
                children: [
                  Text("Addis Aabab", style: TextStyle(fontWeight: FontWeight.bold)),
                  Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(FilterPage.route);
            },
            child: Container(
              width: 41,
              height: 39,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [getTheme(context).secondary.withValues(alpha: 0.3), Colors.white.withValues(alpha: 0.1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.asset(ImageConstants.notification, scale: 35, color: getTheme(context).onPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
