class UserModel {
  String uid;
  String name;
  String email;

  UserModel({required this.uid, required this.name, required this.email});

  // Convert user to a map for Firebase Firestore
/*************  ✨ Codeium Command ⭐  *************/
  /// Converts the [UserModel] to a [Map] for use in Firestore documents.
  ///
  /// The keys of the map are:
  ///
  /// ****  28ec9469-ebbf-4ab7-8170-332d037ca9b9  ******
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
    };
  }

  // Create a UserModel from a Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }
}
