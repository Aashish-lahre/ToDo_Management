import 'dart:math';

String generateRandomString(int length) {
  const String chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#\$%^&*()-_=+{}[]|:;<>,.?/~';
  Random random = Random.secure();

  return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join('');
}