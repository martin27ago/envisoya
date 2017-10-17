OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '1739946889643470', 'a98ac06beb0504b29ab8fb65469b5636',
           info_fields:'email,first_name,last_name,birthday', authorized_params: 'prueba'
  end