abstract final class AppConfig {
  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://wgvcumjtxeerfamqjfjv.supabase.co',
  );
  static const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndndmN1bWp0eGVlcmZhbXFqZmp2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODMzMjMyODEsImV4cCI6MjA5ODg5OTI4MX0.xeYaJN08bnt5KXIX23J94e6FX-O8bF6o03IDpogNKfU',
  );
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://prepexami.com',
  );
  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
