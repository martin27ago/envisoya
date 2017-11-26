if Rails.env.development?
  ENV['URLCosts']='http://localhost:1500'
  ENV['URLLogger']='http://localhost:1200/logs'
  ENV['AuthCosts']='hola'
  ENV['user']='hola'
  ENV['password']='hola'
else
  ENV['Prueba']='prueba2'
end
