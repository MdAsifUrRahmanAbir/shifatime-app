class UserModel {
  final int? id;
  final String? email;
  final String? username;
  final String? password;
  final UserName? name;
  final String? phone;
  final UserAddress? address;

  const UserModel({
    this.id,
    this.email,
    this.username,
    this.password,
    this.name,
    this.phone,
    this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      email: json['email'] as String?,
      username: json['username'] as String?,
      password: json['password'] as String?,
      name: json['name'] != null ? UserName.fromJson(json['name']) : null,
      phone: json['phone'] as String?,
      address: json['address'] != null
          ? UserAddress.fromJson(json['address'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'password': password,
      'name': name?.toJson(),
      'phone': phone,
      'address': address?.toJson(),
    };
  }

  String get fullName =>
      '${name?.firstname ?? ''} ${name?.lastname ?? ''}'.trim();

  factory UserModel.dummy() => const UserModel(
    id: 0,
    email: 'loading@example.com',
    username: 'loading',
    name: UserName(firstname: 'First', lastname: 'Last'),
    phone: '000-000-0000',
    address: UserAddress(
      city: 'City',
      street: 'Street',
      number: 0,
      zipcode: '00000',
      geolocation: UserGeolocation(lat: '0', long: '0'),
    ),
  );
}

class UserName {
  final String? firstname;
  final String? lastname;

  const UserName({this.firstname, this.lastname});

  factory UserName.fromJson(Map<String, dynamic> json) {
    return UserName(
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'firstname': firstname, 'lastname': lastname};
  }
}

class UserAddress {
  final String? city;
  final String? street;
  final int? number;
  final String? zipcode;
  final UserGeolocation? geolocation;

  const UserAddress({
    this.city,
    this.street,
    this.number,
    this.zipcode,
    this.geolocation,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      city: json['city'] as String?,
      street: json['street'] as String?,
      number: json['number'] as int?,
      zipcode: json['zipcode'] as String?,
      geolocation: json['geolocation'] != null
          ? UserGeolocation.fromJson(json['geolocation'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'street': street,
      'number': number,
      'zipcode': zipcode,
      'geolocation': geolocation?.toJson(),
    };
  }
}

class UserGeolocation {
  final String? lat;
  final String? long;

  const UserGeolocation({this.lat, this.long});

  factory UserGeolocation.fromJson(Map<String, dynamic> json) {
    return UserGeolocation(
      lat: json['lat'] as String?,
      long: json['long'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'lat': lat, 'long': long};
  }
}
