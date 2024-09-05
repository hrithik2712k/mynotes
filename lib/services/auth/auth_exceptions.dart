// Login Exception

class UserNotFoundAuthException implements Exception {}

class WrongPassworAuthException implements Exception {}

// Register Exception

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// Generic Exception

class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
