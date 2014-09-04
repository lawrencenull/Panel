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
    $scope.images = [
      src:'media-block--img-1.jpg'
      title:'Визит Дмитрия Медведева на НЛМК'
    ,
      src:'media-block--img-2.jpg'
      title:'Созданы из стали (посвящается ветеранам НЛМК)'
    ]

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


class Slider extends Directive
  constructor: ($timeout)->
    return {
      restrict: 'AE'
      replace: true
      scope:
        images: '='
      template: '''
                <div class="slide" ng-repeat="image in images" ng-show="image.visible">
                  <div class="img"><img src="/img/{{image.src}}" /></div>
                  <div class="desc">{{image.title}}</div>
                </div>
                '''

      link: (scope, elem, attrs)->
        scope.currentIndex = 0
        scope.next = ->
          if scope.currentIndex < scope.images.length-1
            scope.currentIndex=scope.currentIndex+1
          else
            scope.currentIndex = 0
        scope.prev = ->
          if scope.currentIndex > 0
            scope.currentIndex = scope.currentIndex-1
          else
            scope.currentIndex = scope.images.length-1

        scope.$watch 'currentIndex', ->
          image.visible = false for image in scope.images
          scope.images[scope.currentIndex].visible = true

        timer = null
        sliderFunc = ->
          $timeout ->
            scope.next()
            timer = sliderFunc()
          , 2500

        timer = sliderFunc()

        scope.$on '$destroy', ->
          $timeout.cancel(timer)
    }


class LineChart extends Directive
  constructor: ->
    return {
      replace: true
      scope:
        data:'=lineChart'
        name:'@chartTitle'
      template: '<section class="chart bar-chart"><header>{{name}}</header><section></section></section>'
      link:(scope,el,attr)->
        data =
          labels: []
          series: [[]]
        for [x,y] in scope.data
          data.labels.push x
          data.series[0].push y

        options = {
          axisX: {
            offset: 10,
            showLabel: true,
            showGrid: false,
          },
          axisY: {
            offset: 10,
            showLabel: true,
            showGrid: false,
            labelAlign: 'left',
          },
          width: '400',
          height: '300',
          showLine: true,
          showPoint: true,
          lineSmooth: true,
        }
        Chartist.Line(el[0].children[1], data,options)
    }
class BarChart extends Directive
  constructor: ->
    return {
      replace: true
      scope:
        data:'=barChart'
        name:'@chartTitle'
      template: '<section class="chart bar-chart"><header>{{name}}</header><section></section></section>'
      link:(scope,el,attr)->
        data =
          labels: []
          series: [[]]
        for [x,y] in scope.data
          data.labels.push x
          data.series[0].push y

        options = {
          axisX: {
            offset: 10,
            showLabel: true,
            showGrid: false,
          },
          axisY: {
            offset: 10,
            showLabel: true,
            showGrid: false,
            labelAlign: 'left',
          },
          width: '400',
          height: '300',
          showLine: false,
          showPoint: false,
          lineSmooth: false,
        }
        Chartist.Bar(el[0].children[1], data,options)
    }

class App extends App
  constructor: ->
    return [
      'ngRoute'
      'ngAnimate'
    ]


