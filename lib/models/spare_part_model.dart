import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'spare_part_model.g.dart';

@JsonSerializable()

//spare part model
class SparePartModel extends Equatable {
  final String brand;
  final int amount;
  final bool original;
  final String part_num;
  final bool top;
  final String vcurrency;

  SparePartModel(
    this.brand,
    this.amount,
    this.original,
    this.part_num,
    this.top,
    this.vcurrency,
  );

  factory SparePartModel.fromJson(Map<String, dynamic> json) =>
      _$SparePartModelFromJson(json);

  Map<String, dynamic> toJson() => _$SparePartModelToJson(this);

  @override
  // TODO: implement props
  List<Object?> get props =>
      [brand, amount, original, part_num, top, vcurrency];
}
