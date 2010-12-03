# -*- encoding: utf-8 -*-
require "attrtastic/semantic_attributes_helper"
require "attrtastic/semantic_attributes_builder"
##
# Attrtastic, in its assumption, should be similar to formtastic and
# ease displaying AR informations, help create scaffolded show and index
# pages.
#
# @author Boruta Mirosław

require File.join(File.dirname(__FILE__), *%w[attrtastic railtie]) if defined?(::Rails::Railtie)

module Attrtastic
end

