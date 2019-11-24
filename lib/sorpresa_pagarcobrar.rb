require_relative 'sorpresa.rb'

module Civitas
  class Sorpresa_pagarcobrar < Sorpresa
    
    def initialize (valor, texto)
      super(texto)
      @valor = valor
    end
    
    def to_s
      str = "'Sorpresa PagarCobrar" + ": " + @texto + "'"
      return str
    end
    
    def aplicar_a_jugador(actual,todos)
      if jugador_correcto(actual, todos)
        informe(actual, todos)
        todos[actual].modificar_saldo(@valor)
      end
    end
    
    public_class_method :new
  end
end