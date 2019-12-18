require_relative 'sorpresa.rb'
require_relative 'tablero.rb'

module Civitas
  class SorpresaSalirCarcel < Sorpresa
    
    def initialize (mazo)
      super("Esta carta te permite salir de la carcel")
      @mazo = mazo
    end
    
    def to_s
      str = "'Sorpresa Salir Carcel" + ": " + @texto + "'"
      return str
    end
    
    def usada
        @mazo.habilitar_carta_especial(self)
    end

    def salir_del_mazo
        @mazo.inhabilitar_carta_especial(self)
    end
    
    def aplicar_a_jugador(actual,todos)
      if jugador_correcto(actual, todos)
        informe(actual, todos)
        la_tiene = false

        for jugador in todos
          if jugador.tiene_salvoconducto
            la_tiene = true
          end
        end

        if !la_tiene
          todos[actual].obtener_salvoconducto(self)
          salir_del_mazo
        end
      end
    end
    
    public_class_method :new
  end
end