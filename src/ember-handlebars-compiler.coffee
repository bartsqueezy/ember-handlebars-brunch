# https://gist.github.com/2013669

module.exports = (->

  fs      = require 'fs'
  vm      = require 'vm'
  sysPath = require 'path'

  compilerPath     = sysPath.join __dirname, '..', 'vendor', 'ember-template-compiler.js'
  compilerjs    = fs.readFileSync compilerPath, 'utf8'

  # dummy DOM element
  element =
    firstChild: -> element
    innerHTML: -> element

  sandbox =
    # DOM
    document:
      createRange: false
      createElement: -> element

    # Console
    console: console

    # handlebars template to compile
    template: null

    # compiled handlebars template
    templatejs: null

    # container for exports, needed to support commonJS modules
    exports:
      precompile: null

  # window
  sandbox.window = sandbox

  # create a context for the vm using the sandbox data
  context = vm.createContext sandbox

  # load ember-template-compiler in the vm to compile templates
  vm.runInContext compilerjs, context, 'compiler.js'

  return (templateData)->

    context.template = templateData

    # compile the handlebars template inside the vm context
    vm.runInContext 'templatejs = exports.precompile(template).toString();', context

    context.templatejs;
)()
