require_relative 'titulo_propiedad.rb'
require_relative 'casilla.rb'

module Civitas
    class Casilla_calle < Casilla

        def initialize(nombre, titulo_propiedad)
            super(nombre)
            @titulo_propiedad = titulo_propiedad
        end

        def recibe_jugador(i_actual, todos)
            if jugador_correcto(i_actual, todos)
                informe(i_actual, todos)
                jugador = todos[i_actual]
                if !@titulo_propiedad.tiene_propietario
                  jugador.puede_comprar_casilla
                else
                  @titulo_propiedad.tramitar_alquiler(jugador)
                end
            end
        end

        def to_s

            str = "-------------------------------------------\n" +
            "CASILLA: \n" + "Nombre:            " + @nombre + "\n" +
                            "Tipo:              " + "Calle" + "\n" +
                            "Precio:            " + @titulo_propiedad.precio_compra.to_s + "\n"
            str += "-------------------------------------------\n"
            
            return str
        end
    end
end