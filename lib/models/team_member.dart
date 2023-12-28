class TeamMember {
  late String _name; // Use late to allow setting it later

  TeamMember({required String name}) {
    _name = name;
  }

  // Getter for the name property
  String get name => _name;

  // Setter for the name property
  set name(String newName) {
    _name = newName;
  }
}