// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'items.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Items _$ItemsFromJson(Map<String, dynamic> json) => Items(
      menuID: json['menuID'] as String?,
      sellersUID: json['sellersUID'] as String?,
      itemID: json['itemID'] as String?,
      title: json['title'] as String?,
      shortInfo: json['shortInfo'] as String?,
      publishedDate: (json['publishedDate'] as Timestamp),
      thumbnailUrl: json['thumbnailUrl'] as String?,
      longDescription: json['longDescription'] as String,
      status: json['status'] as String?,
      price: json['price'] as int?,
    );

Map<String, dynamic> _$ItemsToJson(Items instance) => <String, dynamic>{
      'menuID': instance.menuID,
      'sellersUID': instance.sellersUID,
      'itemID': instance.itemID,
      'title': instance.title,
      'shortInfo': instance.shortInfo,
      'publishedDate': Items._dateTimeToEpochUs(instance.publishedDate),
      'thumbnailUrl': instance.thumbnailUrl,
      'longDescription': instance.longDescription,
      'status': instance.status,
      'price': instance.price,
    };
