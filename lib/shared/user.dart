class User {
  final String imagePath;
  final String name;
  final String email;
  final String matricno;
  final String whatsapp;
  final String wechat;
  final String password;

  const User(
      {required this.imagePath,
      required this.name,
      required this.email,
      required this.matricno,
      required this.whatsapp,
      required this.wechat,
      required this.password});
}

class UserPreferences {
  static const myUser = User(
      imagePath: 'https://i.dlpng.com/static/png/6869631_preview.png',
      name: 'Aiman Hakim',
      password: '12345678',
      email: 'a@gmail.com',
      matricno: '200903',
      whatsapp: '0172655375',
      wechat: 'kimcys');
}
