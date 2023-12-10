
class Event {
  final String eventName;
  final DateTime eventDate;
  final String eventTime;
  final String eventLocation;
  final String eventDetails;
  final int maleCounter;
  final int maleOrganizers;
  final int femaleCounter;
  final int femaleOrganizers;
  final String imageUrl;

  Event({
    required this.eventName,
    required this.eventDate,
    required this.eventTime,
    required this.eventLocation,
    required this.eventDetails,
    required this.maleCounter,
    required this.maleOrganizers,
    required this.femaleCounter,
    required this.femaleOrganizers,
    required this.imageUrl,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      eventName: map['eventName'],
      eventDate: map['eventDate'].toDate(),
      eventTime: map['eventTime'],
      eventLocation: map['eventLocation'],
      eventDetails: map['eventDetails'],
      maleCounter: map['maleCounter'],
      maleOrganizers: map['maleOrganizers'],
      femaleCounter: map['femaleCounter'],
      femaleOrganizers: map['femaleOrganizers'],
      imageUrl: map['imageUrl'],
    );
  }

}
