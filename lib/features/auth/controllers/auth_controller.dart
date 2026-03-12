import '../../../core/services/supabase_service.dart';

class AuthController {

  // SIGNUP
  Future<bool> signup(String name, String email, String password) async {
    try {

      final response = await SupabaseService.client.auth.signUp(
        email: email.trim(),
        password: password.trim(),
      );

      final user = response.user;

      if (user != null) {

        await SupabaseService.client
            .from('users')
            .insert({
          'id': user.id,
          'name': name,
          'email': email,
        });

        print("Signup Successful: ${user.id}");
        return true;

      } else {
        print("Signup failed: user null");
        return false;
      }

    } catch (e) {
      print("Signup Error: $e");
      return false;
    }
  }


  // LOGIN
  Future<bool> login(String email, String password) async {
    try {

      final response = await SupabaseService.client.auth.signInWithPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (response.user != null) {
        print("Login Successful: ${response.user!.email}");
        return true;
      }

      print("Login failed: user null");
      return false;

    } catch (e) {
      print("Login Error: $e");
      return false;
    }
  }

}