require_relative 'enum.rb'
require_relative 'diario.rb'
require_relative 'enum.rb'
module Civitas
  class Sorpresa

    def initialize(tipo, tablero, valor, texto, mazo)
      @tablero = tablero
      @mazo = mazo
      @tipo = tipo
      @valor = valor
      @texto = texto
    end

    def self.new_ircarcel(tipo, tablero)
      new(tipo, tablero, -1, "Ve a la carcel directamenete", nil)
    end

    def self.new_ircasilla(tipo, tablero, valor, texto)
      new(tipo, tablero, valor, texto, nil)
    end

    def self.new_salircarcel(tipo, mazo)
      new(tipo, nil, -1, "Esta carta te permite salir de la carcel", mazo)
    end

    def self.new_sorpresa(tipo, valor, texto)
      new(tipo, nil, valor, texto, nil)
    end

    def to_s
      str = "'" + @tipo.to_s + ": " + @texto + "'"
      return str
    end

    def usada
      if @tipo == TipoSorpresa::SALIRCARCEL
        @mazo.habilitar_carta_especial(self)
      end
    end

    def salir_del_mazo
      if @tipo == TipoSorpresa::SALIRCARCEL
        @mazo.inhabilitar_carta_especial(self)
      end
    end

    def jugador_correcto(actual, todos)
      return (actual >= 0) && (actual < todos.size())
    end

    def informe(actual, todos)
      diario = Diario.instance 
      if (jugador_correcto(actual, todos))
        str = "Se aplica la sorpresa:" + to_s + " a " + todos[actual].nombre
        diario.ocurre_evento(str)
      end
    end

    def aplicar_a_jugador(actual, todos)
      if jugador_correcto(actual, todos)
        case @tipo
        when TipoSorpresa::IRCARCEL
          aplicar_a_jugador_ir_carcel(actual, todos)
        when TipoSorpresa::IRCASILLA
          aplicar_a_jugador_ir_a_casilla(actual, todos)
        when TipoSorpresa::PAGARCOBRAR
          aplicar_jugador_pagar_cobrar(actual, todos)
        when TipoSorpresa::PORCASAHOTEL
          aplicar_jugador_por_casa_hotel(actual, todos)
        when TipoSorpresa::PORJUGADOR
          aplicar_a_jugador_por_jugador(actual, todos)
        when TipoSorpresa::SALIRCARCEL
          aplicar_a_jugador_salir_carcel(actual, todos)
        end
        
      end
    end

    private
    def aplicar_a_jugador_salir_carcel (actual, todos)
      if jugador_correcto(actual, todos)
        informe(actual, todos)
        la_tiene = false

        for jugador in todos
          if jugador.tiene_salvoconducto
            la_tiene = true
          end
        end

        if !la_tiene
          todos[actual].obtener_salvoconducto(self)
          salir_del_mazo
        end
      end
    end

    def aplicar_a_jugador_por_jugador(actual, todos)
      if(jugador_correcto(actual, todos))
        informe(actual, todos)
        texto = "pagar a " + todos[actual].nombre + " " + @valor.to_s
        sorpresa_pagan = Sorpresa.new_sorpresa(TipoSorpresa::PAGARCOBRAR, @valor*(-1), texto)
        
        for i in 0..todos.size do
          if i != actual
            sorpresa_pagan.aplicar_a_jugador(i, todos)
          end
        end

        texto = "Recibe " + @valor.to_s + " de cada jugador"
        sorpresa_recibe = Sorpresa.new_sorpresa(TipoSorpresa::PAGARCOBRAR, @valor*(todos.size - 1), texto)

        sorpresa_recibe.aplicar_a_jugador(actual, todos)
      end
    end

    def aplicar_jugador_por_casa_hotel(actual, todos)
      if jugador_correcto(actual, todos)

        informe(actual, todos)

        incremento = @valor * todos[actual].cantidad_casas_hoteles

        todos[actual].modificar_saldo(incremento)

      end
    end

    def aplicar_jugador_pagar_cobrar(actual, todos)
      if jugador_correcto(actual, todos)
        informe(actual, todos)
        todos[actual].modificar_saldo(@valor)
      end
    end

    def aplicar_a_jugador_ir_carcel(actual, todos)
      if jugador_correcto(actual, todos)
        informe(actual, todos)
        casilla = @tablero.num_casilla_carcel
        todos[actual].encarcelar(casilla)
      end
    end

    def aplicar_a_jugador_ir_a_casilla(actual, todos)
      if jugador_correcto(actual, todos)
        informe(actual, todos)
        casilla_actual = todos[actual].num_casilla_actual

        tirada = @tablero.calcular_tirada(casilla_actual, @valor)
        nuevaPos = @tablero.nueva_posicion(casilla_actual, tirada)

        todos[actual].mover_a_casilla(@valor)
        casilla = @tablero.casilla(@valor)
        casilla.recibe_jugador(actual, todos)
      end
    end
    
    private_class_method :new
  end
end
