# encoding:UTF-8

require_relative 'civitas_juego.rb'
require_relative 'enum.rb'
require_relative 'casilla.rb'
require_relative 'titulo_propiedad.rb'
require_relative 'jugador.rb'
require_relative 'diario.rb'
module Civitas

  nombres = ["Nacho", "Julio", "Adris", "Jacob"]
  puts nombres.size.to_s
  juego = CivitasJuego.new(nombres)
  puts "Juego iniciado"

  tablero = Tablero.new(4)
            
  

  mazo = MazoSorpresas.new()

  tablero.añade_juez

  tablero.añade_casilla(Casilla.new("Descanso"))
  tablero.añade_casilla(CasillaImpuesto.new(200, "Impuesto"))
  tablero.añade_casilla(CasillaSorpresa.new(mazo, "Sorpresa"))

  mazo.al_mazo(Sorpresa.new_ircarcel(TipoSorpresa::IRCARCEL, tablero))
  mazo.al_mazo(Sorpresa.new_ircasilla(TipoSorpresa::IRCASILLA, tablero, 5, "Ir a casilla 5"))
  mazo.al_mazo(Sorpresa.new_sorpresa(TipoSorpresa::PORCASAHOTEL, 10, "Por casa hotel"))

  titulo = Titulo_propiedad.new("titulo", 10, 10, 10, 10, 10)

  casilla1 = Casilla.new("Descanso")
  casilla2 = CasillaCalle.new(titulo)
  casilla3 = CasillaImpuesto.new(100, "Impuesto")
  casilla4 = CasillaJuez.new(4, "Juez")
  casilla5 = CasillaSorpresa.new(mazo, "Sorpresa")


  puts casilla3.to_s

  jugadores = [Jugador.new_jugador("Julius"), Jugador.new_jugador("Nacho"), Jugador.new_jugador("Otro"), Jugador.new_jugador("Pepe")]


  casilla4.test(jugadores)
  diario = Diario.instance
  puts diario.leer_evento
  puts jugadores[1].num_casilla_actual

  juego.test

  jugadores[0].test
  puts jugadores[0].to_s

  titulo = Titulo_propiedad.new("Titulo", 10, 10, 10, 10, 10)
  puts titulo.to_s

    
end
