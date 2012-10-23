Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :linkedin, "gaywpkqsa345", "3FpYnz57WmsJsTVA", :scope => 'r_fullprofile r_emailaddress r_network'
  provider :google_oauth2, "179239928840.apps.googleusercontent.com", "lzcxOJO4N5LPcuTbo_pJ-Gbm", {:scope => 'userinfo.profile,userinfo.email,plus.me'}
  provider :facebook, "268051749965205", "71bb1eb11aac5b8c368a2f2e42a46bc0"

end
