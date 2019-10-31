# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'vista_textual.rb'
require_relative 'controlador.rb'
require_relative 'dado.rb'
require_relative 'civitas_juego.rb'

module Civitas
  class Prueba
    def self.main
      vista = Vista_textual.new
      nombres = ["pepe","luis","sara","sofia"]
      civi = CivitasJuego.new(nombres)
      Dado.instance.set_debug(true)
      
      controlador = Controlador.new(civi, vista)
      
      controlador.juega
    end
  end
end