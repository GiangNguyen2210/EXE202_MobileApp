class ProfileImageResponseDTO {
  final String? secureUrl;

  ProfileImageResponseDTO({this.secureUrl});

  factory ProfileImageResponseDTO.fromJson(Map<String, dynamic> json) {
    return ProfileImageResponseDTO(
      secureUrl: json['secureUrl'],
    );
  }
}