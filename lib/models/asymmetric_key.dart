import 'package:kms/models/user.dart';

class AsymmetricKey {
  final int id;
  final User creator;
  final String product;
  final String serial;
  final int signId;
  final String algorithm;
  final String description;
  final String publicKey;
  final List<dynamic> customer;

  const AsymmetricKey({
    required this.id,
    required this.creator,
    required this.product,
    required this.serial,
    required this.signId,
    required this.customer,
    required this.algorithm,
    required this.description,
    required this.publicKey,
  });

  factory AsymmetricKey.fromJson(Map<String, dynamic> json) {
    return AsymmetricKey(
      id: json['id'],
      publicKey: json['public_key'],
      creator: User.fromJson(json['creator']),
      product: json['product'],
      serial: json['serial'],
      signId: json['sign_id'],
      customer: json['customer'],
      algorithm: json['algorithm'],
      description: json['description'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'public_key': publicKey,
      'creator': creator.toJson(),
      'product': product,
      'serial': serial,
      'sign_id': signId.toString(),
      'customer': customer,
      'algorithm': algorithm,
      'description': description,
    };
  }
}
