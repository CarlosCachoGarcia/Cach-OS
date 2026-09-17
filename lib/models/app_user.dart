enum Role { admin, client, auditor }

Role roleFor(int id) => id == 1 || id == 2
    ? Role.admin
    : id == 3
        ? Role.auditor
        : Role.client;

extension RoleLabel on Role {
  String get label => switch (this) {
        Role.admin => 'Administrador',
        Role.client => 'Cliente',
        Role.auditor => 'Auditor',
      };
}

class Address {
  final String city, street, zipcode, latitude, longitude;
  final int number;
  const Address({
    this.city = '',
    this.street = '',
    this.zipcode = '',
    this.latitude = '',
    this.longitude = '',
    this.number = 0,
  });
  factory Address.fromJson(Map<String, dynamic> j) => Address(
        city: j['city'] ?? '',
        street: j['street'] ?? '',
        zipcode: j['zipcode'] ?? '',
        number: (j['number'] as num?)?.toInt() ?? 0,
        latitude: j['geolocation']?['lat'] ?? '',
        longitude: j['geolocation']?['long'] ?? '',
      );
}

class AppUser {
  final int id;
  final String username, firstName, lastName, email, phone;
  final Address address;
  const AppUser({
    required this.id,
    required this.username,
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phone = '',
    this.address = const Address(),
  });
  String get fullName => '$firstName $lastName'.trim();
  Role get role => roleFor(id);
  factory AppUser.fromJson(Map<String, dynamic> j) => AppUser(
        id: (j['id'] as num).toInt(),
        username: j['username'] ?? '',
        firstName: j['name']?['firstname'] ?? '',
        lastName: j['name']?['lastname'] ?? '',
        email: j['email'] ?? '',
        phone: j['phone'] ?? '',
        address: Address.fromJson(j['address'] ?? {}),
      );
}
