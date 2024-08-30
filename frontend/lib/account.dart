class AccountConfig {
  String name = '';
  String id = '';
  String userType = '';
  String email = '';
  String dateCreated = '';
  String birthdate = '';
  String fname = '';
  String lname = '';
  String weight = '';
  String height = '';

  void updateFromApi(Map<String, dynamic> apiData) {
    name = apiData['user'] ?? name;
    id = apiData['id']?.toString() ?? id;
    userType = apiData['usertype'] ?? userType;
    email = apiData['email'] ?? email;
    fname = apiData['fname'] ?? fname;
    lname = apiData['lname'] ?? lname;
    dateCreated = apiData['joined'] ?? dateCreated;
    weight = apiData['weight'].toString();
    height = apiData['height'].toString();
  }
}

AccountConfig setup = AccountConfig();
