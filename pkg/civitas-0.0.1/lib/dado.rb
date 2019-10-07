# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require 'singleton'
require_relative 'diario.rb'

module Civitas
  class Dado
    include Singleton
    
    @@SalidaCarcel = 5
    
    def initialize
      @random = Random.new()
      @ultimo_resultado = 0
      @debug = false
    end
    
    def tirar 
      @ultimo_resultado = 1
      
      if @debug == false
        @ultimo_resultado = @random.rand(1..6)
      end
      
      return @ultimo_resultado
    end
    
    def salgo_de_la_carcel ()
      tirar
      
      puede = false
      
      if @ultimo_resultado == @@SalidaCarcel
        puede = true
      end
      
      return puede
    end
    
    def quien_empieza (n)
      
      empieza = @random.rand(0..(n-1))
      
      return empieza
    end
    
    def set_debug (d)
      @debug = d
      
      estado = "debug true"
      
      if (@debug == true)
        Diario.instance.ocurre_evento(estado)
      else
        estado = "debug false"
        Diario.instance.ocurre_evento(estado)
      end  
    end
    
    def leer_ultimo_resultado
      return @ultimo_resultado
    end
  end
end
