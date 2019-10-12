module Civitas
    module TipoCasilla
        CALLE    = :calle
        SORPRESA = :sorpresa
        JUEZ     = :juez
        IMPUESTO = :impuesto
        DESCANSO = :descanso
    end
      
    module TipoSorpresa
        IRCARCEL     = :ircarcel
        IRCASILLA    = :ircasilla
        PAGARCOBRAR  = :pagarcobrar
        PORCASAHOTEL = :pocashotel
        PORJUGADOR   = :porjugador
        SALIRCARCEL  = :salircarcel
    end
      
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
end