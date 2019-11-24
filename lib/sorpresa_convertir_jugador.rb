require_relative 'sorpresa.rb'
require_relative 'jugador_especulador.rb'

module Civitas

    class SorpresaConvertirJugador < Sorpresa

        def initialize(valor, texto)
            @valor = valor
            @texto = texto
        end

        def aplicar_a_jugador(actual,todos)

            if(jugador_correcto(actual, todos))
                informe(actual, todos)
                
                todos[actual] = JugadorEspeculador.nuevo_especulador(todos[actual], @valor)
            end
        end

    end

end