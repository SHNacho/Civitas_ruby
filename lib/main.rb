
require_relative 'tablero.rb'
require_relative 'sorpresa.rb'
require_relative 'mazo_sorpresas.rb'

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
  
  mazo       = Civitas::MazoSorpresas.new
  sorpresa_1 = Civitas::Sorpresa.new("a")
  sorpresa_2 = Civitas::Sorpresa.new("b")
  sorpresa_3 = Civitas::Sorpresa.new("c")
  sorpresa_4 = Civitas::Sorpresa.new("d")
  sorpresa_5 = Civitas::Sorpresa.new("e")
  mazo.al_mazo(sorpresa_1)
  mazo.al_mazo(sorpresa_2)
  mazo.al_mazo(sorpresa_3)
  mazo.al_mazo(sorpresa_4)
  mazo.al_mazo(sorpresa_5)
  sorpresa = mazo.siguiente
  puts sorpresa.nombre
  
end
