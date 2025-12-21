enum UserRole {
  mahasiswa('mahasiswa', 'Mahasiswa'),
  dosen('dosen', 'Dosen'),
  admin('admin', 'Admin');

  const UserRole(this.value, this.displayName);
  final String value;
  final String displayName;

  static UserRole fromString(String role) {
    return UserRole.values.firstWhere(
      (element) => element.value == role,
      orElse: () => UserRole.mahasiswa,
    );
  }
}