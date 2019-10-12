# encoding:UTF-8

require_relative 'civitas_juego.rb'

module Civitas

  nombres = ["Nacho", "Julio", "Adris", "Jacob"]
  puts nombres.size.to_s
  juego = CivitasJuego.new(nombres)
  puts "Correcto"

end
