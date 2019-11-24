require_relative 'sorpresa.rb'
require_relative 'tablero.rb'

module Civitas
  class Sorpresa_ircarcel < Sorpresa
    
    def initialize (tablero)
      super("Ve a la carcel directamente")
      @tablero = tablero
    end
    
    def to_s
      str = "'Sorpresa Ir Carcel" + ": " + @texto + "'"
      return str
    end
    
    def aplicar_a_jugador(actual,todos)
      if jugador_correcto(actual, todos)
        informe(actual, todos)
        casilla = @tablero.num_casilla_carcel
        todos[actual].encarcelar(casilla)
      end
    end
    
    public_class_method :new
  end
end
