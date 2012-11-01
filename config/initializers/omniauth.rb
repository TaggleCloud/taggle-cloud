Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.production?
    provider :linkedin, "tcrmk4jgv4bm", "HRIaIJbdGiklXLbi", :scope => 'r_fullprofile r_emailaddress r_network'
    provider :google_oauth2, "561521590403.apps.googleusercontent.com", "uW8kyk8zV9533mJ9_reQKGMd", {:scope => 'userinfo.profile,userinfo.email,plus.me'}
    provider :facebook, "239492312845437", "0a6b384c632da1aecadd6d1f459d8646"
  else
    provider :developer
    provider :linkedin, "gaywpkqsa345", "3FpYnz57WmsJsTVA", :scope => 'r_fullprofile r_emailaddress r_network'
    provider :google_oauth2, "179239928840.apps.googleusercontent.com", "lzcxOJO4N5LPcuTbo_pJ-Gbm", {:scope => 'userinfo.profile,userinfo.email,plus.me'}
    provider :facebook, "268051749965205", "71bb1eb11aac5b8c368a2f2e42a46bc0"
  end
end
