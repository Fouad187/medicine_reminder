class Medicine {
  late List<dynamic> notificationIDs;
  late  String medicineName;
  late  String medicineType;
  late  int interval;
  late  String startTime;
  late  String userId;
  String? docId;

  Medicine({
    required this.notificationIDs,
    required this.medicineName,
    required this.medicineType,
    required this.startTime,
    required this.interval,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      "ids": notificationIDs,
      "name": medicineName,
      "type": medicineType,
      "interval": interval,
      "start": startTime,
      "userId":userId,
    };
  }

  factory Medicine.fromJson(Map<String, dynamic> parsedJson) {
    return Medicine(
      notificationIDs: parsedJson['ids'],
      medicineName: parsedJson['name'],
      medicineType: parsedJson['type'],
      interval: parsedJson['interval'],
      startTime: parsedJson['start'],
      userId: parsedJson['userId'],
    );
  }
}
