
sysPath     = require 'path'
fs          = require 'fs'
compileHBS  = require './ember-handlebars-compiler'

module.exports = class EmberHandlebarsCompiler
  brunchPlugin: yes
  type: 'template'
  extension: 'hbs'
  precompile: off
  root: null

  constructor: (@config) ->
    if @config.files.templates.precompile is on
      @precompile = on
    if @config.files.templates.root?
      @root = sysPath.normalize(@config.files.templates.root)
      @root += sysPath.sep if @root[@root.length - 1] isnt sysPath.sep
    null

  compile: (data, path, callback) ->
    try
      tmplName = "Ember.TEMPLATES[module.id.replace('#{@root}','')]"
      if @precompile is on
        content = compileHBS data.toString()
        result  = "module.exports = #{tmplName} = Ember.Handlebars.template(#{content});"
      else
        content = JSON.stringify data.toString()
        result  = "module.exports = #{tmplName} = Ember.Handlebars.compile(#{content});"
    catch err
      error = err
    finally
      callback error, result
