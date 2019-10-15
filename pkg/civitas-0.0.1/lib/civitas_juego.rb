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
            # puts "El nombre del jugador actual es: " + @jugadores[@indice_jugador_actual].nombre
            puts "El jugador actual se encuentra en la casilla: " + @jugadores[@indice_jugador_actual].num_casilla_actual.to_s
            # puts "El saldo del jugador actual es: " + @jugadores[@indice_jugador_actual].saldo.to_s
            # puts "Tiene " + @jugadores[@indice_jugador_actual].propiedades.size.to_s + "propiedades"

            if final_del_juego
                rank = ranking

                puts "EL RANKING ES EL SIGUIENTE: "

                for jugador in rank
                    puts (jugador.nombre + " con un saldo de: " +jugador.saldo)
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

        def vender(ip)
            return (@jugadores[@indice_jugador_actual].vender(ip))
        end

        def contabilizar_pasos_por_salida(jugadorActual)
            while @tablero.por_salida > 0
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

        public

        # def test
        #     @jugadores[0].modificar_saldo(200)
        #     @jugadores[1].modificar_saldo(300)
        #     @jugadores[2].modificar_saldo(600)
        #     @jugadores[3].modificar_saldo(100)

        #     puts "RANKING"
        #     ranking

        #     for jugador in @jugadores
        #         puts jugador.nombre
        #     end

        #     puts "FINAL DEL JUEGO"
        #     if final_del_juego
        #         puts "El juego ha terminado"
        #     end

        #     puts get_casilla_actual.nombre

        #     @jugadores[2].encarcelar(4)
        #     if @jugadores[2].salir_carcel_pagando
        #         puts "Ha salido pagando"
        #     end
        #     @jugadores[3].encarcelar(4)
        #     if @jugadores[3].salir_carcel_tirando
        #         puts "Ha salido tirando"
        #     end

        #     puts "Jugador actual: " + @indice_jugador_actual.to_s
        #     puts @jugadores[@indice_jugador_actual].num_casilla_actual.to_s
        #     nuevaPos = @tablero.nueva_posicion(@jugadores[@indice_jugador_actual].num_casilla_actual, 8)
        #     @jugadores[@indice_jugador_actual].mover_a_casilla(nuevaPos)
        #     puts @jugadores[@indice_jugador_actual].num_casilla_actual.to_s
        #     contabilizar_pasos_por_salida(@jugadores[@indice_jugador_actual])

        #     puts "Saldo: " + @jugadores[@indice_jugador_actual].saldo.to_s

        #     siguiente_paso_completado(Operaciones_juego::AVANZAR)

        #     puts @estado.to_s

        #     pasar_turno

        #     puts @indice_jugador_actual.to_s

        #     s1 = Sorpresa.new_ircarcel(TipoSorpresa::IRCARCEL, @tablero)
        #     s1.aplicar_a_jugador(@indice_jugador_actual, @jugadores)
        #     puts "Estoy en: " + @jugadores[@indice_jugador_actual].num_casilla_actual.to_s

        #     puts @jugadores[@indice_jugador_actual].to_string

        #     puts "Saldo actual de " + @indice_jugador_actual.to_s + ": " + @jugadores[@indice_jugador_actual].saldo.to_s
        #     s2 = Sorpresa.new_sorpresa(TipoSorpresa::PORJUGADOR, 100, "muertos")
        #     s2.aplicar_a_jugador(@indice_jugador_actual, @jugadores)
        #     puts "Saldo final de " + @indice_jugador_actual.to_s + ": " + @jugadores[@indice_jugador_actual].saldo.to_s

        #     pasar_turno

        #     s3 = Sorpresa.new_salircarcel(TipoSorpresa::SALIRCARCEL, @mazo)
        #     s3.aplicar_a_jugador(@indice_jugador_actual, @jugadores)
        #     puts @jugadores[@indice_jugador_actual].to_string

        # end

    end
end