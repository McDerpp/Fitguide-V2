import 'package:flutter/material.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/widgets/navigation_drawer.dart';
import 'package:frontend/widgets/notification_card.dart';

class NotificationLibrary extends StatefulWidget {
  const NotificationLibrary({super.key});

  @override
  State<NotificationLibrary> createState() => _NotificationLibraryState();
}

class _NotificationLibraryState extends State<NotificationLibrary> {
  List<Widget> notificationList = [
    NotificationCard(
      id: "090324",
    ),
    NotificationCard(
      id: "090324",
    ),
    NotificationCard(
      id: "090324",
    ),
    NotificationCard(
      id: "090324",
    ),
    NotificationCard(
      id: "090324",
    ),
    NotificationCard(
      id: "090324",
    ),
    NotificationCard(
      id: "090324",
    ),
    NotificationCard(
      id: "090324",
    ),
    NotificationCard(
      id: "090324",
    ),
    NotificationCard(
      id: "090324",
    ),
    NotificationCard(
      id: "090324",
    ),
    NotificationCard(
      id: "090324",
    ),
    NotificationCard(
      id: "090324",
    ),
    NotificationCard(
      id: "090324",
    ),
    NotificationCard(
      id: "090324",
    ),
    NotificationCard(
      id: "090324",
    ),
    NotificationCard(
      id: "090324",
    ),
    NotificationCard(
      id: "090324",
    ),
    NotificationCard(
      id: "090324",
    ),
    NotificationCard(
      id: "090324",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      drawer: const NavigationDrawerContent(),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.14,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: tertiaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Column(
              children: [
                Row(
                  children: [],
                ),
              ],
            ),
          ),
          const Positioned(
            top: 55,
            left: 20,
            child: Text(
              "Notification",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const Header(
            isNotif: false,
          ),
          Positioned(
            top: 108,
            child: Container(
              height: 640,
              child: SingleChildScrollView(
                child: Column(children: notificationList),
              ),
            ),
          )
        ],
      ),
    );
  }
}
