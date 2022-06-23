// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Profile {
  String? name;
  String? dayOfBirth;
  String? phoneNo;
  String? email;
  String? website;
  String? imgURL;
  String userMail;
  String? address;
  String? profileName;
  Profile({
    this.name,
    this.dayOfBirth,
    this.phoneNo,
    this.email,
    this.website,
    this.imgURL,
    required this.userMail,
    this.address,
    this.profileName,
  });

  Profile copyWith({
    String? name,
    String? dayOfBirth,
    String? phoneNo,
    String? email,
    String? website,
    String? imgURL,
    String? userMail,
    String? address,
    String? profileName,
  }) {
    return Profile(
      name: name ?? this.name,
      dayOfBirth: dayOfBirth ?? this.dayOfBirth,
      phoneNo: phoneNo ?? this.phoneNo,
      email: email ?? this.email,
      website: website ?? this.website,
      imgURL: imgURL ?? this.imgURL,
      userMail: userMail ?? this.userMail,
      address: address ?? this.address,
      profileName: profileName ?? this.profileName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'dayOfBirth': dayOfBirth,
      'phoneNo': phoneNo,
      'email': email,
      'website': website,
      'imgURL': imgURL,
      'userMail': userMail,
      'address': address,
      'profileName': profileName,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      name: map['name'] != null ? map['name'] as String : null,
      dayOfBirth:
          map['dayOfBirth'] != null ? map['dayOfBirth'] as String : null,
      phoneNo: map['phoneNo'] != null ? map['phoneNo'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      website: map['website'] != null ? map['website'] as String : null,
      imgURL: map['imgURL'] != null ? map['imgURL'] as String : null,
      userMail: map['userMail'] as String,
      address: map['address'] != null ? map['address'] as String : null,
      profileName:
          map['profileName'] != null ? map['profileName'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Profile.fromJson(String source) =>
      Profile.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Profile(name: $name, dayOfBirth: $dayOfBirth, phoneNo: $phoneNo, email: $email, website: $website, imgURL: $imgURL, userMail: $userMail, address: $address, profileName: $profileName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Profile &&
        other.name == name &&
        other.dayOfBirth == dayOfBirth &&
        other.phoneNo == phoneNo &&
        other.email == email &&
        other.website == website &&
        other.imgURL == imgURL &&
        other.userMail == userMail &&
        other.address == address &&
        other.profileName == profileName;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        dayOfBirth.hashCode ^
        phoneNo.hashCode ^
        email.hashCode ^
        website.hashCode ^
        imgURL.hashCode ^
        userMail.hashCode ^
        address.hashCode ^
        profileName.hashCode;
  }
}
