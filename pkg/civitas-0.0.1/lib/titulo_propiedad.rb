# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas

  class Titulo_propiedad

    @@factor_intereses_hipoteca = 1.1
    
    private attr_reader :hipoteca_base
    
    attr_reader :propietario
    
    attr_reader :nombre
    
    attr_reader :num_casas
    
    attr_reader :num_hoteles
    
    attr_reader :precio_compra
    
    attr_reader :precio_edificar     
    
    attr_reader :hipotecado

    def initialize (nom, ab, fr, hb, pc, pe)
      @nombre = nom
      @alquiler_base = ab
      @factor_revalorizacion = fr
      @hipoteca_base = hb
      @precio_compra = pc
      @precio_edificar = pe
      @propietario = nil
      @hipotecado = false
      @num_casas = 0
      @num_hoteles = 0
    end

    public

    def actualiza_propietario_por_conversion (jugador)
      
    end

    def cancelar_hipoteca (jugador)
      operacion = false
      if @hipotecado && es_este_el_propietario(jugador)
        jugador.paga(get_importe_cancelar_hipoteca)
        @hipotecado = false
        operacion = true 
      end

      return operacion
    end

    def cantidad_casas_hoteles
      casas_hoteles = @num_casas + @num_hoteles
      return casas_hoteles
    end

    def comprar (jugador)
      comprada = false
      
      if !tiene_propietario
        jugador.paga(@precio_compra)
        @propietario = jugador
        comprada = true
      end
      
      return comprada
    end

    def construir_casa (jugador)
      construida = false
      
      if es_este_el_propietario(jugador)
        @propietario.paga(@precio_edificar)
        @num_casas+=1
        construida = true
      end
      
      return construida
    end

    def construir_hotel (jugador)
      construido = false
      
      if es_este_el_propietario(jugador)
        @propietario.paga(@precio_edificar*5)
        @num_hoteles+=1
        construido = true
      end
      
      return construido
    end

    def derruir_casas (n, jugador)
      
      operacion = false
      
      if es_este_el_propietario(jugador) && @num_casas >= n
        @num_casas-=n
        operacion=true
      end
      
      return operacion
    end

    def get_importe_cancelar_hipoteca 
      importe = @hipoteca_base * @@factor_intereses_hipoteca
      return importe
    end

    def hipotecar (jugador)
      operacion = false

      if !@hipotecado && es_este_el_propietario(jugador)
        cantidad_recibida = (@hipoteca_base*(1+(@num_casas*0.5)+(@num_hoteles*2.5)))
        jugador.recibe(cantidad_recibida)
        @hipotecado = true
        operacion = true
      end

      return operacion
    end

    def tiene_propietario
      tiene = false
      
      if @propietario != nil
        tiene = true
      end
      
      return tiene
    end

    def tramitar_alquiler (jugador)
      if tiene_propietario && !es_este_el_propietario(jugador)
        jugador.paga_alquiler(@alquiler_base)
        @propietario.recibe(@alquiler_base)
      end
    end

    def vender (jugador)
       vendida = false

        if es_este_el_propietario(jugador)
            @num_casas = 0
            @num_hoteles = 0
            jugador.recibe(get_precio_venta)
            @propietario = nil
            vendida = true
        end

        return vendida
    end

    def to_string
        nombre_propietario = "Sin propietario"
        hipotecado_str     = "No"

          if @hipotecado==true
              hipotecado_str = "Si"
          end

          if tiene_propietario
              nombre_propietario = @propietario.nombre
          end


          str = "TituloPropiedad" + "\n" +
                      "-Nombre:                   " + @nombre + "\n" +
                      "-Precio base de alquiler:  " + Float.to_s(@alquiler_base) + "\n" +
                      "-Factor de revalorización: " + Float.to_s(@factor_revalorizacion) + "\n" +
                      "-Hipoteca base:            " + Float.to_s(@hipoteca_base) + "\n" +
                      "-Precio de compra:         " + Float.to_s(@precio_compra) + "\n" +
                      "-Precio de edificar:       " + Float.to_s(@precio_edificar) + "\n" +
                      "-Propietario:              " + nombre_propietario + "\n" +
                      "-Hipotecado:               " + hipotecado_str + "\n" +
                      "-Numero de casas:          " + Integer.to_s(@num_casas) + "\n" +
                      "-Numero de hoteles:        " + Integer.to_s(@num_hoteles) + "\n"

          return str
    end

    private

    def es_este_el_propietario (jugador)
      lo_es = false
      if @propietario == jugador
        lo_es = true
      end
      
      return lo_es
    end

    def get_precio_alquiler
      if @hipotecado || propietario_encarcelado
        alquiler = 0
      else
        alquiler = (@alquiler_base*(1+(@num_casas*0.5)+(@num_hoteles*2.5)))
      end

      return alquiler
    end

    def get_precio_venta
      precio = @precio_compra + @precio_edificar*(@num_casas+5*@num_hoteles)*@factor_revalorizacion
      return precio
    end

    def propietario_encarcelado
      if @propietario.encarcelado
        esta = true
      end
      
      if !@propietario.encarcelado || !tiene_propietario
        esta = false
      end
      
      return esta
    end  
  
  end
end
