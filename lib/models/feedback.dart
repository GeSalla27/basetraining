class FeedbackModal {
  final String status;
  final DateTime realizationDate;
  final String description;
  final String note;
  final String distance;
  final String time;
  final String pace;
  final String physicalEffort;
  final String externalLink;

  const FeedbackModal({
    this.status,
    this.realizationDate,
    this.description,
    this.note,
    this.distance,
    this.time,
    this.pace,
    this.physicalEffort,
    this.externalLink,
  });

  FeedbackModal.fromMap(Map snapshot)
      : status = snapshot['status'] ?? '',
        realizationDate = snapshot['realizationDate'].toDate() ?? '',
        description = snapshot['description'] ?? '',
        note = snapshot['note'] ?? '',
        distance = snapshot['distance'] ?? '',
        time = snapshot['time'] ?? '',
        pace = snapshot['pace'] ?? '',
        physicalEffort = snapshot['physicalEffort'] ?? '',
        externalLink = snapshot['externalLink'] ?? '';

  Map<String, dynamic> toJson() => {
        'status': status,
        'realizationDate': realizationDate,
        'description': description,
        'note': note,
        'distance': distance,
        'time': time,
        'pace': pace,
        'physicalEffort': physicalEffort,
        'externalLink': externalLink
      };

  @override
  String toString() {
    return super.toString();
  }
}
