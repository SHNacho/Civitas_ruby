require_relative 'sorpresa.rb'
require_relative 'jugador_especulador.rb'

module Civitas

    class SorpresaConvertirJugador < Sorpresa

        def initialize(valor, texto)
            super(texto)
            @valor = valor
        end

        def to_s
            str = "'Sorpresa convertir jugador: " + @texto + "'"
        end

        def aplicar_a_jugador(actual,todos)

            if(jugador_correcto(actual, todos))
                informe(actual, todos)
                
                todos[actual] = JugadorEspeculador.nuevo_especulador(todos[actual], @valor)
            end
        end

        public_class_method :new

    end

end