# encoding:utf-8

require_relative 'jugador.rb'
require_relative 'gestor_estados.rb'
require_relative 'mazo_sorpresas.rb'
require_relative 'tablero.rb'
require_relative 'casilla.rb'
require_relative 'sorpresa.rb'
require_relative 'dado.rb'
require_relative 'titulo_propiedad.rb'

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
            @tablero = Tablero.new(5)
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
        
        def cancelar_hipoteca (ip)
          return @jugadores[@indice_jugador_actual].cancelar_hipoteca(ip)
        end
        
        def construir_casa (ip)
          return @jugadores[@indice_jugador_actual].construir_casa(ip)
        end
        
        def construir_hotel(ip)
          return @jugadores[@indice_jugador_actual].construir_hotel(ip)
        end
        
        def comprar
          res = false
          
          jugador_actual = @jugadores[@indice_jugador_actual]
          
          num_casilla_actual = jugador_actual.num_casilla_actual
          
          casilla = @tablero.casilla(num_casilla_actual)
          
          titulo = casilla.titulo_propiedad
          
          res = jugador_actual.comprar(titulo)

          return res
        end

        def hipotecar(ip)
            @jugadores[@indice_jugador_actual].hipotecar(ip)
        end

        def final_del_juego
            bancarrota = false
            i = 0

            while ( !bancarrota && (i < @jugadores.size) )
                if @jugadores[i].en_bancarrota
                    bancarrota = true
                end
                i += 1
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
            info = @jugadores[@indice_jugador_actual].to_s
            
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
                avanza_jugador
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
            @mazo.al_mazo(Sorpresa.new_ircasilla(TipoSorpresa::IRCASILLA, tablero,
                                                 7, "Ve a la casilla 7"))
            @mazo.al_mazo(Sorpresa.new_ircasilla(TipoSorpresa::IRCASILLA, tablero,
                                                 14, "Ve a la casilla 14"))
            @mazo.al_mazo(Sorpresa.new_sorpresa(TipoSorpresa::PORCASAHOTEL, 50,
                                                "Cobra 50 por cada propiedad"))
            @mazo.al_mazo(Sorpresa.new_sorpresa(TipoSorpresa::PAGARCOBRAR, 200, "Cobra 200"))
            @mazo.al_mazo(Sorpresa.new_sorpresa(TipoSorpresa::PAGARCOBRAR, -200, "Paga 200"))
            @mazo.al_mazo(Sorpresa.new_sorpresa(TipoSorpresa::PORCASAHOTEL, -50, 
                                                "Paga 50 por cada propiedad"))
            @mazo.al_mazo(Sorpresa.new_salircarcel(TipoSorpresa::SALIRCARCEL, @mazo))
            @mazo.al_mazo(Sorpresa.new_sorpresa(TipoSorpresa::PORJUGADOR, 50, "Recibe 50 de cada jugador"))
            @mazo.al_mazo(Sorpresa.new_sorpresa(TipoSorpresa::PORJUGADOR, -50, "Paga 50 a cada jugador"))
            
        end

        def inicializar_tablero(mazo)
          # Salida ya se añade en la posición 0
          
          # Añadimos en la posición 1 la calle 1
          
          @tablero.añade_casilla(Casilla.new_calle(Titulo_propiedad.new("Calle 1", 100, 0.05, 200, 400, 300)))
          
          # Añadimos en la posición 2 la casilla impuesto
          
          @tablero.añade_casilla(Casilla.new_impuesto(300, "Impuesto"))
          
          # Añadimos en la posición 3 la calle 2
          
          @tablero.añade_casilla(Casilla.new_calle(Titulo_propiedad.new("Calle 2", 225, 0.075, 450, 900, 675)))
          
          # Añadimos en la posición 4 la calle 3
          
          @tablero.añade_casilla(Casilla.new_calle(Titulo_propiedad.new("Calle 3", 150, 0.05, 300, 600, 450)))
          
          # En la posición 5 ya está la cárcel
          
          # Añadimos en la posición 6 la calle 4
          
          @tablero.añade_casilla(Casilla.new_calle(Titulo_propiedad.new("Calle 4", 300, 0.075, 600, 1200, 900)))
          
          # Añadimos en la posición 7 la sorpresa 1
          
          @tablero.añade_casilla(Casilla.new_sorpresa(mazo, "Sorpresa 1"))
          
          # Añadimos en la posición 8 la calle 5
          
          @tablero.añade_casilla(Casilla.new_calle(Titulo_propiedad.new("Calle 5", 125, 0.05, 250, 500, 375)))
          
          # Añadimos en la posición 9 la calle 6
          
          @tablero.añade_casilla(Casilla.new_calle(Titulo_propiedad.new("Calle 6", 200, 0.05, 400, 800, 600)))
          
          # Añadimos en la posición 10 el parking
          
          @tablero.añade_casilla(Casilla.new_descanso("Parking"))
          
          # Añadimos en la posición 11 la calle 7
          
          @tablero.añade_casilla(Casilla.new_calle(Titulo_propiedad.new("Calle 7", 400, 0.1, 800, 1600, 1200)))
          
          # Añadimos en la posición 12 la calle 8
          
          @tablero.añade_casilla(Casilla.new_calle(Titulo_propiedad.new("Calle 8", 250, 0.075, 500, 1000, 750)))
          
          # Añadimos en la posición 13 la sorpresa 2
          
          @tablero.añade_casilla(Casilla.new_sorpresa(mazo, "Sorpresa 2"))
          
          # Añadimos en la posición 14 la calle 9
          
          @tablero.añade_casilla(Casilla.new_calle(Titulo_propiedad.new("Calle 9", 175, 0.05, 350, 700, 525)))
          
          # Añadimos en la posición 15 el juez
          
          @tablero.añade_juez
          
          # Añadimos en la posición 16 la calle 10
          
          @tablero.añade_casilla(Casilla.new_calle(Titulo_propiedad.new("Calle 10", 200, 0.05, 400, 800, 600)))
          
          # Añadimos en la posición 17 la calle 11
          
          @tablero.añade_casilla(Casilla.new_calle(Titulo_propiedad.new("Calle 11", 350, 0.1, 700, 1400, 1050)))
          
          # Añadimos en la posición 18 la calle 12
          
          @tablero.añade_casilla(Casilla.new_calle(Titulo_propiedad.new("Calle 12", 300, 0.075, 600, 1200, 900)))
          
          # Añadimos en la posición 19 la sorpresa 3
          
          @tablero.añade_casilla(Casilla.new_sorpresa(mazo, "Sorpresa3"))
          
          
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
