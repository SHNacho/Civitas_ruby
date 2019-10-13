# encoding:utf-8

require_relative 'casilla.rb'

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
      @casillas[0] = Casilla.new_descanso("Salida")
      @por_salida = 0
      @tiene_juez = false
    end
        
    def correcto(num_casilla = 0)      
      return ((@casillas.size > @num_casilla_carcel) && @tiene_juez) && (num_casilla < @casillas.size)
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
        @casillas.push(Casilla.new_descanso("Cárcel"))
      end
      @casillas.push(casilla)
      if @casillas.size == @num_casilla_carcel
        @casillas.push(Casilla.new_descanso("Cárcel"))
      end
    end
    
    def añade_juez
      if !@tiene_juez
        self.añade_casilla(Casilla.new_juez(@num_casilla_carcel ,"Juez"))
        @tiene_juez = true
      end
    end
    
    def casilla(num_casilla)
      casilla = nil
      if correcto(num_casilla)
        casilla = @casillas[num_casilla]
      end
      return casilla
    end
    
    def nueva_posicion(actual, tirada)
      posicion = actual + tirada
      ultima_casilla = @casillas.size
      if posicion > ultima_casilla
        posicion = posicion % ultima_casilla
        @por_salida += 1
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
   
    private :correcto
  end
  
end

