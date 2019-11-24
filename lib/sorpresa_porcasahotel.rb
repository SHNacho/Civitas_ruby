require_relative 'sorpresa.rb'

module Civitas
  class Sorpresa_porcasahotel < Sorpresa
    
    def initialize (valor, texto)
      super(texto)
      @valor = valor
    end
    
    def to_s
      str = "'Sorpresa PorCasaHotel" + ": " + @texto + "'"
      return str
    end
    
    def aplicar_a_jugador(actual,todos)
      if jugador_correcto(actual, todos)

        informe(actual, todos)

        incremento = @valor * todos[actual].cantidad_casas_hoteles

        todos[actual].modificar_saldo(incremento)

      end
    end
    
    public_class_method :new
  end
end
