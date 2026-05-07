class Env {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const groqApiKey = String.fromEnvironment('GROQ_API_KEY');
  static const indianKanoonToken = String.fromEnvironment('INDIAN_KANOON_TOKEN');
  static const meilisearchUrl = String.fromEnvironment(
    'MEILISEARCH_URL',
    defaultValue: 'http://localhost:7700',
  );
  static const meilisearchKey = String.fromEnvironment(
    'MEILISEARCH_KEY',
    defaultValue: '',
  );
}
