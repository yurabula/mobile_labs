class ValidationUtils {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email не може бути порожнім';
    }

    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegExp.hasMatch(value)) {
      return 'Введіть коректний email';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Пароль не може бути порожнім';
    }

    if (value.length < 6) {
      return 'Пароль має містити не менше 6 символів';
    }

    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ім\'я не може бути порожнім';
    }

    final nameRegExp = RegExp(r'^[a-zA-Zа-яА-ЯіІїЇєЄґҐ\s]+$');
    if (!nameRegExp.hasMatch(value)) {
      return 'Ім\'я має містити лише літери';
    }

    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final phoneRegExp = RegExp(r'^\+?[0-9]{10,13}$');
    if (!phoneRegExp.hasMatch(value)) {
      return 'Введіть коректний номер телефону';
    }

    return null;
  }
}
