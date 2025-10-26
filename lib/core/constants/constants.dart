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

const Color primaryBackgroundColor = Color(0xFFF6F8FF);
const Color primaryColor = Color(0xFF7795ff);
const Color greyIconsColor = Color(0xFFbdc1c6);

//Icons
const Color iconBlue = Color(0xFF8ECAE6);
const Color iconOrange = Color(0xFFFFD6A5);
const Color iconGreen = Color(0xFFC1FBA4);
const Color iconPink = Color(0xFFDDBDF1);







