// Login exceptions

class UserNoteFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

// Register exceptions

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyIUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// generic exceptions

class GenericAuthException implements Exception {}

class UserNoteLoggedInAuthException implements Exception {}
