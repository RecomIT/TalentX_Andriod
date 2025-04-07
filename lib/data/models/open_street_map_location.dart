class OpenStreetMapLocation {
  int placeId;
  String licence;
  String osmType;
  int osmId;
  String lat;
  String lon;
  String displayName;
  Address address;
  List<String> boundingbox;

  OpenStreetMapLocation(
      {this.placeId,
      this.licence,
      this.osmType,
      this.osmId,
      this.lat,
      this.lon,
      this.displayName,
      this.address,
      this.boundingbox});

  OpenStreetMapLocation.fromJson(Map<String, dynamic> json) {
    placeId = json['place_id'];
    licence = json['licence'];
    osmType = json['osm_type'];
    osmId = json['osm_id'];
    lat = json['lat'];
    lon = json['lon'];
    displayName = json['display_name'];
    address = json['address'] != null ? Address.fromJson(json['address']) : null;
    boundingbox = json['boundingbox'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['place_id'] = this.placeId;
    data['licence'] = this.licence;
    data['osm_type'] = this.osmType;
    data['osm_id'] = this.osmId;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['display_name'] = this.displayName;
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    data['boundingbox'] = this.boundingbox;
    return data;
  }
}

class Address {
  String amenity;
  String road;
  String city;
  String stateDistrict;
  String state;
  String postcode;
  String country;
  String countryCode;

  Address(
      {this.amenity,
      this.road,
      this.city,
      this.stateDistrict,
      this.state,
      this.postcode,
      this.country,
      this.countryCode});

  Address.fromJson(Map<String, dynamic> json) {
    amenity = json['amenity'];
    road = json['road'];
    city = json['city'];
    stateDistrict = json['state_district'];
    state = json['state'];
    postcode = json['postcode'];
    country = json['country'];
    countryCode = json['country_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['amenity'] = this.amenity;
    data['road'] = this.road;
    data['city'] = this.city;
    data['state_district'] = this.stateDistrict;
    data['state'] = this.state;
    data['postcode'] = this.postcode;
    data['country'] = this.country;
    data['country_code'] = this.countryCode;
    return data;
  }

  String toShortAddressString() {
    String shortAddress = "";
    shortAddress += amenity != null ? amenity + ", " : "";
    shortAddress += road != null ? road + ", " : "";
    shortAddress += city != null ? city + ", " : "";
    shortAddress += stateDistrict != null ? stateDistrict + ", " : "";
    shortAddress += state != null ? state + ", " : "";
    shortAddress += postcode != null ? postcode : "";
    return shortAddress;
  }
}
