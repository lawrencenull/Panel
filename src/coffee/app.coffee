class Admin extends Controller
  constructor: ($scope, someService) ->
    $scope.coolMethod = someService.coolMethod

class Some extends Service
  constructor: ($log) ->
    @coolMethod = ->
      $log.info 'someService.coolMethod called'

class App extends App
  constructor: ->
    return []


