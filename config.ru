require './lib/rcd'

RCD::App.set :root, ::File.dirname(__FILE__)

run RCD::App
