# encoding:utf-8

require_relative 'diario.rb'

module Civitas
  class Jugador
    
    include Comparable
    
    @@casas_max       = 4
    @@casas_por_hotel = 4
    @@hoteles_max     = 4
    @@paso_por_salida = 1000
    @@precio_libertad = 200
    @@saldo_inicial   = 7500
    
    
    attr_reader :casas_por_hotel
    attr_reader :num_casilla_actual
    attr_reader :puede_comprar
    attr_reader :encarcelado
    
    
    def initialize (nombre, otro=nil)
      if otro.nil?
        @nombre             = nombre
        @encarcelado        = false
        @num_casilla_actual = 0
        @puede_comprar      = true
        @saldo              = @@saldo_inicial
        @salvoconducto      = nil
        @propiedades        = []
      else
        @nombre             = otro.nombre
        @encarcelado        = otro.encarcelado
        @num_casilla_actual = otro.num_casilla_actual
        @puede_comprar      = otro.puede_comprar
        @saldo              = otro.saldo
        @salvoconducto      = otro.salvoconducto
        @propiedades        = otro.propiedades
      end
    end

    def self.new_jugador(nombre)
      new(nombre)
    end

    def self.new_copy(otro)
      new(nil, otro)
    end
    
    private_class_method :new

    public
    
    def cancelar_hipoteca (ip)
      result = false
      if @encarcelado
        return result
      end

      if existe_la_propiedad(ip)
          propiedad = @propiedades[ip]
          cantidad = propiedad.get_importe_cancelar_hipoteca
          puedoGastar = puedo_gastar(cantidad)

          if puedoGastar
            result = propiedad.cancelar_hipoteca(self)
            if result
              diario = Diario.instance
              diario.ocurre_evento("El jugador " + @nombre + "Cancela la hipoteca de la propiedad " + ip.to_s)
            end
          end
      end
      return result;
    end
    
    def cantidad_casas_hoteles
      cantidad = 0
      for propiedad in @propiedades
        cantidad += propiedad.cantidad_casas_hoteles
      end
      
      return cantidad
    end
    
    def comprar (titulo)
      result = false
      
      if @encarcelado
        return result
      end
        
      if @puede_comprar
        precio = titulo.precio_compra
        if puedo_gastar(precio)
          result = titulo.comprar(self)
          if result
            @propiedades << titulo
            Diario.instance.ocurre_evento("El jugador " + @nombre + " compra la propiedad " + titulo.to_s)
          end
          @puede_comprar = false
        else
          puts "No tienes suficiente dinero para comprar el título"
        end
      end
      
      return result 
    end
    
    def construir_casa (ip)
      result = false
      puedoEdificarCasa = false
      if @encarcelado
        return result
      else
        existe = existe_la_propiedad(ip)
        if existe
          propiedad = @propiedades[ip]
          puedoEdificarCasa = puedo_edificar_casa(propiedad)
          if puedoEdificarCasa
            result = propiedad.construir_casa(self)
            if result
              Diario.instance.ocurre_evento("El jugador " + @nombre + 
                                            " construye casa en la propiedad " + ip.to_s)
            end
          end
        end
        return result
      end

    end
    
    def construir_hotel (ip)
      result = false
      if @encarcelado
        return result
      end

      if existe_la_propiedad(ip)
        propiedad = @propiedades[ip]
        puedoEdificarHotel = puedo_edificar_hotel(propiedad)

        if puedoEdificarHotel
          result = propiedad.construir_hotel(self)
          propiedad.derruir_casas(@@casas_por_hotel, self)
          Diario.instance.ocurre_evento("El jugador " + @nombre + " construye hotel en la propiedad " + ip.to_s)
        end
      end
      
      return result
    end

    def en_bancarrota
      lo_esta = false
      
      if @saldo < 0
        lo_esta = true
      end
      
      return lo_esta
    end
    
    def encarcelar (num_casilla_carcel)
      if debe_ser_encarcelado
        mover_a_casilla(num_casilla_carcel)
        @encarcelado = true
        Diario.instance.ocurre_evento("Ha sido encarcelado " + @nombre)
      end
      
      return @encarcelado
    end
    
    def hipotecar (ip)
      result = false
      
      if @encarcelado
        return result
      end
      
      if existe_la_propiedad(ip)
        propiedad = @propiedades[ip]
        
        result = propiedad.hipotecar(self)
      end
      
      
      if result
        Diario.instance.ocurre_evento("El jugador "+@nombre+ " hipoteca la propiedad "+ip.to_s)
      end
      
      return result
    end
    
    def modificar_saldo (cantidad)
      @saldo += cantidad
      
      evento = "El saldo del jugador " + @nombre + " ha aumentado en " + cantidad.to_s
      
      Diario.instance.ocurre_evento(evento)
      
      return true
    end
    
    def mover_a_casilla (num_casilla)
      puede_mover = false
      
      if !@encarcelado
        @num_casilla_actual = num_casilla
        @puede_comprar = false
        evento = "El jugador " + @nombre + " se ha movido a la casilla numero "+ 
                  num_casilla.to_s
        Diario.instance.ocurre_evento(evento)
        puede_mover = true
      end
      
      return puede_mover
    end
    
    def obtener_salvoconducto (sorpresa)
      puede = false
      
      if !@encarcelado
        @salvoconducto = sorpresa
        puede = true
      end
      
      return puede
    end
    
    def paga (cantidad)
      cantidad = cantidad * -1;
      return (modificar_saldo(cantidad))
    end
    
    def paga_alquiler (cantidad)
      if !@encarcelado
        return paga(cantidad)
      end
      
      return false;
    end
    
    def paga_impuesto (cantidad)
      if !@encarcelado
        return paga (cantidad)
      end
      
      return false
    end

    
    def pasa_por_salida
      modificar_saldo(@@paso_por_salida)
      Diario.instance.ocurre_evento("El jugador " + @nombre +" ha pasado por salida")
      
      return true
    end

    
    def puede_comprar_casilla
      if @encarcelado
        @puede_comprar = false
      else
        @puede_comprar = true
      end
      
      return @puede_comprar
    end

    
    def recibe (cantidad)
      if !@encarcelado
        return modificar_saldo(cantidad)
      end
      
      return false
    end
    
    def salir_carcel_pagando
       sale = false;
        if @encarcelado && puede_salir_carcel_pagando
            paga(@@precio_libertad)
            sale = true
            @encarcelado = false
            Diario.instance.ocurre_evento("Jugador " + @nombre + " ha salido de la carcel")
        end
        return sale
    end
    
    def salir_carcel_tirando
      sale = false
      if @encarcelado && Dado.instance.salgo_de_la_carcel
            sale = true
            Diario.instance.ocurre_evento("Jugador " + @nombre + " ha salido de la carcel")
            @encarcelado = false
      end
        return sale
    end
    
    def tiene_algo_que_gestionar
      return @propiedades.size > 0
    end

    
    def tiene_salvoconducto
      return !@salvoconducto.nil?
    end

    
    def vender (ip)
      puede_vender = false

        if !@encarcelado 
            if existe_la_propiedad(ip)
                if @propiedades[ip].vender(self)
                    puede_vender = true
                    @propiedades.delete_at(ip)
                    evento = "El jugador " + @nombre + " ha vendido su propiedad " + ip.to_s
                    Diario.instance.ocurre_evento(evento)
                end
            end
        end

        return puede_vender
    end
    
    def <=> (jugador) #1 if self>jugador; 0 if jugador; -1 if self<jugador
      self.saldo <=> jugador.saldo
    end
    
    def to_s
        encarcelado_str = @encarcelado ? "Sí" : "No"
        salvoconducto_str = (@salvoconducto == nil) ? "No" : "Sí"
        propiedades_str = @propiedades.size.to_s
        puede_comprar_str = @puede_comprar ? "Sí" : "No"
        str =        "-------------------------------------------\n" +
                     "JUGADOR \n" +
                     "Tipo de jugador: Normal \n" +
                     "Nombre:          " + @nombre + "\n" + 
                     "Saldo:           " + @saldo.to_s + "\n" +
                     "Casilla actual:  " + @num_casilla_actual.to_s + "\n" +
                     "Encarcelado:     " + encarcelado_str + "\n" +
                     "Salvoconducto:   " + salvoconducto_str + "\n" +
                     "Propiedades:     " + propiedades_str + "\n" +
                     "Puede comprar    " + puede_comprar_str + "\n"
                     "-------------------------------------------\n"

        return str
    end

    def lista_propiedades
      arr = []
      for propiedad in @propiedades
        str = propiedad.nombre
        arr << str
      end

      return arr
    end
    
    private

    attr_reader :casas_max
    attr_reader :hoteles_max
    attr_reader :precio_libertad
    attr_reader :paso_por_salida

    ########################################################################################
    
    def debe_ser_encarcelado
      debe_serlo = false
      
      if !@encarcelado
        if !tiene_salvoconducto
          debe_serlo=true
        else
          debe_serlo = false
          perder_salvoconducto
        end
      end
      
      return debe_serlo
    end
    
    def existe_la_propiedad (ip)
      existe = false
      
      if (ip < @propiedades.size)
        existe = true
      end
      
      return existe
    end
    
    def perder_salvoconducto
      @salvoconducto.usada
      @salvoconducto = nil
    end
    
    def puede_salir_carcel_pagando
      puede = false
      
      if @saldo >= @@precio_libertad
        puede = true
      end
      
      return puede
    end
    
    def puedo_edificar_casa (propiedad)
      puedo = false
      
      if propiedad.num_casas < @@casas_max
        if puedo_gastar(propiedad.precio_edificar)
          puedo = true
        else
          puts "No tienes suficiente dinero"
        end
      else
        puts "Ya has alcanzado el máximo de casas en la propiedad"
      end
      
      return puedo  
    end
    
    def puedo_edificar_hotel (propiedad)
      puedo = false
      
      if propiedad.num_casas >= @@casas_por_hotel
        if propiedad.num_hoteles < @@hoteles_max
          if puedo_gastar(propiedad.precio_edificar)
            puedo = true
          else
            puts "No tienes suficiente dinero para construir un hotel"
          end
        else
          puts "No puedes construir mas hoteles"
        end
      else
        puts "No tienes suficientes casas para construir un hotel"
      end
      
      return puedo  
    end
    
    def puedo_gastar (precio)
      puedo = false
      
      if !@encarcelado && @saldo >= precio
        puedo = true
      end
      
      return puedo
    end

    public
    attr_reader :propiedades
    attr_reader :saldo
    attr_reader :nombre

    end
  end


