class GenerateListMetadata {
  final String listName;
  final DateTime startTime;
  final DateTime endTime;
  final int? guardTime;
  final int numberOfConcurrentGuards;
  final bool isFixedGuardTime;
  
  GenerateListMetadata(
    this.listName,
    this.startTime,
    this.endTime,
    this.guardTime,
    this.numberOfConcurrentGuards,
    this.isFixedGuardTime,
  );
}