# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "irealb/parser/version"

Gem::Specification.new do |s|
  s.name        = "irealb_parser"
  s.version     = IRealB::Parser::VERSION
  s.author      = "Ben Hughes"
  s.email       = "ben@railsgarden.com"
  s.homepage    = "http://github.com/rubiety/irealb_parser"
  s.summary     = "Converts iRealB chords to the chords-json format."
  s.description = "Converts iRealB chords to the chords-json format."
  
  s.executables = ["irealb_parser"]
  s.files        = Dir["{lib,spec}/**/*", "[A-Z]*", "init.rb"]
  s.require_path = "lib"
  
  s.rubyforge_project = s.name
  s.required_rubygems_version = ">= 1.3.4"
  
  s.add_dependency("thor", ["~> 0.13"])
  s.add_dependency("activesupport", ["~> 3.0"])
  s.add_dependency("i18n", ["~> 0.6.0"])
  s.add_development_dependency("rspec", ["~> 2.0"])
  s.add_development_dependency("rake")
end
