Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :linkedin, "gaywpkqsa345", "3FpYnz57WmsJsTVA"
end
