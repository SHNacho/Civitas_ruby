# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.


require_relative 'vista_textual.rb'

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
        
        @juego.final_del_juego
        
        if !@juego.final_del_juego
          
          case operacion
            when Operaciones_juego::COMPRAR
              respuesta = @vista.comprar
              
              if respuesta == Respuesta::SI
                @juego.comprar
                @juego.siguiente_paso_completado(operacion)
              end
            when Operaciones_juego::GESTIONAR
              @vista.gestionar
              
              gestion = @vista.gestion
              propiedad = @vista.propiedad
              
              operacion_inm = Operacion_inmobiliaria.new(gestion, propiedad)
              
              case gestion
                when Gestiones_inmobiliarias::VENDER
                  @juego.vender(propiedad)
                when Gestiones_inmobiliarias::HIPOTECAR
                  @juego.vender(propiedad)
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
              @vista.
          end
          
        end
      end
    end
  end
end
