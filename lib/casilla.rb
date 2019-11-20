#encoding:UTF-8

require_relative 'casilla.rb'

module Civitas
  class Casilla
      
    @@carcel = 0

    attr_reader :nombre
  
    def initialize (nombre)
      @nombre = nombre
    end
    
    public
    
    def recibe_jugador (i_actual, todos)
        informe(i_actual, todos)
    end
    
    def jugador_correcto (i_actual, todos)
      correcto = false
      
      if i_actual < todos.size
        correcto = true
      end
      
      return correcto
    end

    def to_s
      str = "-------------------------------------------\n" +
            "CASILLA: \n" + "Nombre:            " + @nombre + "\n" +
                            "Tipo:              " + "Descanso" + "\n"+
      str += "-------------------------------------------\n"
      
      return str
    end
    
    private
    
    def informe (i_actual, todos)
      evento = ("El jugador " + todos[i_actual].nombre + 
                " ha caido en la casilla " + @nombre + "\n" +
                "Informacion de la casilla: \n" + to_s)
      Diario.instance.ocurre_evento(evento)
    end

  end
  
end
