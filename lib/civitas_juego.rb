# encoding:utf-8

module Civitas
    class CivitasJuego
        
        def initialize (nombres)

            @jugadores = []
            if(nombres.size()<=4)
                for nombre in nombres
                    @jugadores << Jugador.new(nombre)
                end
            end

            @gestor_estados = Gestor_estados.new
            @gestor_estados.estado_inicial
            @indice_jugador_actual = Dado.instance.quien_empieza(@jugadores.size)
            @estado = nil
            @mazo = MazoSorpresas.new
            inicializar_tablero(@mazo)
            inicializar_mazo(@tablero)
        end

        def actualizar_info
            puts "El nombre del jugador actual es: " + @jugadores[@indice_jugador_actual]
            puts "El jugador actual se encuentra en la casilla: " + @jugadores[@indice_jugador_actual].num_casilla_actual.to_s
            puts "El saldo del jugador actual es: " + @jugadores[@indice_jugador_actual].saldo.to_s
            puts "Tiene " + @jugadores[@indice_jugador_actual].propiedades.size.to_s + "propiedades"

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
            numCasilla = @jugadores[@indice_jugador_actual].num_casilla_actual
            return @tablero.casilla(numCasilla)
        end

        def get_jugador_actual
            return @jugadores[@indice_jugador_actual]
        end

        def info_jugador_texto
            info = ("Nombre: " + @jugadores[@indice_jugador_actual].nombre 
                    + " Casilla: " + @jugadores[@indice_jugador_actual].num_casilla_actual 
                    + " Saldo: " + @jugadores[@indice_jugador_actual].saldo)
            
            return info
        end
        
        def salir_carcel_pagando
            return @jugadores[@indice_jugador_actual].salir_carcel_pagando
        end

        def salir_carcel_tirando
            return @jugadores[@indice_jugador_actual].salir_carcel_tirando
        end

        def siguiente_paso_completado(operacion)
            @estado = @gestor_estados.siguiente_estado(@jugadores[@indice_jugador_actual],
                                                      @estado, operacion)
        end

        def vender(ip)
            return (@jugadores[@indice_jugador_actual].vender(ip))
        end

        def contabilizar_paso_por_salida(jugadorActual)
            if (@tablero.por_salida > 0)
                jugadorActual.pasa_por_salida
            end
        end

        private

        def inicializar_mazo_sorpresas(tablero)
            @mazo.al_mazo(Sorpresa.new_ircarcel(TipoSorpresa::IRCARCEL, tablero))
            @mazo.al_mazo(Sorpresa.new_ircasilla(TipoSorpresa::IRCASILLA, tablero, 5, "Ir a casilla 5"))
            @mazo.al_mazo(Sorpresa.new_sorpresa(TipoSorpresa::PORCASAHOTEL, 10, "Por casa hotel"))
        end

        def inicializar_tablero(mazo)
            @tablero = Tablero.new(4)
            
            @tablero.añade_juez
            @tablero.añade_casilla(Casilla.new_descanso("Descanso"))
            @tablero.añade_casilla(Casilla.new_impuesto(200, "Impuesto"))
            @tablero.añade_casilla(Casilla.new_sorpresa(mazo, "Sorpresa"))
        end

        def pasar_turno
            @indice_jugador_actual = (@indice_jugador_actual + 1) % @jugadores.size
        end

        def ranking 
            @jugadores.sort
            return @jugadores
        end

    end
end