# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Casilla_juez < Casilla
  
  @@carcel = 0
  
  def initialize(num_casilla_carcel, nombre)
    super (nombre)
    @@carcel = num_casilla_carcel
  end
  
  def recibe_jugador (i_actual, todos)
    if jugador_correcto(i_actual, todos)
        informe(i_actual, todos)
        todos[i_actual].encarcelar(@@carcel)
    end
  end
  
  def to_s
    str = "-------------------------------------------\n" +
            "CASILLA: \n" + "Nombre:            " + @nombre + "\n" +
                            "Tipo:              " + "Juez" + "\n"
                            
    str+= "Casilla carcel:    " + @@carcel.to_s + "\n"
    
    str += "-------------------------------------------\n"
      
    return str
  end
end
