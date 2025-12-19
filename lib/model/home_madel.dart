import 'dart:convert';

class HomeModel {
  final List<Datum>? data;

  HomeModel({this.data});

  factory HomeModel.fromRawJson(String str) => HomeModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HomeModel.fromJson(Map<String, dynamic> json) =>
      HomeModel(data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))));

  Map<String, dynamic> toJson() => {"data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson()))};
}

class Datum {
  final int? id;
  final String? title;
  final int? bedRoom;
  final int? bathRoom;
  final String? garages;
  final String? type;
  final String? coverImage;
  final List<String>? images;
  final String? videoUrl;
  final int? squareMeter;
  final Location? location;
  final bool? forRent;
  final Prices? prices;
  final bool? isAvailable;
  final bool? isLiked;
  final int? likeCount;
  final bool? isFurnished;
  final String? condition;
  final List<String>? features;
  final PostedBy? postedBy;
  final String? postedAt;

  Datum({
    this.id,
    this.title,
    this.bedRoom,
    this.bathRoom,
    this.garages,
    this.type,
    this.coverImage,
    this.images,
    this.videoUrl,
    this.squareMeter,
    this.location,
    this.forRent,
    this.prices,
    this.isAvailable,
    this.isLiked,
    this.likeCount,
    this.isFurnished,
    this.condition,
    this.features,
    this.postedBy,
    this.postedAt,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    bedRoom: json["bed_room"],
    bathRoom: json["bath_room"],
    garages: json["garages"],
    type: json["type"],
    coverImage: json["cover_image"],
    images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
    videoUrl: json["video_url"],
    squareMeter: json["square_meter"],
    location: json["location"] == null ? null : Location.fromJson(json["location"]),
    forRent: json["for_rent"],
    prices: json["prices"] == null ? null : Prices.fromJson(json["prices"]),
    isAvailable: json["is_available"],
    isLiked: json["is_Liked"],
    likeCount: json["like_count"],
    isFurnished: json["is_furnished"],
    condition: json["condition"],
    features: json["features"] == null ? [] : List<String>.from(json["features"]!.map((x) => x)),
    postedBy: json["posted_by"] == null ? null : PostedBy.fromJson(json["posted_by"]),
    postedAt: json["posted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "bed_room": bedRoom,
    "bath_room": bathRoom,
    "garages": garages,
    "type": type,
    "cover_image": coverImage,
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
    "video_url": videoUrl,
    "square_meter": squareMeter,
    "location": location?.toJson(),
    "for_rent": forRent,
    "prices": prices?.toJson(),
    "is_available": isAvailable,
    "is_Liked": isLiked,
    "like_count": likeCount,
    "is_furnished": isFurnished,
    "condition": condition,
    "features": features == null ? [] : List<dynamic>.from(features!.map((x) => x)),
    "posted_by": postedBy?.toJson(),
    "posted_at": postedAt,
  };
}

class Location {
  final int? id;
  final Coordinates? coordinates;
  final String? name;
  final String? city;
  final String? country;
  final String? area;
  final int? zipCode;

  Location({this.id, this.coordinates, this.name, this.city, this.country, this.area, this.zipCode});

  factory Location.fromRawJson(String str) => Location.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    id: json["id"],
    coordinates: json["coordinates"] == null ? null : Coordinates.fromJson(json["coordinates"]),
    name: json["name"],
    city: json["city"],
    country: json["country"]!,
    area: json["area"],
    zipCode: json["zip-code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "coordinates": coordinates?.toJson(),
    "name": name,
    "city": city,
    "country": country,
    "area": area,
    "zip-code": zipCode,
  };
}

class Coordinates {
  final double? lon;
  final double? lat;

  Coordinates({this.lon, this.lat});

  factory Coordinates.fromRawJson(String str) => Coordinates.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(lon: json["lon"]?.toDouble(), lat: json["lat"]?.toDouble());

  Map<String, dynamic> toJson() => {"lon": lon, "lat": lat};
}

enum Country { ETHIOPIA }

final countryValues = EnumValues({"Ethiopia": Country.ETHIOPIA});

class PostedBy {
  final int? id;
  final String? image;
  final String? name;
  final String? phone;
  final String? email;
  final double? rate;
  final List<Review>? review;

  PostedBy({this.id, this.image, this.name, this.phone, this.email, this.rate, this.review});

  factory PostedBy.fromRawJson(String str) => PostedBy.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostedBy.fromJson(Map<String, dynamic> json) => PostedBy(
    id: json["id"],
    image: json["image"],
    name: json["name"],
    phone: json["phone"],
    email: json["email"],
    rate: json["rate"]?.toDouble(),
    review: json["review"] == null ? [] : List<Review>.from(json["review"]!.map((x) => Review.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "name": name,
    "phone": phone,
    "email": email,
    "rate": rate,
    "review": review == null ? [] : List<dynamic>.from(review!.map((x) => x.toJson())),
  };
}

class Review {
  final int? id;
  final String? name;
  final String? comment;
  final DateTime? postedDate;
  final int? rate;

  Review({this.id, this.name, this.comment, this.postedDate, this.rate});

  factory Review.fromRawJson(String str) => Review.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json["id"],
    name: json["name"],
    comment: json["comment"],
    postedDate: json["posted_date"] == null ? null : DateTime.parse(json["posted_date"]),
    rate: json["rate"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "comment": comment,
    "posted_date":
        "${postedDate!.year.toString().padLeft(4, '0')}-${postedDate!.month.toString().padLeft(2, '0')}-${postedDate!.day.toString().padLeft(2, '0')}",
    "rate": rate,
  };
}

class Prices {
  final String? price;
  final String? currency;

  Prices({this.price, this.currency});

  factory Prices.fromRawJson(String str) => Prices.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Prices.fromJson(Map<String, dynamic> json) => Prices(price: json["price"], currency: json["currency"]);

  Map<String, dynamic> toJson() => {"price": price, "currency": currency};
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
