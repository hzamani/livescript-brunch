LiveScript = require 'LiveScript'

# Example
# 
#   capitalize 'test'
#   # => 'Test'
#
capitalize = (string) ->
  (string[0] or '').toUpperCase() + string[1..]

# Example
# 
#   formatClassName 'twitter_users'
#   # => 'TwitterUsers'
#
formatClassName = (filename) ->
  filename.split('_').map(capitalize).join('')

module.exports = class LiveScriptCompiler
  brunchPlugin: yes
  type: 'javascript'
  extension: 'ls'
  generators:
    backbone:
      model: (name, pluralName) ->
        """module.exports = class #{formatClassName name} extends Backbone.Model

"""

      view: (name, pluralName) ->
        """template = require 'views/templates/#{name}'

module.exports = class #{formatClassName name}View extends Backbone.View
  template: template

"""

    chaplin:
      controller: (name, pluralName) ->
        """Controller = require 'controllers/controller'

module.exports = class #{formatClassName pluralName}Controller extends Controller
  historyURL: '#{pluralName}'

"""

      collection: (name, pluralName) ->
        """Collection = require 'models/collection'
#{formatClassName name} = require 'models/#{name}'

module.exports = class #{formatClassName pluralName} extends Collection
  model: #{formatClassName name}

"""

      model: (name, pluralName) ->
        """Model = require 'models/model'

module.exports = class #{formatClassName name} extends Model

"""

      view: (name, pluralName) ->
        """View = require 'views/view'
template = require 'views/templates/#{name}'

module.exports = class #{formatClassName name}View extends View
  template: template

"""

      collectionView: (name, pluralName) ->
        """CollectionView = require 'chaplin/views/collection_view'
#{formatClassName name} = require 'views/#{name}_view'

module.exports = class #{formatClassName pluralName}View extends CollectionView
  getView: (item) ->
    new #{formatClassName name} model: item

"""

  constructor: (@config) ->
    null

  compile: (data, path, callback) ->
    try
      result = LiveScript.compile data
    catch err
      error = err
    finally
      callback error, result