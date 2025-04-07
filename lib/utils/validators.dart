String validateEmail(String value) {
  if (value == null || value.isEmpty) return 'Enter a valid e-mail';

  RegExp emailRegex = new RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
    caseSensitive: false,
    multiLine: false,
  );

  return emailRegex.hasMatch(value) ? null : 'Enter a valid e-mail';
}

String validateNotEmpty(String value) {
  return (value == null || value.isEmpty) ? 'Mandatory field' : null;
}
