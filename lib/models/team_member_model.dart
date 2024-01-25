class TeamMemberModel {
  late String _name; // Use late to allow setting it later
  late bool _isEnabled;

  TeamMemberModel({required String name, required bool isEnabled}) {
    _name = name;
    _isEnabled = isEnabled;
  }

  // Getter for the name property
  String get name => _name;

  bool get isEnabled => _isEnabled;

  // Setter for the name property
  set name(String newName) {
    _name = newName;
  }

  set isEnabled(bool enabled) {
    _isEnabled = enabled;
  }
}