import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'items.g.dart';

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}

@JsonSerializable()
class Items {
  String? menuID;
  String? sellersUID;
  String? itemID;
  String? title;
  String? shortInfo;
  @TimestampConverter()
  @JsonKey(fromJson: _dateTimeFromEpochUs, toJson: _dateTimeToEpochUs)
  Timestamp? publishedDate;
  String? thumbnailUrl;
  String? longDescription;
  String? status;
  int? price;

  static Timestamp _dateTimeFromEpochUs(int us) =>
      Timestamp.fromMicrosecondsSinceEpoch(us);

  static int? _dateTimeToEpochUs(Timestamp? timeStamp) =>
      timeStamp?.microsecondsSinceEpoch;

  Items({
    this.menuID,
    this.sellersUID,
    this.itemID,
    this.title,
    this.shortInfo,
    this.publishedDate,
    this.thumbnailUrl,
    this.longDescription,
    this.status,
    this.price,
  });

  factory Items.fromJson(Map<String, dynamic> json) => _$ItemsFromJson(json);

  Map<String, dynamic> toJson() => _$ItemsToJson(this);
}
