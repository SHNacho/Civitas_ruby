require_relative 'casilla.rb'

module Civitas
  class CasillaImpuesto < Casilla

    def initialize (cantidad, nombre)
      super(nombre)
      @importe = cantidad   
    end
    
    def recibe_jugador (i_actual, todos)
      if jugador_correcto(i_actual, todos)
          informe(i_actual, todos)
          todos[i_actual].paga_impuesto(@importe)
      end
    end
    
    def to_s
      str = "-------------------------------------------\n" +
              "CASILLA: \n" + "Nombre:            " + @nombre + "\n" +
                              "Tipo:              " + "Impuesto" + "\n"
                             
      str+= "Importe:           " + @importe.to_s + "\n"
  
      str += "-------------------------------------------\n"
        
      return str
    end

  end
  
end

