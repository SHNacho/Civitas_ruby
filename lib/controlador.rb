require_relative 'vista_textual.rb'
require_relative 'civitas_juego.rb'
require_relative 'enum.rb'
require_relative 'operacion_inmobiliaria.rb'

module Civitas
  class Controlador
    def initialize (juego, vista)
      @juego = juego
      @vista = vista
    end
    
    def juega
      @vista.setCivitasJuego(@juego)
      
      while !@juego.final_del_juego do
        @vista.actualizarVista
        
        @vista.pausa
        operacion = @juego.siguiente_paso
        @vista.mostrarSiguienteOperacion(operacion)
        
        if operacion != Operaciones_juego::PASAR_TURNO
          @vista.mostrarEventos
        end
        
        if !@juego.final_del_juego
          
          case operacion

          when Operaciones_juego::COMPRAR
            # respuesta = @vista.comprar
            
            # if respuesta == Respuestas::SI
            #   @juego.comprar
            # end
              @juego.siguiente_paso_completado(operacion)

          when Operaciones_juego::GESTIONAR
            @vista.gestionar
            
            gestion = @vista.getGestion
            propiedad = @vista.getPropiedad
            
            operacion_inm = Operacion_inmobiliaria.new(gestion, propiedad)
            
            case Gestiones_inmobiliarias::LISTA_GESTIONES[gestion]
            when Gestiones_inmobiliarias::VENDER
              @juego.vender(propiedad)
            when Gestiones_inmobiliarias::HIPOTECAR
              @juego.hipotecar(propiedad)
            when Gestiones_inmobiliarias::CANCELAR_HIPOTECA
              @juego.cancelar_hipoteca(propiedad)
            when Gestiones_inmobiliarias::CONSTRUIR_CASA
              @juego.construir_casa(propiedad)
            when Gestiones_inmobiliarias::CONSTRUIR_HOTEL
              @juego.construir_hotel(propiedad)
            when Gestiones_inmobiliarias::TERMINAR
              @juego.siguiente_paso_completado(operacion)
            end
            
          when Operaciones_juego::SALIR_CARCEL
            salida = @vista.salir_carcel
        
            if salida == Salidas_carcel::PAGANDO
              @juego.salir_carcel_pagando
            else
            @juego.salir_carcel_tirando
            end
        
            @juego.siguiente_paso_completado(operacion)
          end
        end
      end
      
      if @juego.final_del_juego
        @juego.ranking
      end
    end
  end
end
