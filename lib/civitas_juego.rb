module Civitas
    class CivitasJuego
        
        def initialize (nombres)

            @jugadores = []
            if(nombres.size()<=4)
                for nombre in nombres
                    @jugadores.push(Jugador.new(nombre))
                end
            end

            @gestorEstados = Gestor_estados.new
            @gestorEstados.estado_inicial
            @indiceJugadorActual = Dado.instance.quien_empieza(@jugadores.size)
            @estado = nil
            @mazo = MazoSorpresas.new
            inicializar_tablero(@mazo)
            inicializar_mazo(@tablero)
        end

        def actualizar_info
            puts "El nombre del jugador actual es: " + @jugadores[@indiceJugadorActual]
            puts "El jugador actual se encuentra en la casilla: " + @jugadores[@indiceJugadorActual].numCasillaActual.to_s
            puts "El saldo del jugador actual es: " + @jugadores[@indiceJugadorActual].saldo.to_s
            puts "Tiene " + @jugadores[@indiceJugadorActual].propiedades.size.to_s + "propiedades"

            if final_del_juego
                rank = ranking

                puts "EL RANKING ES EL SIGUIENTE: "

                for jugador in rank
                    puts jugador.nombre + " con un saldo de: " jugador.saldo
                end
            end
        end

        def final_del_juego
            boolean bancarrota = false

            for jugador in @jugadores
                if jugador.en_bancarrota
                    bancarrota = true
                end
            end

            return bancarrota
        end

        def get_casilla_actual
            numCasilla = @jugadores[@indiceJugadorActual].numCasillaActual
            return tablero.casilla(numCasilla)
        end



    end
end