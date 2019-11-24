require_relative 'jugador.rb'

module Civitas
    class JugadorEspecualdor < Jugador
        @@factor_especulador = 2

        def initialize(nombre, fianza)
            @fianza = fianza
            new_copy(nombre)
        end

        def self.nuevo_especulador(jugador, fianza)
            jugador_especulador = Jugador.new(jugador, fianza)
            for propiedad in jugador.propiedades
                propiedad.actualizar_propietario_por_conversion(jugador_especulador)
            end
            return jugador_especulador
        end

        private_class_method :new

        def to_s
            encarcelado_str = @encarcelado ? "Sí" : "No"
            salvoconducto_str = (@salvoconducto == nil) ? "No" : "Sí"
            propiedades_str = @propiedades.size.to_s
            puede_comprar_str = @puede_comprar ? "Sí" : "No"
            str =        "-------------------------------------------\n" +
                            "JUGADOR \n" +
                            "Tipo de jugador: Especulador \n" +
                            "Nombre:          " + @nombre + "\n" + 
                            "Saldo:           " + @saldo.to_s + "\n" +
                            "Casilla actual:  " + @num_casilla_actual.to_s + "\n" +
                            "Encarcelado:     " + encarcelado_str + "\n" +
                            "Salvoconducto:   " + salvoconducto_str + "\n" +
                            "Propiedades:     " + propiedades_str + "\n" +
                            "Puede comprar    " + puede_comprar_str + "\n"
                            "-------------------------------------------\n"

            return str
        end

    end
end