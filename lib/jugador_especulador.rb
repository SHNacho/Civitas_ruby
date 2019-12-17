require_relative 'jugador.rb'

require_relative 'titulo_propiedad.rb'

module Civitas

    class JugadorEspeculador < Jugador

        @@factor_especulador = 2
        @casas_max = Jugador.casas_max * @@factor_especulador
        @hoteles_max = Jugador.hoteles_max * @@factor_especulador

        def initialize(jugador, fianza)
            super(nil, jugador)
            @fianza = fianza
        end

        def self.nuevo_especulador(jugador, fianza)
            jugador_especulador = new(jugador, fianza)

            for propiedad in jugador.propiedades
                propiedad.actualiza_propietario_por_conversion(jugador_especulador)
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

        def self.casas_max
            return @casas_max
        end

        def self.hoteles_max
            return @hoteles_max
        end

        def encarcelar (num_casilla_carcel)
            if debe_ser_encarcelado
                if saldo < @fianza
                    mover_a_casilla(num_casilla_carcel)
                    @encarcelado = true
                    Diario.instance.ocurre_evento("Ha sido encarcelado " + nombre)
                else
                    paga(@fianza)
                end
            end

            return(@encarcelado)
        end

        def paga_impuesto(cantidad)
            super(cantidad/@@factor_especulador)
        end
        
    end
end