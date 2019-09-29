# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require 'random'

require 'singleton'

module Civitas
  class Dado
    include Random
    include Singleton
    
    @@SalidaCarcel = 5
    
    def initialize
      @random = Random.new()
      @ultimoResultado = 0
      @debug = false
    end
    
    def tirar 
      @ultimoResultado = 1
      
      if @debug == false
        @ultimoResultado = @random.rand(1..6)
      end
      
      return @ultimoResultado
    end
    
    def salgo_de_la_carcel (n)
      tirar
      
      puede = false
      
      if @ultimoResultado == @@SalidaCarcel
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
      return @ultimoResultado
    end
 end
end