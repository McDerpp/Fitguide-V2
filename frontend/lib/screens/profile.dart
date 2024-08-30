import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/account.dart';
import 'package:frontend/models/account.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/provider/provider.dart';
import 'package:frontend/services/accounts.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/widgets/navigation_drawer.dart';
import 'package:intl/intl.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _dateCreated = TextEditingController();
  final TextEditingController _birthDate = TextEditingController();
  final TextEditingController _userType = TextEditingController();
  final TextEditingController _userID = TextEditingController();

  final TextEditingController _height = TextEditingController();
  final TextEditingController _weight = TextEditingController();
  final TextEditingController _BMI = TextEditingController();
  final TextEditingController _BMIDetail = TextEditingController();

  final TextEditingController _fname = TextEditingController();
  final TextEditingController _lname = TextEditingController();

  bool isEdited = false;

  @override
  void initState() {
    super.initState();
    initProfileInfo();

    _username.addListener(() {
      setState(() {
        isEdited = true;
      });
    });

    _email.addListener(() {
      setState(() {
        isEdited = true;
      });
    });

    _dateCreated.addListener(() {
      setState(() {
        isEdited = true;
      });
    });

    _birthDate.addListener(() {
      setState(() {
        isEdited = true;
      });
    });

    _userType.addListener(() {
      setState(() {
        isEdited = true;
      });
    });

    _userID.addListener(() {
      setState(() {
        isEdited = true;
      });
    });

    _height.addListener(() {
      setState(() {
        isEdited = true;
      });
    });

    _weight.addListener(() {
      setState(() {
        isEdited = true;
      });
    });

    _BMI.addListener(() {
      setState(() {
        isEdited = true;
      });
    });

    _fname.addListener(() {
      setState(() {
        isEdited = true;
      });
    });

    _lname.addListener(() {
      setState(() {
        isEdited = true;
      });
    });
  }

  String totalWorkout = "";
  String totalTime = "";
  void initProfileInfo() {
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    _userID.text = setup.id;
    _userID.text = ref.read(accountFetchProvider).id.toString();

    _username.text = ref.read(accountFetchProvider).username;
    _email.text = ref.read(accountFetchProvider).email;
    _dateCreated.text = formatter
        .format(DateTime.parse(ref.read(accountFetchProvider).date_joined))
        .toString();

    _userType.text = ref.read(accountFetchProvider).userType;
    _fname.text = ref.read(accountFetchProvider).first_name;
    _lname.text = ref.read(accountFetchProvider).last_name;
    _height.text = ref.read(accountFetchProvider).height.toString();
    _weight.text = ref.read(accountFetchProvider).weight.toString();
    _BMI.text = ref.read(accountFetchProvider).bmi.toString();
    _BMIDetail.text = ref.read(accountFetchProvider).bmiDetail.toString();
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
      TextEditingController controller,
      {bool readOnly = false}) {
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
            color: readOnly ? Colors.grey[350]! : Colors.white,
            border: Border.all(
              color: readOnly ? Colors.grey[350]! : Colors.white,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          height: 40,
          width: MediaQuery.of(context).size.width * 0.85,
          child: TextField(
            readOnly: readOnly,
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      drawer: const NavigationDrawerContent(),
      body: Stack(
        children: [
          Column(
            children: [
              const Header(
                isNotif: false,
                isProfile: false,
              ),
              SizedBox(
                height: 15,
              ),
              Container(
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
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.blue,
                        child: Text(
                          '${setup.fname[0].toUpperCase()}${setup.lname[0].toUpperCase()}',
                          style: TextStyle(fontSize: 50, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        fields(context, "Username", "", _username,
                            readOnly: true),
                        Center(
                          child: Container(
                            width: 308,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 150,
                                  child: fields(
                                      context, "User Type", "", _userType,
                                      readOnly: true),
                                ),
                                Spacer(),
                                Container(
                                  width: 150,
                                  child: fields(
                                      context, "Date Created", "", _dateCreated,
                                      readOnly: true),
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
                                  child:
                                      fields(context, "First Name", "", _fname),
                                ),
                                Spacer(),
                                Container(
                                  width: 150,
                                  child:
                                      fields(context, "Last Name", "", _lname),
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
                                      context, "Height(cm)", "", _height),
                                ),
                                Spacer(),
                                Container(
                                  width: 150,
                                  child: fields(
                                      context, "Weight(kg)", "", _weight),
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
                                  child: fields(context, "BMI", "", _BMI,
                                      readOnly: true),
                                ),
                                Spacer(),
                                Container(
                                  width: 150,
                                  child: fields(
                                      context, "BMI Detail", "", _BMIDetail,
                                      readOnly: true),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        isEdited
                            ? ElevatedButton(
                                onPressed: () {
                                  AccountsApiService.updateUser(
                                      ref: ref,
                                      id: ref.read(accountFetchProvider).id,
                                      fname: _fname.text,
                                      lname: _lname.text,
                                      email: _email.text,
                                      userType: _userType.text,
                                      height: double.tryParse(_height.text)!,
                                      weight: double.tryParse(_weight.text)!);
                                  setState(() {
                                    isEdited = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(300, 5),
                                  foregroundColor: Colors.white,
                                  backgroundColor: tertiaryColor,
                                ),
                                child: const Text('Save changes'),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
