module Civitas    
    module Estados_juego
        INICIO_TURNO      = :inicio_turno
        DESPUES_CARCEL    = :despues_carcel
        DESPUES_AVANZAR   = :despues_avanzar
        DESPUES_COMPRAR   = :despues_comprar
        DESPUES_GESTIONAR = :despues_gestionar
    end
    
    module Operaciones_juego
        PASAR_TURNO  = :pasar_turno
        SALIR_CARCEL = :salir_carcel
        AVANZAR      = :avanzar
        COMPRAR      = :comprar
        GESTIONAR    = :gestionar
    end
    
    module Salidas_carcel
      PAGANDO = :pagando
      TIRANDO = :tirando

      LISTA_SALIDAS_CARCEL = [PAGANDO, TIRANDO]
    end
    
    module Respuestas
      SI = :si
      NO = :no

      LISTA_RESPUESTAS = [SI, NO]
    end
      
    module Gestiones_inmobiliarias
      VENDER            = :vender
      HIPOTECAR         = :hipotecar
      CANCELAR_HIPOTECA = :cancelar_hipoteca
      CONSTRUIR_CASA    = :construir_casa
      CONSTRUIR_HOTEL   = :construir_hotel
      TERMINAR          = :terminar

      LISTA_GESTIONES = [VENDER, HIPOTECAR, CANCELAR_HIPOTECA, CONSTRUIR_CASA,
                         CONSTRUIR_HOTEL, TERMINAR]
    end
end
