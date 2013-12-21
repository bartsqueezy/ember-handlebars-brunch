var fs = require('fs'),
    path = require('path');

describe('Plugin', function() {
  var plugin;

  beforeEach(function() {
    plugin = new Plugin({files:{templates:{precompile:true}}, modules:{wrapper:false}});
  });

it('should be an object', function() {
    expect(plugin).to.be.ok();
  });

  it('should has #compile method', function() {
    expect(plugin.compile).to.be.a(Function);
  });

  it('should compile and produce valid result', function(done) {
    var content = '<strong>{{outlet}}</strong>';

    plugin.compile(content, 'foo.handlebars', function(error, data) {
      expect(error).not.to.be.ok();
      expect(data).to.contain('outlet');
      expect(data).to.contain("Ember.TEMPLATES['foo']");
      done();
    });
  });
});
