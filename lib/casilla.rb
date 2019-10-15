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
        new(nombre, nil, nil, @@carcel, nil, TipoCasilla::DESCANSO, nil)
      end
      
      def self.new_calle (titulo)   #calle
        new(titulo.nombre, titulo, nil, @@carcel, nil, TipoCasilla::CALLE, nil)
      end
      
      def self.new_impuesto (cantidad, nombre)    #impuesto
        new(nombre, nil, cantidad, @@carcel, nil, TipoCasilla::IMPUESTO, nil)
      end
      
      def self.new_juez (num_casilla_carcel, nombre)    #juez
        new(nombre, nil, nil, num_casilla_carcel, nil, TipoCasilla::JUEZ, nil)
      end
      
      def self.new_sorpresa (mazo, nombre)          #sorpresa
        new(nombre, nil, nil, @@carcel, mazo, TipoCasilla::SORPRESA, mazo.siguiente)
      end 
      
      private_class_method :new
      
      public
      
      # def recibe_jugador (i_actual, todos)
        
      # end
      
      def jugador_correcto (i_actual, todos)
        correcto = false
        
        if i_actual < todos.size
          correcto = true
        end
        
        return correcto
      end
      
      def to_string
        str = "CASILLA: \n" + "Nombre:    " + @nombre + "\n" +
              "Tipo:    " + @tipo.to_s + "\n"
        
        case @tipo
          when TipoCasilla::IMPUESTO
            str+="Importe:    " + @importe.to_s + "\n"
          when TipoCasilla::JUEZ
            str+="Casilla carcel:    " + @@carcel.to_s
        end
        
        return str
      end
      
      private
      
      def informe (i_actual, todos)
        evento = (#"El jugador " + todos[i_actual].nombre + 
                 " ha caido en la casilla " + @nombre + "\n" +
                 " Informacion de la casilla: " + to_string)
        Diario.instance.ocurre_evento(evento)
      end
      
      # def recibe_jugador_calle (i_actual, todos)
        
      # end
      
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
      
      # def recibe_jugador_sorpresa (i_actual, todos)
        
      # end

      public
      def test(jugadores)
        informe(1, jugadores)
        recibe_jugador_juez(1, jugadores)
      end
  end
end
