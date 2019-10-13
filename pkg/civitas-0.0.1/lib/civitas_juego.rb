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
                    jugador = Jugador.new(nombre)
                    @jugadores << jugador
                end
            end

            @gestor_estados = Gestor_estados.new
            @gestor_estados.estado_inicial
            @indice_jugador_actual = Dado.instance.quien_empieza(@jugadores.size)
            @estado = nil
            @mazo = MazoSorpresas.new
            inicializar_mazo_sorpresas(@tablero)
            inicializar_tablero(@mazo)
        end

        def actualizar_info
            puts "El nombre del jugador actual es: " + @jugadores[@indice_jugador_actual].nombre
            puts "El jugador actual se encuentra en la casilla: " + @jugadores[@indice_jugador_actual].num_casilla_actual.to_s
            puts "El saldo del jugador actual es: " + @jugadores[@indice_jugador_actual].saldo.to_s
            puts "Tiene " + @jugadores[@indice_jugador_actual].propiedades.size.to_s + "propiedades"

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
            @jugadores.sort!.reverse!
            return @jugadores
        end

        public

        def main
            @jugadores[0].modificar_saldo(200)
            @jugadores[1].modificar_saldo(300)
            @jugadores[2].modificar_saldo(600)
            @jugadores[3].modificar_saldo(100)

            ranking

            for jugador in @jugadores
                puts jugador.nombre
            end

            if final_del_juego
                puts "El juego ha terminado"
            end

            puts get_casilla_actual.nombre

            @jugadores[2].encarcelar(4)
            if @jugadores[2].salir_carcel_pagando
                puts "Ha salido pagando"
            end
            @jugadores[3].encarcelar(4)
            if @jugadores[3].salir_carcel_tirando
                puts "Ha salido tirando"
            end
            
            sorpresa2 = Sorpresa.new_ircasilla(TipoSorpresa::IRCASILLA, @tablero, 3, "ircasilla")
            
            sorpresa1 = Sorpresa.new_ircasilla(TipoSorpresa::IRCASILLA, @tablero, 2, "ircasilla")
  
            sorpresa2.aplicar_a_jugador(1, jugadores)
            
            sorpresa1.aplicar_a_jugador(1, jugadores)
            
            
        end

    end
end