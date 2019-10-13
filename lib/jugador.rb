#encoding:utf-8

module Civitas
  class Jugador
    
    include Comparable
    
    @@casas_max = 4
    @@casas_por_hotel = 4
    @@hoteles_max = 4
    @@paso_por_salida  = 1000
    @@precio_libertad = 200
    @@saldo_inicial = 7500
    
    
    attr_reader :casas_por_hotel
    attr_reader :num_casilla_actual
    attr_reader :puede_comprar
    attr_reader :encarcelado
    
    
    def initialize (nombre, otro=nil)
      if otro == nil
        @nombre = nombre
        @encarcelado = false
        @num_casilla_actual = 0
        @puede_comprar = true
        @saldo = @@saldo_inicial
        @salvo_conducto = nil
        @propiedades = []
      else
        @nombre = otro.nombre
        @encarcelado = otro.encarcelado
        @num_casilla_actual = otro.num_casilla_actual
        @puede_comprar = otro.puede_comprar
        @saldo = otro.saldo
        @salvo_conducto = otro.salvo_conducto
        @propiedades = otro.propiedades
      end
    end
    
    public
    
    def cancelar_hipoteca (ip)
      
    end
    
    def cantidad_casas_hoteles
      cantidad = 0
      for propiedad in @propiedades
        cantidad += propiedad.cantidad_casas_hoteles
      end
      
      return cantidad
    end
    
    def comprar (titulo)
      
    end
    
    def construir_casa (ip)
      
    end
    
    def construir_hotel (ip)
      
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
    
    def obtener_salvo_conducto (sorpresa)
      puede = false
      
      if !@encarcelado
        @salvo_conducto = sorpresa
        puede = true
      end
      
      return puede
    end
    
    def paga (cantidad)
      return (modificar_saldo(cantidad * -1))
    end
    
    def paga_alquiler (cantidad)
      if !@encarcelado
        return paga(cantidad);
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
    
    def tiene_salvo_conducto
      return @salvo_conducto != nil
    end
    
    def vender (ip)
      puede_vender = false

        if !@encarcelado 
            if existe_la_propiedad(ip)
                if @propiedades[ip].vender(self)
                    puede_vender = true
                    @propiedades.delete_at(ip)
                    evento = "El jugador " + @nombre 
                                    + " ha vendido su propiedad " 
                                    + ip.to_s
                    Diario.instance.ocurre_evento(evento)
                end
            end
        end

        return puede_vender
    end 
    
    def <=> (jugador) #1 if self>jugador; 0 if jugador; -1 if self<jugador
      self.saldo <=> jugador.saldo
    end
    
    def to_string
        encarcelado_str = @encarcelado ? "Sí" : "No"
        salvoconducto_str = (@salvo_conducto == nil) ? "No" : "Sí"
        propiedades_str = (@propiedades.size).to_s
        puede_comprar_str = @puede_comprar ? "Sí" : "No"
        str =       "JUGADOR \n" +
                     "Nombre:         " + @nombre + "\n" + 
                     "Saldo:          " + @saldo.to_s + "\n" +
                     "Casilla actual: " + @num_casilla_actual.to_s + "\n" +
                     "Encarcelado:    " + encarcelado_str + "\n" +
                     "Salvoconducto:  " + salvoconducto_str + "\n" +
                     "Propiedades:    " + propiedades_str + "\n" +
                     "Puede comprar   " + puede_comprar_str

        return str
    end
    
    private

    attr_reader :casas_max
    attr_reader :hoteles_max
    attr_reader :precio_libertad
    attr_reader :paso_por_salida
    
    def debe_ser_encarcelado
      debe_serlo = false
      
      if !@encarcelado
        if !tiene_salvo_conducto
          debe_serlo=true
        else
          debe_serlo = false
          perder_salvo_conducto
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
    
    def perder_salvo_conducto
      @salvo_conducto.usada
      @salvo_conducto = nil
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
      
      if @propiedades.include? propiedad && 
          propiedad.num_casas < @@casas_max && 
          puedo_gastar(propiedad.precio_edificar)
        
        puedo = true
      end
      
      return puedo  
    end
    
    def puedo_edificar_hotel (propiedad)
      puedo = false
      
      if @propiedades.include? propiedad && 
          propiedad.num_casas < @@casas_max && 
          puedo_gastar(propiedad.precio_edificar*5)
        
        puedo = true
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

    protected
    
    attr_reader :propiedades
    attr_reader :saldo
    
    public
    attr_reader :nombre

  end
end
