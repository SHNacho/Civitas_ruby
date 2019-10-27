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
    
    module Salidas_carcel
      PAGANDO = :pagando
      TIRANDO = :tirando
    end
    
    module Respuestas
      SI = :si
      NO = :no
    end
      
    module Gestiones_inmobiliarias
      VENDER            = :vender
      HIPOTECAR         = :hipotecar
      CANCELAR_HIPOTECA = :cancelar_hipoteca
      CONSTRUIR_CASA    = :construir_casa
      CONSTRUIR_HOTEL   = :construir_hotel
      TERMINAR          = :terminar 
    end
    
    #DECLARACIÓN DE LOS CONTENEDORES
    
    lista_respuestas[Respuestas::NO,RESPUESTAS::SI]
    
    lista_salidas_carcel[Salidas_carcel::PAGANDO,Salidas_carcel::TIRANDO]
    
    lista_gestiones[Gestiones_inmobiliarias::VENDER,Gestiones_inmobiliarias::HIPOTECAR,
                    Gestiones_inmobiliarias::CANCELAR_HIPOTECA, Gestiones_inmobiliarias::CONSTRUIR_CASA,
                    Gestiones_inmobiliarias::CONSTRUIR_HOTEL, Gestiones_inmobiliarias::TERMINAR]
end