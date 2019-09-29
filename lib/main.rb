
require_relative 'tablero.rb'
require_relative 'sorpresa.rb'
require_relative 'casilla.rb'
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
  
  # Funcionamiento de la clase MazoSorpresas
  mazo       = MazoSorpresas.new
  sorpresa_1 = Sorpresa.new("Sorpresa 1")
  sorpresa_2 = Sorpresa.new("Sorpresa 2")

  mazo.al_mazo(sorpresa_1)
  mazo.al_mazo(sorpresa_2)

  sorpresa = mazo.siguiente

  mazo.inhabilitar_carta_especial(sorpresa_2)
  mazo.habilitar_carta_especial(sorpresa_2)


  diario = Diario.instance
  while diario.eventos_pendientes
    puts diario.leer_evento    
  end
  
  tablero = Tablero.new(3)
  tablero.añade_juez()

  casilla1 = Casilla.new("Primera")
  casilla2 = Casilla.new("Segunda")
  casilla3 = Casilla.new("Tercera")
  casilla4 = Casilla.new("Cuarta")

  tablero.añade_casilla(casilla1)
  tablero.añade_casilla(casilla2)
  tablero.añade_casilla(casilla3)
  tablero.añade_casilla(casilla4)

  for i in (0..6) do
    casilla = tablero.casilla(i)
    puts casilla.nombre
  end
end
