class Explorer {
  String name;
  int age;
  String track;
  List<String> skills;

  String? bio;
  String? email;

  Explorer({
    required this.name,
    required this.age,
    required this.track,
    required this.skills,
    this.bio,
    this.email,
  });

  Explorer.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        age = map['age'],
        track = map['track'],
        skills = List<String>.from(map['skills']),
        bio = map['bio'],
        email = map['email'];

  String shortProfile() {
    return 'Hi, my name is $name from the $track track.';
  }

  List<String> topSkills(int n) {
    if (skills.length <= n) {
      return skills;
    }
    return skills.sublist(0, n);
  }
}