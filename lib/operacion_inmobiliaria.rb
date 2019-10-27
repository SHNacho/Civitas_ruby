# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'enum.rb'

module Civitas
  class Operacion_inmobiliaria
    def initialize (gest, ip)
      @gestion = gest
      @num_propiedad = ip
    end

    attr_reader :num_propiedad
    attr_reader :gestion
  end
end