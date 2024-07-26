import 'package:flutter/material.dart';
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
        Positioned(
          top: 18,
          left: 5.0,
          child: Builder(
            builder: (context) => IconButton(
              color: Colors.white,
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ),
        Positioned(
          top: 30,
          right: 10,
          child: Row(
            children: [
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
              const SizedBox(
                width: 15,
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
        ),
      ],
    );
  }
}
