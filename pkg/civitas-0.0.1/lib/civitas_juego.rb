# encoding:utf-8

require_relative 'jugador.rb'
require_relative 'gestor_estados.rb'
require_relative 'mazo_sorpresas.rb'
require_relative 'tablero.rb'
require_relative 'casilla.rb'
require_relative 'sorpresa.rb'
require_relative 'dado.rb'

module Civitas
    class CivitasJuego
        
        def initialize (nombres)

            @jugadores = []
            if(nombres.size()<=4)
                for nombre in nombres
                    @jugadores << (Jugador.new_jugador(nombre))
                end
            end

            @gestor_estados = Gestor_estados.new
            @estado = @gestor_estados.estado_inicial
            @indice_jugador_actual = Dado.instance.quien_empieza(@jugadores.size)
            @mazo = MazoSorpresas.new
            @tablero = Tablero.new(4)
            inicializar_mazo_sorpresas(@tablero)
            inicializar_tablero(@mazo)

        end

        def actualizar_info
            puts @jugadores[@indice_jugador_actual].to_s

            if final_del_juego
                rank = ranking

                puts "EL RANKING ES EL SIGUIENTE: "

                for jugador in rank
                    puts (jugador.nombre + " con un saldo de: " +jugador.saldo.to_s)
                end
            end
        end

        def final_del_juego
            bancarrota = false

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
            info = (#"Nombre: " + @jugadores[@indice_jugador_actual].nombre 
                    + " Casilla: " + @jugadores[@indice_jugador_actual].num_casilla_actual.to_s
                    + " Saldo: " + @jugadores[@indice_jugador_actual].saldo.to_s)
            
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

        def siguiente_paso
            jugadorActual = @jugadores[@indice_jugador_actual]
            operacion = @gestor_estados.operaciones_permitidas(jugadorActual, @estado)
            if operacion == Operaciones_juego::PASAR_TURNO
                pasar_turno
                siguiente_paso_completado(operacion)
            elsif operacion == Operaciones_juego::AVANZAR
                avanzar_jugador
                siguiente_paso_completado(operacion)
            end
        end

        def vender(ip)
            return (@jugadores[@indice_jugador_actual].vender(ip))
        end

        def contabilizar_pasos_por_salida(jugadorActual)
            while @tablero.por_salida > 0
                jugadorActual.pasa_por_salida
            end
        end

        private
        
        def avanza_jugador
          jugador_actual = @jugadores[@indice_jugador_actual]
          
          posicion_actual = jugador_actual.num_casilla_actual
          
          tirada = Dado.instance.tirar
          
          posicion_nueva = @tablero.nueva_posicion(posicion_actual, tirada)
          
          casilla = @tablero.casilla(posicion_nueva)
          
          contabilizar_pasos_por_salida(jugador_actual)
          
          jugador_actual.mover_a_casilla(posicion_nueva)
          
          casilla.recibe_jugador(@indice_jugador_actual,@jugadores)
          
          contabilizar_pasos_por_salida(jugador_actual)
        end

        def inicializar_mazo_sorpresas(tablero)
            @mazo.al_mazo(Sorpresa.new_ircarcel(TipoSorpresa::IRCARCEL, tablero))
            @mazo.al_mazo(Sorpresa.new_ircasilla(TipoSorpresa::IRCASILLA, tablero, 5, "Ir a casilla 5"))
            @mazo.al_mazo(Sorpresa.new_sorpresa(TipoSorpresa::PORCASAHOTEL, 10, "Por casa hotel"))
        end

<<<<<<< HEAD
        def inicializar_tablero(mazo)
            
=======
        def inicializar_tablero(mazo)            
>>>>>>> origin/master
            @tablero.añade_juez
            @tablero.añade_casilla(Casilla.new_descanso("Descanso"))
            @tablero.añade_casilla(Casilla.new_impuesto(200, "Impuesto"))
            @tablero.añade_casilla(Casilla.new_sorpresa(mazo, "Sorpresa"))
        end

        def pasar_turno
            @indice_jugador_actual = (@indice_jugador_actual + 1) % @jugadores.size
        end

        def ranking 
            @jugadores.sort!.reverse!
            return @jugadores
        end
    end
end
