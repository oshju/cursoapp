// To parse this JSON data, do
//
//    final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

class Welcome {
  Welcome({
    this.version,
    this.user,
    this.dateGenerated,
    this.status,
    this.data,
  });

  final String? version;
  final String? user;
  final DateTime? dateGenerated;
  final String? status;
  final List<Datum>? data;

  Welcome copyWith({
    String? version,
    String? user,
    DateTime? dateGenerated,
    String? status,
    List<Datum>? data,
  }) =>
      Welcome(
        version: version ?? this.version,
        user: user ?? this.user,
        dateGenerated: dateGenerated ?? this.dateGenerated,
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory Welcome.fromRawJson(String str) => Welcome.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    version: json["version"],
    user: json["user"],
    dateGenerated: DateTime.parse(json["dateGenerated"]),
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "version": version,
    "user": user,
    "dateGenerated": dateGenerated!.toIso8601String(),
    "status": status,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.parameter,
    this.coordinates,
  });

  final String? parameter;
  final List<Coordinate>? coordinates;

  Datum copyWith({
    String? parameter,
    List<Coordinate>? coordinates,
  }) =>
      Datum(
        parameter: parameter ?? this.parameter,
        coordinates: coordinates ?? this.coordinates,
      );

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    parameter: json["parameter"],
    coordinates: List<Coordinate>.from(json["coordinates"].map((x) => Coordinate.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "parameter": parameter,
    "coordinates": List<dynamic>.from(coordinates!.map((x) => x.toJson())),
  };
}

class Coordinate {
  Coordinate({
    this.lat,
    this.lon,
    this.dates,
  });

  final double? lat;
  final double? lon;
  final List<Date>? dates;

  Coordinate copyWith({
    double? lat,
    double? lon,
    List<Date>? dates,
  }) =>
      Coordinate(
        lat: lat ?? this.lat,
        lon: lon ?? this.lon,
        dates: dates ?? this.dates,
      );

  factory Coordinate.fromRawJson(String str) => Coordinate.fromJson(json.decode("https://ctfic_gilfernandez:32nQq1Zb5M@api.meteomatics.com/2022-06-01T00:00:00Z--2022-06-01T03:00:00Z:PT1H/t_2m:C,relative_humidity_2m:p/50.23,10.23+40.23,20.12/json"));

  String toRawJson() => json.encode(toJson());

  factory Coordinate.fromJson(Map<String, dynamic> json) => Coordinate(
    lat: json["lat"].toDouble(),
    lon: json["lon"].toDouble(),
    dates: List<Date>.from(json["dates"].map((x) => Date.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lon": lon,
    "dates": List<dynamic>.from(dates!.map((x) => x.toJson())),
  };
}

class Date {
  Date({
    this.date,
    this.value,
  });

  final DateTime? date;
  final double? value;

  Date copyWith({
    DateTime? date,
    double? value,
  }) =>
      Date(
        date: date ?? this.date,
        value: value ?? this.value,
      );

  factory Date.fromRawJson(String str) => Date.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Date.fromJson(Map<String, dynamic> json) => Date(
    date: DateTime.parse(json["date"]),
    value: json["value"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "date": date!.toIso8601String(),
    "value": value,
  };
}
