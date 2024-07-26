import 'package:flutter/material.dart';
import 'package:frontend/account.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/widgets/navigation_drawer.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _dateCreated = TextEditingController();
  final TextEditingController _birthDate = TextEditingController();
  final TextEditingController _userType = TextEditingController();
  final TextEditingController _userID = TextEditingController();

  final TextEditingController _fname = TextEditingController();
  final TextEditingController _lname = TextEditingController();

  String totalWorkout = "";
  String totalTime = "";
  void initProfileInfo() {
    _userID.text = setup.id;
    _username.text = setup.name;
    _email.text = setup.email;
    _dateCreated.text = setup.dateCreated;
    _birthDate.text = setup.birthdate;
    _userType.text = setup.userType;
    _fname.text = setup.fname;
    _lname.text = setup.lname;

    totalTime = "69";
    totalWorkout = "69";
  }

  Widget progressField(
      BuildContext context, String field, String value, Icon icon) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: secondaryColor,
        border: Border.all(
          color: secondaryColor,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              Text(
                field,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget fields(BuildContext context, String field, String value,
      TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w200,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.white,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          height: 40,
          width: MediaQuery.of(context).size.width * 0.85,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: value,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initProfileInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      drawer: const NavigationDrawerContent(),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: tertiaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  children: [],
                ),
              ],
            ),
          ),
          Positioned(
            top: 100,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.blue,
                      child: Text(
                        'CN',
                        style: TextStyle(fontSize: 50, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            top: 55,
            left: 20,
            child: Text(
              "Profile Page",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const Header(
            isNotif: false,
            isProfile: false,
          ),
          Positioned(
            top: 250,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 640,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    fields(context, "Username", "", _username),
                    Center(
                      child: Container(
                        width: 308,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 150,
                              child:
                                  fields(context, "User Type", "", _userType),
                            ),
                            Spacer(),
                            Container(
                              width: 150,
                              child: fields(context, "User ID", "", _userID),
                            ),
                          ],
                        ),
                      ),
                    ),
                    fields(context, "Email", "", _email),
                    Center(
                      child: Container(
                        width: 308,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 150,
                              child: fields(context, "First Name", "", _fname),
                            ),
                            Spacer(),
                            Container(
                              width: 150,
                              child: fields(context, "Last Name", "", _lname),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 308,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 150,
                              child: fields(
                                  context, "Date Created", "", _dateCreated),
                            ),
                            Spacer(),
                            Container(
                              width: 150,
                              child:
                                  fields(context, "Birthdate", "", _birthDate),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        progressField(
                          context,
                          "Total Time(Hr):",
                          "4536",
                          const Icon(
                            Icons.timer,
                            color: Colors.white,
                            size: 15.0,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        progressField(
                          context,
                          "Total Workout:",
                          "4536",
                          const Icon(
                            Icons.fitness_center,
                            color: Colors.white,
                            size: 15.0,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
