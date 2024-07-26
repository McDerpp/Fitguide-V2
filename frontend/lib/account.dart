class AccountConfig {
  String name = '';
  String id = '';
  String userType = '';
  String email = '';
  String dateCreated = '';
  String birthdate = '';
  String fname = '';
  String lname = '';

  void updateFromApi(Map<String, dynamic> apiData) {
    name = apiData['user'] ?? name;
    id = apiData['id']?.toString() ?? id; // Ensure id is stored as a String
    userType = apiData['usertype'] ?? userType;
    email = apiData['email'] ?? email;
    fname = apiData['fname'] ?? fname;
    lname = apiData['lname'] ?? lname;
    dateCreated = apiData['joined'] ?? dateCreated;
  }
}

// Create a global instance of AccountConfig
AccountConfig setup = AccountConfig();
