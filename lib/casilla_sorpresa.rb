require_relative 'casilla.rb'

module Civitas
    class CasillaSorpresa < Casilla
        def initialize(mazo, nombre)
            super(nombre)
            @mazo = mazo
            @sorpresa = mazo.siguiente
        end

        def recibe_jugador(i_actual, todos)
            if jugador_correcto(i_actual, todos)
                @sorpresa = @mazo.siguiente
                informe(i_actual,todos)
                @sorpresa.aplicar_a_jugador(i_actual, todos)
            end
        end

        def to_s
            str = "-------------------------------------------\n" +
            "CASILLA: \n" + "Nombre:            " + @nombre + "\n" +
                            "Tipo:              " + "Sorpresa" + "\n"

            str += "-------------------------------------------\n"
      
            return str
        end
    end
end