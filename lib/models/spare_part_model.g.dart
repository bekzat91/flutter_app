// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spare_part_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SparePartModel _$SparePartModelFromJson(Map<String, dynamic> json) =>
    SparePartModel(
      json['brand'] as String,
      json['amount'] as int,
      json['original'] as bool,
      json['part_num'] as String,
      json['top'] as bool,
      json['vcurrency'] as String,
    );

Map<String, dynamic> _$SparePartModelToJson(SparePartModel instance) =>
    <String, dynamic>{
      'brand': instance.brand,
      'amount': instance.amount,
      'original': instance.original,
      'part_num': instance.part_num,
      'top': instance.top,
      'vcurrency': instance.vcurrency,
    };
