class Validations {
  static String validateRib(String value) {
    if (value.isEmpty) return 'RIB is Required.';
    final RegExp nameExp = new RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only Numbers characters.';
    if (value.length < 20 || value.length > 30)
      return 'Please enter valid RIB Numbers characters.';
    return null;
  }

  static String validateNumber(String value) {
    if (value.isEmpty) return 'Weight is Required.';
    final RegExp nameExp = new RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only Numbers characters.';
    return null;
  }

  static String validateNumber2(String value) {
    if (value.isEmpty) return 'Price is Required.';
    final RegExp nameExp = new RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only Numbers characters.';
    return null;
  }

  static String validateBankName(String value) {
    if (value.isEmpty) return 'Bank Name is Required.';
    final RegExp nameExp = new RegExp(r'^[A-za-zğüşöçİĞÜŞÖÇ ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  static String validateName(String value) {
    if (value.isEmpty) return 'Username is Required.';
    final RegExp nameExp = new RegExp(r'^[A-za-zğüşöçİĞÜŞÖÇ ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  static String validateBusinessName(String value) {
    if (value.isEmpty) return 'Business Name is Required.';
    final RegExp nameExp = new RegExp(r'^[A-za-zğüşöçİĞÜŞÖÇ ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  static String validateEmail(String value, [bool isRequried = true]) {
    if (value.isEmpty && isRequried) return 'Email is required.';
    final RegExp nameExp = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    if (!nameExp.hasMatch(value) && isRequried) return 'Invalid email address';
    return null;
  }

  static String validatePassword(String value) {
    if (value.isEmpty || value.length < 8)
      return 'Your password should contain letters, numbers and symbols.';
    return null;
  }

  static String validatephone(String value) {
    if (value.isEmpty) return 'phone Number is Required.';
    if (value.length < 13)
      return 'Please enter a valid phone number {+212...}.';
    return null;
  }
}
