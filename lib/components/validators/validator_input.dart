class FieldNotInformed {
  static String validate(String value) {
    return value == null || value.isEmpty || value == ''
        ? 'Informe um valor'
        : null;
  }
}

class NameFieldValidator {
  static String validate(String value) {
    return value.isEmpty || value.length < 3 ? 'Informe um nome válido' : null;
  }
}

class EmailFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Informe um E-mail válido' : null;
  }
}

class PasswordFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Senha não foi preenchida' : null;
  }
}

class PasswordFieldValidatorSiginUp {
  static String validate(String value) {
    return value.length < 6
        ? 'Sua senha deve conter no mínimo 6 caracteres'
        : null;
  }
}
