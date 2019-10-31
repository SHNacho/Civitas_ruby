#encoding:utf-8
require_relative 'enum.rb'
require_relative 'diario.rb'
require_relative 'civitas_juego.rb'
require 'io/console'

module Civitas

  class Vista_textual

    def initialize
      @i_propiedad = nil
      @i_gestion   = nil
      @juegoModel  = nil
    end

    def mostrar_estado(estado)
      puts estado
    end

    
    def pausa
      print "Pulsa una tecla"
      gets
      print "\n"
    end

    def lee_entero(max,msg1,msg2)
      ok = false
      begin
        print msg1
        cadena = gets.chomp
        begin
          if (cadena =~ /\A\d+\Z/)
            numero = cadena.to_i
            ok = true
          else
            raise IOError
          end
        rescue IOError
          puts msg2
        end
        if (ok)
          if (numero >= max)
            ok = false
          end
        end
      end while (!ok)

      return numero
    end



    def menu(titulo,lista)
      tab = "  "
      puts titulo
      index = 0
      lista.each { |l|
        puts tab+index.to_s+"-"+l
        index += 1
      }

      opcion = lee_entero(lista.length,
                          "\n"+tab+"Elige una opción: ",
                          tab+"Valor erróneo")
      return opcion
    end

    def salir_carcel
  
      opcion = menu("Elige la forma para intentar salir de la carcel",
                    lista = ["Pagando", "Tirando el dado"])
      return (Salidas_carcel::lista_salidas_carcel[opcion])
    end

    
    def comprar
      opcion = menu("¿Quieres comprar esta calle?",
                    lista = ["SI", "NO"])
      
      return (Respuestas::lista_respuestas[opcion])
    end

    def gestionar
      @i_gestion = menu("¿Qué gestión inmoviliaria quieres hacer?",
                    lista = ["VENDER", "HIPOTECAR", "CANCELAR HIPOTECA",
                          "CONSTRUIR CASA", "CONSTRUIR HOTEL", "TERMINAR"] )
      @i_propiedad = menu("¿Sobre qué propiedad quieres hacer la gestión?",
                      @juegoModel.get_jugador_actual.list_propiedades_str)
    end

    def getGestion
      return @i_gestion
    end

    def getPropiedad
      return @i_propiedad
    end

    def mostrarSiguienteOperacion(operacion)
      puts "Siguiente operación: " + operacion.to_s
    end

    def mostrarEventos
      diario = Diario.instance
      while diario.eventos_pendientes
        puts diario.leer_evento
      end
    end

    def setCivitasJuego(civitas)
         @juegoModel=civitas
         self.actualizarVista
    end

    def actualizarVista
      puts @juegoModel.info_jugador_texto
      puts @juegoModel.get_casilla_actual.to_s
    end

    
  end

end