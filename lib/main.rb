# encoding:UTF-8

require_relative 'tablero.rb'
require_relative 'sorpresa.rb'
require_relative 'casilla.rb'
require_relative 'mazo_sorpresas.rb'
require_relative 'dado.rb'

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
    PASAR_TURNO = :pasar_turno
    SALIR_CARCEL = :salir_carcel
    AVANZAR = :avanzar 
    COMPRAR = :comprar
    GESTIONAR = :gestionar
  end
  
  # A continuación vamos a llamar 100 veces al método quien empieza
  
  n =4          #Número de participantes
  
  p1 = 0        #Contador para saber cuantas veces aparece cada participante
  p2 = 0
  p3 = 0
  p4 = 0
  
  k = 0
  
  dado = Dado.instance
  
  for i in 1..100 do
    k = dado.quien_empieza(n)
    puts k
    
    case k 
    when k = 0
      p1+=1
    when k = 1
      p2+=1
    when k = 2
      p3+=1
    when k = 3
      p4+=1
    end
  end
  
  puts ("Participante 1")
  puts p1
  
  puts ("Participante 2")
  puts p2
  
  puts ("Participante 3")
  puts p3
  
  puts ("Participante 4")
  puts p4
  
  # Comprobamos que funciona el método debug
  
  puts("Comprobamos el metodo debug")
   
  d = true
  
  puts("Para debug=true, se dan las siguientes tiradas:")
  
  dado.set_debug(d)
  
  for j in 1..5 do
    puts(dado.tirar())
  end
  
  d = false
  
  puts("Para debug=false, se dan las siguientes tiradas:")
  
  dado.set_debug(d)
  
  for m in 1..5 do
    puts(dado.tirar())
  end
  
  # Comprobamos que funciona getUltimoResultado() y salgoDeLaCarcel()
        
  puts("Comprobamos el metodo getUltimoResultado")
        
  puts(dado.leer_ultimo_resultado)
        
  # Podemos observar que devuelve el último valor de la tirada
        
  lol = true;
        
  lol = dado.salgo_de_la_carcel();
        
  if lol == true
    puts("salgo de la carcel")
  else
    puts("no salgo de la carcel")
  end
  
  # Mostramos un valor al menos de cada uno de los enumerados
  
  puts (TipoCasilla::CALLE)
  
  puts (TipoSorpresa::IRCARCEL)
  
  puts(Estados_juego::INICIO_TURNO)

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
  
  #Funcionamiento de la clase tablero
  tablero = Tablero.new(3)
  tablero.añade_juez()

  casilla = Casilla.new("cas")
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

  #TODO varias tiradas de dado y calcular la posición final
  pos_actual = 0
  puts "Estamos en la casilla " + pos_actual.to_s
  for i in (0..3) do
    tirada = dado.tirar
    puts "Ha salido un " + tirada.to_s
    pos_actual = tablero.nueva_posicion(pos_actual, tirada)
    puts "Avanzo a la casilla " + pos_actual.to_s
  end

  

end
