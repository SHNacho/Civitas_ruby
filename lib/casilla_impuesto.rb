# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'casilla.rb'

class Casilla_impuesto < Casilla
  def initialize (nombre, cantidad)
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
