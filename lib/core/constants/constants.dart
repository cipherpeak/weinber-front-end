import 'dart:ui';

const String appName = 'Weinber';
const String privacyPolicyUrl = '';
const String playStoreId = '';
const String appleId = '';

// Regular expression for username validation that allows only letters, numbers,
// and underscores with a length of 6 to 16 characters
const String usernameRegex = r'^[a-zA-Z0-9_]{6,16}$';

// for input formatter this should accept only letters, numbers,
// and underscores with a length of 0 to 16 characters
const String usernameRegexForInputFormatter = r'^[a-zA-Z0-9_]{0,16}$';

// Regular expression for email validation
const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

const Color primaryColor = Color(0xFF69A2E7);


