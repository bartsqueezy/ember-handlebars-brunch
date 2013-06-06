## Ember Handlebars for Brunch

This [Brunch](http://brunch.io/) plugin adds support for pre-compiling [Ember Handlebars](http://emberjs.com/) templates prior to runtime, utilizing the latest and greatest EmberJS build (1.0.0-RC.5).

It is included by default in the [Ember Brunch](https://github.com/icholy/ember-brunch) skeleton.  However if you would like to import it into your own custom Brunch project, the instructions below will get you up and running.

## Installation and Usage

Add `"ember-handlebars-brunch": "git+ssh://git@github.com:bartsqueezy/ember-handlebars-brunch.git"` to `package.json` of your Brunch application.

Within `config.coffee`, set `precompile: true` within the templates compiler if you want to enable pre-compiling.

```coffeescript
templates:
    precompile: true  # default is false
    root: 'templates/'  # default is null
    defaultExtension: 'hbs'
    joinTo: 'javascripts/app.js' : /^app/
```

A few reminders about the configuration object mentioned above:

1. Make sure the extension of each template file matches the `defaultExtension` property
2. The value you provide for `root` should represent a directory located under your `app` directory.  If you do not provide a value for this property, ember-handlebars-brunch will, by default, set the template name to the path of your file, starting from `app`.  For instance, without defining the `root` property, a template located at `app/templates/index.hbs` will be registered with Ember like `Ember.TEMPLATES['app/templates/index']`.

If using the exact example configuration above, your `views` and `templates` directories should look similar to this:

```
└─┬ app
  ├─┬ templates
  │ ├─┬ index
  │ │ └── login.hbs
  │ ├── application.hbs
  │ └── index.hbs
  └─┬ views
    ├─┬ index
    │ └── login.js
    ├── application.js
    └── index.js
```

Based on the example above, you can define your views like so:

```javascript
// app/views/application.js
App.ApplicationView = Ember.View.extend({
    templateName: 'application'
});

// app/views/index.js
App.IndexView = Ember.View.extend({
    templateName: 'index'
});

// app/views/index/login.js
App.IndexLoginView = Ember.View.extend({
    templateName: 'index/login'
});
```

The precompiled templates are injected into the `Ember.TEMPLATES` namespace.  You can access them like so:

```javascript
var anotherTemplate = Ember.TEMPLATES['index/login'];
```

If you wish to `require` the template manually instead of using them directly within a view class, you have to use the full path to the file, starting from the templates directory;

```javascript
require('templates/index/login');
```