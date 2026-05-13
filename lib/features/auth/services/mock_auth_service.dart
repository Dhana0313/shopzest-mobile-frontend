class MockAuthService {
  static final List<Map<String, String>> _mockDatabase = [
    {
      'name': 'Alex Johnson',
      'email': 'john@example.com',
      'password': 'password123',
    }
  ];

  Future<Map<String, dynamic>> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      final user = _mockDatabase.firstWhere(
        (u) => u['email'] == email && u['password'] == password,
      );
      return {'success': true, 'message': 'Welcome back, ${user['name']}!'};
    } catch (e) {
      return {'success': false, 'message': 'Invalid email or password.'};
    }
  }

  Future<Map<String, dynamic>> signup(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));

    final userExists = _mockDatabase.any((u) => u['email'] == email);
    
    if (userExists) {
      return {'success': false, 'message': 'An account with this email already exists.'};
    }

    _mockDatabase.add({
      'name': name,
      'email': email,
      'password': password,
    });

    return {'success': true, 'message': 'Account created successfully!'};
  }
}