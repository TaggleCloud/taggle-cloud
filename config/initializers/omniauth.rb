Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :linkedin, "gaywpkqsa345", "3FpYnz57WmsJsTVA"
  provider :google_oauth2, "179239928840.apps.googleusercontent.com", "lzcxOJO4N5LPcuTbo_pJ-Gbm", {access_type: 'online', approval_prompt: ''}
  provider :facebook, "268051749965205", "71bb1eb11aac5b8c368a2f2e42a46bc0"

end
