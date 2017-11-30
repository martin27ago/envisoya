if Rails.env.development?
  ENV['URLCosts']='http://localhost:1500'
  ENV['URLLogger']='http://localhost:1200/logs'
  ENV['AuthCosts']='hola'
  ENV['user']='hola'
  ENV['password']='hola'
else
  ENV['URLCosts']='https://apicostos-arq-gf-app.mybluemix.net'
  ENV['URLLogger']='https://logger-arq-GF-app.mybluemix.net/logs'
  ENV['AuthCosts']='hola'
  ENV['user']='hola'
  ENV['password']='hola'
end
