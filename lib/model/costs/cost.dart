part of '../model.dart';

class Cost {
  int? value;
  String? etd;
  String? note;

  Cost({this.value, this.etd, this.note});

  factory Cost.fromJson(Map<String, dynamic> json) => Cost(
        value: json['value'] as int?,
        etd: json['etd'] as String?,
        note: json['note'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'value': value,
        'etd': etd,
        'note': note,
      };

  // @override
  // bool operator ==(Object other) {
  //   if (identical(other, this)) return true;
  //   if (other is! Cost) return false;
  //   final mapEquals = const DeepCollectionEquality().equals;
  //   return mapEquals(other.toJson(), toJson());
  // }

  @override
  int get hashCode => value.hashCode ^ etd.hashCode ^ note.hashCode;

  get cost => null;

  get service => null;

  get description => null;
}
