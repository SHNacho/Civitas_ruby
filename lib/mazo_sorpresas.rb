require_relative 'diario.rb'
require_relative 'sorpresa.rb'

module Civitas
  class MazoSorpresas      
    def initialize(debug = false)
      @sorpresas = []
      @cartas_especiales = []
      @barajada = false
      @usadas = 0
      @ultima_sorpresa = nil
      @debug = debug
      if @debug
        Civitas::Diario.instance.ocurre_evento("Modo debug activado")
      end
              
    end
    
    def al_mazo(s)
      if !@barajada
        @sorpresas << s
      end
    end
    
    def siguiente
      if !@barajada || @usadas == @sorpresas.size()
        if !@debug
          @sorpresas.shuffle!
        end
        @usadas = 0
        @barajada = true
      end
      
      @usadas += 1
      
      @ultima_sorpresa = @sorpresas.shift
      @sorpresas << @ultima_sorpresa
      
      return @ultima_sorpresa      
    end
    
    def inhabilitar_carta_especial (sorpresa)
      if (@sorpresas.delete(sorpresa) != nil)
        @cartas_especiales << sorpresa
        Civitas::Diario.instance.ocurre_evento("Carta especial inhabilitada")
      end
    end
    
    def habilitar_carta_especial (sorpresa)
      pos = @cartas_especiales.index(sorpresa)
      if pos != nil
        @sorpresas << @cartas_especiales.delete_at(pos) #Eliminamos de cartas_especiales y la añadimos a sorpresas
        Civitas::Diario.instance.ocurre_evento("Carta especial habilitada")
      end
    end
    
  end
end
