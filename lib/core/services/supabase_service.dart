import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/api_constants.dart';

class SupabaseService {

  static Future init() async {

    await Supabase.initialize(
      url: ApiConstants.supabaseUrl,
      anonKey: ApiConstants.supabaseKey,
    );

  }

  static SupabaseClient get client => Supabase.instance.client;

}