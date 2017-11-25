if Rails.env.development?
  ENV['URLCosts']='http://localhost:1500'
  ENV['AuthCosts']='hola'
  ENV['user']='hola'
  ENV['password']='hola'
else
  ENV['Prueba']='prueba2'
end
