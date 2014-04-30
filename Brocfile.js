/* global require, module */

var EmberApp = require('ember-cli/lib/broccoli/ember-app');
var push = Array.prototype.push;

var app = new EmberApp({
  name: require('./package.json').name,

  legacyFilesToAppend: [
    'jquery.js',
    'handlebars.js',
    'ember.js',
    'ic-ajax/dist/named-amd/main.js',
    'ember-data.js',
    'app-shims.js',
    'ember-resolver.js',
    'ember-load-initializers.js',
    'moment.js',
    'pikaday.js'
  ],

  // AKA whitelisted modules
  ignoredModules: [
    'ember',
    'ember/resolver',
    'ember/load-initializers',
    'ic-ajax'
  ],

  // hack we can hopefully remove as the addon system improves
  importWhitelist: {
    'ember': ['default'],
    'ember/resolver': ['default'],
    'ember/load-initializers': ['default'],
    'ember-qunit': [
      'globalize',
      'moduleFor',
      'moduleForComponent',
      'moduleForModel',
      'test',
      'setResolver'
    ],
    'qunit': ['default']
  },

  // hack
  getEnvJSON: require('./config/environment')
});

if (app.env !== 'production') {
  push.apply(app.ignoredModules, [
    'qunit',
    'ember-qunit'
  ]);

  push.apply(app.legacyFilesToAppend, [
    'qunit/qunit/qunit.js',
    'test-shims.js',
    'ember-qunit/dist/named-amd/main.js'
  ]);
}

// Add stuff that failed to be added
//
var pickFiles = require('broccoli-static-compiler');
var mergeTrees  = require('broccoli-merge-trees');
var pikaday = pickFiles('vendor', {
  srcDir: '/pikaday/css',
  files: [
    'pikaday.css'
  ],
  destDir: '/assets/'
});

var emberApp = app.toTree();

module.exports = mergeTrees([emberApp, pikaday], {
  overwrite: true
});

