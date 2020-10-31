class ValidatorLogin {
  static String validate(String value) {
    String message;

    switch (value) {
      case "invalid-email":
        {
          message = 'Seu endereço de e-mail parece estar incorreto.';
          break;
        }
      case "wrong-password":
        {
          message = 'Senha Incorreta';
          break;
        }
      case "user-not-found":
        {
          message = 'O usuário com este e-mail não existe';
          break;
        }
      case "user-disabled":
        {
          message = 'O usuário com este e-mail foi desativado.';
          break;
        }
      case "too-many-requests":
        {
          message = 'Muitos pedidos. Tente mais tarde.';
          break;
        }
      case "operation-not-allowed":
        {
          message = 'O login com e-mail e senha não está ativado.';
          break;
        }
      case "email-already-in-use":
        {
          message =
              'Este endereço de e-mail já esta sendo usado por outra conta.';
          break;
        }
      default:
        {
          message = 'Um erro indefinido aconteceu.';
          break;
        }
    }
    return message;
  }
}
