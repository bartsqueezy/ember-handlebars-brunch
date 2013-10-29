sysPath     = require 'path'
compileHBS  = require './ember-handlebars-compiler'

module.exports = class EmberHandlebarsCompiler
  brunchPlugin: yes
  type: 'template'
  extension: 'hbs'
  precompile: off
  root: null
  modulesPrefix: 'module.exports = '

  constructor: (@config) ->
    if @config.files.templates.precompile is on
      @precompile = on
    if @config.files.templates.root?
      @root = sysPath.join 'app', @config.files.templates.root, sysPath.sep
    if @config.modules.wrapper is off
      @modulesPrefix = ''
    if @config.files.templates.defaultExtension?
      @extension = @config.files.templates.defaultExtension
    null

  compile: (data, path, callback) ->
    try
      tmplPath = path.replace @root, ''
      tmplPath = tmplPath.replace /\\/g, '/'
      tmplPath = tmplPath.substr 0, tmplPath.length - sysPath.extname(tmplPath).length
      tmplName = "Ember.TEMPLATES['#{tmplPath}']"
      if @precompile is on
        content = compileHBS data.toString()
        result = "#{@modulesPrefix}#{tmplName} = Ember.Handlebars.template(#{content});"
      else
        content = JSON.stringify data.toString()
        result = "#{@modulesPrefix}#{tmplName} = Ember.Handlebars.compile(#{content});"
    catch err
      error = err
    finally
      callback error, result
