require_relative  'sorpresa.rb'
require_relative  'tablero.rb'

module Civitas
  class Sorpresa_ircasilla < Sorpresa
    
    def initialize (tablero, valor, texto)
      super(texto)
      @tablero = tablero
      @valor = valor
    end
    
    def to_s
      str = "'Sorpresa Ir Casilla" + ": " + @texto + "'"
      return str
    end
    
    def aplicar_a_jugador(actual,todos)
      if jugador_correcto(actual, todos)
        informe(actual, todos)
        casilla_actual = todos[actual].num_casilla_actual

        tirada = @tablero.calcular_tirada(casilla_actual, @valor)
        nuevaPos = @tablero.nueva_posicion(casilla_actual, tirada)

        todos[actual].mover_a_casilla(@valor)
        casilla = @tablero.casilla(@valor)
        casilla.recibe_jugador(actual, todos)
      end
    end
    
    public_class_method :new
  end
end
