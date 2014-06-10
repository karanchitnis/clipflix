Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '416201355123164', '335ade6795f793d112db63e3b0c6b349', {client_options: {ssl: {ca_file: Rails.root.join('lib/assets/cacert.pem').to_s}}}
  provider :twitter, 'OlGVwnbgJfoTP3Ticy31A', 'LuLMERvNwVNVP5nYmFlm8pp7VjFYDYmhEcFWGsYafN4', {client_options: {ssl: {ca_file: Rails.root.join('lib/assets/cacert.pem').to_s}}}
  provider :google_oauth2, "142932211105", "xa1hbMizE1y8ZNIwY5RMXDol", {client_options: {ssl: {ca_file: Rails.root.join('lib/assets/cacert.pem').to_s}}}
end

Koala::HTTPService.http_options[:ssl] = {ca_file: Rails.root.join('lib/assets/cacert.pem').to_s}
Koala.http_service.http_options = {:ssl => { :ca_path => "/etc/ssl/certs" }}