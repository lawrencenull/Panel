class Routes extends Config
  constructor: ($routeProvider,$locationProvider) ->
    $routeProvider
      .when '/info/:division',
        controller: 'infoController'
        controllerAs: 'info'
        templateUrl: (params)->
          "/templates/#{params.division}/info.html"
      .when '/history/:division',
        controller: 'historyController'
        controllerAs: 'history'
        templateUrl:  (params)->
          "/templates/#{params.division}/history.html"
      .when '/products/:division',
        controller: 'productsController'
        controllerAs: 'products'
        templateUrl:  (params)->
          "/templates/#{params.division}/products.html"
      .when '/highlights/:division',
        controller: 'highlightsController'
        controllerAs: 'highlights'
        templateUrl:  (params)->
          "/templates/#{params.division}/highlights.html"
      .when '/map/:division/:factory?',
        controller: 'mapController'
        controllerAs: 'map'
        templateUrl:  (params)->
          "/templates/#{params.division}/map.html"
      .otherwise
        redirectTo: '/info/group'

    $locationProvider.html5Mode(false)

class Main extends Controller
  constructor: ($scope, $route, $routeParams, $location) ->
    $scope.controller = 'main'
    $scope.$route = $route
    $scope.$location = $location
    $scope.$routeParams = $routeParams

class Info extends Controller
  constructor: ($scope) ->
    $scope.$parent.controller = 'info'
class History extends Controller
  constructor: ($scope) ->
    $scope.$parent.controller = 'history'
class Products extends Controller
  constructor: ($scope) ->
    $scope.$parent.controller = 'products'
class Highlights extends Controller
  constructor: ($scope) ->
    $scope.$parent.controller = 'highlights'
class Map extends Controller
  constructor: ($scope) ->
    $scope.$parent.controller = 'map'


class Some extends Service
  constructor: ($log) ->
    @coolMethod = ->
      $log.info 'someService.coolMethod called'

class App extends App
  constructor: ->
    return [
      'ngRoute'
      'ngAnimate'
    ]


