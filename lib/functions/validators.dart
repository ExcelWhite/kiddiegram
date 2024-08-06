String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email";
    }

    // Check for email length
    if (value.length > 64) {
      return "Email is too long";
    }

    // Check for valid email format
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return "Please enter a valid email address";
    }

    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your username";
    }

    // Check for character length
    if (value.length < 6 || value.length > 20) {
      return "Username must be between 6 and 20 characters";
    }

    // Check for valid characters
    final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');
    if (!validCharacters.hasMatch(value)) {
      return "No space or special characters allowed";
    }

    return null;

  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your password";
    } else if (value.length < 8) {
      return "Password must be at least 8 characters";
    } else if (value.contains(' ')) {
      return "Password cannot contain spaces";
    } else {
      //print(value);
      return null;
    }
  }

  String? validateConfirmPassword(String? cp, String? p) {
    print('p $p');
    print('cp $cp');
    if (cp == null || cp.isEmpty) {
      return "Please enter your password";
    } else if (cp!= p) {
      return "Password does not match";
    } else {
      
      return null;
    }
  }