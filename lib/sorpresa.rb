require_relative 'diario.rb'

module Civitas
  class Sorpresa

    def initialize(texto)
      @texto = texto
    end

    def to_s
    end

    def jugador_correcto(actual, todos)
      return (actual >= 0) && (actual < todos.size())
    end

    def informe(actual, todos)
      diario = Diario.instance 
      if (jugador_correcto(actual, todos))
        str = "Se aplica la sorpresa:" + to_s + " a " + todos[actual].nombre
        diario.ocurre_evento(str)
      end
    end

    def aplicar_a_jugador(actual, todos)
    end
    
    private_class_method :new
  end
end
