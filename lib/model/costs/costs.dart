part of '../model.dart';

//import 'cost.dart';

class Costs {
  String? service;
  String? description;
  List<Cost>? cost;

  Costs({this.service, this.description, this.cost});

  factory Costs.fromJson(Map<String, dynamic> json) => Costs(
        service: json['service'] as String?,
        description: json['description'] as String?,
        cost: (json['cost'] as List<dynamic>?)
            ?.map((e) => Cost.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'service': service,
        'description': description,
        'cost': cost?.map((e) => e.toJson()).toList(),
      };

  // @override
  // bool operator ==(Object other) {
  //   if (identical(other, this)) return true;
  //   if (other is! Costs) return false;
  //   final mapEquals = const DeepCollectionEquality().equals;
  //   return mapEquals(other.toJson(), toJson());
  // }

  @override
  int get hashCode => service.hashCode ^ description.hashCode ^ cost.hashCode;
}
