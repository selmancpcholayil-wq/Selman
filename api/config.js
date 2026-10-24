module.exports = function handler(_request, response) {
  response.setHeader('Cache-Control', 'no-store, max-age=0');
  response.status(200).json({
    supabaseUrl: process.env.SUPABASE_URL || null,
    supabaseAnonKey: process.env.SUPABASE_PUBLISHABLE_KEY || process.env.SUPABASE_ANON_KEY || null,
  });
};
