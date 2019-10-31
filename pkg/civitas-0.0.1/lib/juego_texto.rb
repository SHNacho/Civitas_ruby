
require_relative 'controlador.rb'
require_relative 'civitas_juego.rb'
require_relative 'vista_textual.rb'
require_relative 'dado.rb'

module Civitas
    class JuegoTexto
        nombres = ["Adris", "Jacob", "Julius", "Yop"]
        vista = Vista_textual.new
        juego = CivitasJuego.new(nombres)
        Dado.instance.set_debug(true)
        controlador = Controlador.new(juego, vista)
        controlador.juega
    end

 end