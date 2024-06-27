
import '../utils/utils.dart';

class UserDetails {
  final String uid;
  final List<AddressModel> addresses;

  UserDetails({
    required this.uid,
    this.addresses = const [],
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    var addressList = json['addresses'] as List<dynamic>? ?? [];
    List<AddressModel> addresses = addressList.map((addressJson) {
      return AddressModel.fromJson(addressJson as Map<String, dynamic>);
    }).toList();

    return UserDetails(
      uid: json['uid'] as String,
      addresses: addresses,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'addresses': addresses.map((address) => address.toJson()).toList(),
    };
  }
}


class AddressModel {
  final String name;
  final String city;
  final String address;
  final String civic;
  final bool selected;

  AddressModel({
    required this.name,
    required this.city,
    required this.address,
    required this.civic,
    required this.selected,
  });


  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      name: Utils.capitalizeFirstLetter(json['name']),
      city: Utils.capitalizeFirstLetter(json['city']),
      address: json['address'],
      civic: json['civic'],
      selected: json['selected']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': Utils.capitalizeFirstLetter(name),
      'city': Utils.capitalizeFirstLetter(city),
      'address': address,
      'civic': civic,
      'selected': selected,
    };
  }
}