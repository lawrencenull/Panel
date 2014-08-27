class Routes extends Config
  constructor: ($routeProvider,$locationProvider) ->
    $routeProvider
      .when '/info/:division',
        controller: 'infoController'
        templateUrl: '/templates/info.html'
      .when '/history/:division',
        controller: 'historyController'
        templateUrl: '/templates/history.html'
      .when '/products/:division',
        controller: 'productsController'
        templateUrl: '/templates/products.html'
      .when '/highlights/:division',
        controller: 'highlightsController'
        templateUrl: '/templates/highlights.html'
      .when '/map/:division/:factory?',
        controller: 'mapController'
        templateUrl: '/templates/map.html'
      .otherwise
        redirectTo: '/info/group'

    $locationProvider.html5Mode(false)

class Main extends Controller
  constructor: ($scope, $route, $routeParams, $location) ->
    $scope.$route = $route
    $scope.$location = $location
    $scope.$routeParams = $routeParams

class Info extends Controller
  constructor: ($scope) ->
class History extends Controller
  constructor: ($scope) ->
class Products extends Controller
  constructor: ($scope) ->
class Highlights extends Controller
  constructor: ($scope) ->
class Map extends Controller
  constructor: ($scope) ->


class Some extends Service
  constructor: ($log) ->
    @coolMethod = ->
      $log.info 'someService.coolMethod called'

class App extends App
  constructor: ->
    return [
      'ngRoute'
    ]


