sysPath     = require 'path'
compileHBS  = require './ember-handlebars-compiler'

module.exports = class EmberHandlebarsCompiler
  brunchPlugin: yes
  type: 'template'
  extension: 'hbs'
  precompile: off
  root: null
  modulesPrefix: 'module.exports = '
  modulesSuffix: ''
  wrapper: (tmplName, data) ->
    "#{@modulesPrefix}Ember.TEMPLATES['#{tmplName}'] = #{data}#{@modulesSuffix}"

  constructor: (@config) ->
    if @config.files.templates.precompile is on
      @precompile = on
    if @config.files.templates.root?
      @root = sysPath.join 'app', @config.files.templates.root, sysPath.sep
    if @config.modules.wrapper is 'amd'
      @modulesPrefix = "define([], function() { return "
      @modulesSuffix = "});"
      @wrapper = (tmplName, data) ->
        "#{@modulesPrefix}#{data}#{@modulesSuffix}"
    if @config.modules.wrapper is off
      @modulesPrefix = ''
    null

  compile: (data, path, callback) ->
    try
      tmplPath = path.replace @root, ''
      tmplPath = tmplPath.replace /\\/g, '/'
      tmplPath = tmplPath.substr 0, tmplPath.length - sysPath.extname(tmplPath).length
      if @precompile is on
        content = compileHBS data.toString()
        result = "Ember.Handlebars.template(#{content});"
      else
        content = JSON.stringify data.toString()
        result = "Ember.Handlebars.compile(#{content});"
      result = @wrapper(tmplPath, result)
    catch err
      error = err
    finally
      callback error, result
