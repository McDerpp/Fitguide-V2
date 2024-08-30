import 'package:flutter/material.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/screens/notification_library.dart';
import 'package:frontend/screens/profile.dart';

class Header extends StatelessWidget {
  final bool isNotif;
  final bool isProfile;

  const Header({
    super.key,
    this.isNotif = true,
    this.isProfile = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 1.0),
          decoration: BoxDecoration(
            color: mainColor,
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        color: Colors.white,
                        icon: const Icon(Icons.menu),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        isNotif
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const NotificationLibrary()),
                              )
                            : null;
                      },
                      child: const Icon(
                        Icons.notifications,
                        color: Colors.white,
                        size: 25.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        isProfile
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Profile()),
                              )
                            : null;
                      },
                      child: const CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.blue,
                        child: Text(
                          'CN',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Container(
                        color: tertiaryColor,
                        height: MediaQuery.of(context).size.height * 0.001,
                        width: MediaQuery.of(context).size.width * 0.9),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
