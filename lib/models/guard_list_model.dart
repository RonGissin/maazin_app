import 'assigned_team_member_model.dart';
import 'generate_list_metadata.dart';

class GuardListModel {
  String name;
  List<List<AssignedTeamMemberModel>> guardGroups;
  GenerateListMetadata metadata;

  GuardListModel({required this.name, required this.guardGroups, required this.metadata});
}
