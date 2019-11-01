#enconding:UTF-8

require_relative 'enum.rb'

module Civitas
    class Casilla
      
      @@carcel = 0
      
      attr_reader :titulo_propiedad
      attr_reader :nombre
    
      def initialize (nombre, titulo, cantidad, num_casilla_carcel, mazo, tipo, sorpresa)
        @nombre = nombre
        @importe = cantidad
        @titulo_propiedad = titulo
        @@carcel = num_casilla_carcel
        @mazo = mazo
        @sorpresa = sorpresa
        @tipo = tipo
      end
      
      def self.new_descanso(nombre)
        new(nombre, nil, 0, @@carcel, nil, TipoCasilla::DESCANSO, nil)
      end
      
      def self.new_calle (titulo)   #calle
        new(titulo.nombre, titulo, 0, @@carcel, nil, TipoCasilla::CALLE, nil)
      end
      
      def self.new_impuesto (cantidad, nombre)    #impuesto
        new(nombre, nil, cantidad, @@carcel, nil, TipoCasilla::IMPUESTO, nil)
      end
      
      def self.new_juez (num_casilla_carcel, nombre)    #juez
        new(nombre, nil, 0, num_casilla_carcel, nil, TipoCasilla::JUEZ, nil)
      end
      
      def self.new_sorpresa (mazo, nombre)          #sorpresa
        new(nombre, nil, 0, @@carcel, mazo, TipoCasilla::SORPRESA, mazo.siguiente)
      end 
      
      private_class_method :new
      
      public
      
      def recibe_jugador (i_actual, todos)
        case @tipo
        when TipoCasilla::CALLE
          recibe_jugador_calle(i_actual, todos)
        when TipoCasilla::IMPUESTO
          recibe_jugador_impuesto(i_actual, todos)
        when TipoCasilla::JUEZ
          recibe_jugador_juez(i_actual, todos)
        when TipoCasilla::SORPRESA
          recibe_jugador_sorpresa(i_actual, todos)
        else
          informe(i_actual, todos)
        end
      end
      
      def jugador_correcto (i_actual, todos)
        correcto = false
        
        if i_actual < todos.size
          correcto = true
        end
        
        return correcto
      end
      
      def to_s
        str = "CASILLA: \n" + "Nombre:    " + @nombre + "\n" +
              "Tipo:    " + @tipo.to_s + "\n"
        
        case @tipo
        when TipoCasilla::CALLE
          str+="Precio:     " + @titulo_propiedad.precio_compra.to_s
        when TipoCasilla::IMPUESTO
          str+="Importe:    " + @importe.to_s + "\n"
        when TipoCasilla::JUEZ
          str+="Casilla carcel:    " + @@carcel.to_s
        end
        
        return str
      end
      
      private
      
      def informe (i_actual, todos)
        evento = ("El jugador " + i_actual.to_s + 
                 " ha caido en la casilla " + @nombre + "\n" +
                 "Informacion de la casilla: \n" + to_s)
        Diario.instance.ocurre_evento(evento)
      end
      
     def recibe_jugador_calle (i_actual, todos)
        if jugador_correcto(i_actual, todos)
          informe(i_actual, todos)
          jugador = todos[i_actual]
          if !@titulo_propiedad.tiene_propietario
            jugador.puede_comprar_casilla
          else
            @titulo_propiedad.tramitar_alquiler(jugador)
          end
        end
     end
      
      def recibe_jugador_impuesto (i_actual, todos)
        if jugador_correcto(i_actual, todos)
          informe(i_actual, todos)
          todos[i_actual].paga_impuesto(@importe)
        end
      end
      
      def recibe_jugador_juez (i_actual, todos)
        if jugador_correcto(i_actual, todos)
          informe(i_actual, todos)
          todos[i_actual].encarcelar(@@carcel)
        end
      end
      
      def recibe_jugador_sorpresa (i_actual, todos)
        if jugador_correcto(i_actual, todos)
          @sorpresa = @mazo.siguiente
          informe(i_actual,todos)
          @sorpresa.aplicar_a_jugador(i_actual, todos)
        end
      end
  end
end
