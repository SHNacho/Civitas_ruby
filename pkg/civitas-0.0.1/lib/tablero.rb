# encoding:utf-8

module Civitas  
  class Tablero
    
    attr_reader :num_casilla_carcel
    
    def initialize (_num_casilla_carcel)
      if _num_casilla_carcel >= 1
        @num_casilla_carcel = _num_casilla_carcel
      else
        @num_casilla_carcel = 1
      end
      @casillas = []
      @casillas[0] = Casilla.new("Salida")
      @por_salida = 0
      @tiene_juez = false
    end
    
    private
    def correcto()
      return (@casillas.size > num_casilla_carcel) && @tiene_juez
    end
    
    def correcto(num_casilla)
      es_correcto = false
      if self.correcto && (num_casilla < @casillas.size)
        es_correcto = true
      end
      
      return es_correcto
    end
    
    public
    
    def por_salida
      valor = @por_salida
      if @por_salida > 0
        @por_salida -= 1
      end
      
      return valor
    end
    
    def añade_casilla(casilla) 
      if @casillas.size == @num_casilla_carcel
        @casillas.push(Casilla.new("Cárcel"))
      end
      @casillas.push(casilla)
      if @casillas.size == @num_casilla_carcel
        @casillas.push(Casilla.new("Cárcel"))
      end
    end
    
    def añade_juez
      if !@tiene_juez
        self.añade_casilla(Casilla.new("Juez"))
        @tiene_juez = true
      end
    end
    
    def casilla(num_casilla)
      casilla = nil
      if num_casilla < @casillas.size
        casilla = @casillas[num_casilla]
      end
      return casilla
    end
    
    def nueva_posicion(actual, tirada)
      posicion = actual
      modulo = actual % @casillas.size
      if (modulo) < tirada
        posicion = tirada - modulo
        por_salida += 1
      else
        posicion += tirada
      end
      
      return posicion
    end
    
    def calcular_tirada(origen, destino)
      tirada = destino - origen
      if (tirada < 0)
        tirada += @casillas.size
      end
      
      return tirada
    end
   
    
  end
  
end

