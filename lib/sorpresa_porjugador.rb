require_relative 'sorpresa.rb'

module Civitas
  class Sorpresa_porjugador < Sorpresa
    
    def initialize (valor, texto)
      super(texto)
      @valor = valor
    end
    
    def to_s
      str = "'Sorpresa PorJugador" + ": " + @texto + "'"
      return str
    end
    
    def aplicar_a_jugador(actual,todos)
      if(jugador_correcto(actual, todos))
        informe(actual, todos)
        texto = "pagar a " + todos[actual].nombre + " " + @valor.to_s
        sorpresa_pagan = Sorpresa.new_sorpresa(TipoSorpresa::PAGARCOBRAR, @valor*(-1), texto)
        
        for i in 0..todos.size do
          if i != actual
            sorpresa_pagan.aplicar_a_jugador(i, todos)
          end
        end

        texto = "Recibe " + @valor.to_s + " de cada jugador"
        sorpresa_recibe = Sorpresa.new_sorpresa(TipoSorpresa::PAGARCOBRAR, @valor*(todos.size - 1), texto)

        sorpresa_recibe.aplicar_a_jugador(actual, todos)
      end
    end
    
    public_class_method :new
  end
end
