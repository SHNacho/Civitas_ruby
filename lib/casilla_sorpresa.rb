require_relative 'casilla.rb'

module Civitas
    class Casilla_sorpresa < Casilla
        def initialize(mazo, nombre)
            super(nombre)
            @mazo = mazo
            @sorpresa = sorpresa.siguiente
        end

        def recibe_jugador
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