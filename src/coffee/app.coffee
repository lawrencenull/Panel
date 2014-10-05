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
        redirectTo: '/map/group'

    $locationProvider.html5Mode(false)

class Words extends Constant
  constructor: ->
    return {
      en:
        ui:
          nlmk: 'NLMK'
          group: 'Group'
          russia: 'Russia'
          europe: 'Europe'
          usa: 'USA'
          info: 'Information'
          history: 'History'
          highlights: 'Highlights'
          products: 'Products'
          map: 'Map'
        products:
          slabs: 'Slab'
          hire_hot: 'Hot-rolled hire'
          hire_cold: 'Cold-rolled hire'
          hire_coated: 'Hire coated'
          hire_class: 'Sections'
          hire_galvanized: 'Galvanized-rolled hire'
          hire_cold_coated: 'Cold-rolled hire coated'
          hire_plate: 'Hot rolled plate'
          hire_electro: 'Cold-rolled hire from electrical steel'
          hire_flat: 'Hire flat'
          hire_class_hardware: 'Hire class & hardware'
          hire_flat: 'Плоский прокат'
          hire_class_hardware: 'Сортовой прокат и метизы'
          hire_hot_coated: 'Горячеоцинкованный прокат'
          hire_polymer: 'Прокат с полимерным покрытием'
          steel_blank: 'Стальная заготовка'
          steel_concetrat: 'Железорудный концетрат'
          raw: 'Сырье': 'Steel blank'
          raw: 'Raw'
          steel_electro: 'Electrical steel'
          blank: 'Blank'
          blank_quadr: 'Заготовка непрерывнолитая квадртная'
          rod: 'Rod'
          fittings: 'Fittings'
          steel: 'Steel'
          hire: 'Hire'
          koks: 'Кокс'
          black_metal: 'Лом черных металлов'
          dolomit: 'Доломит'
          fluse: 'Известняк флюсовый'
          hardware: 'Метизы'
      ru:
        ui:
          nlmk: 'НЛМК'
          group: 'Группа'
          russia: 'Россия'
          europe: 'Европа'
          usa: 'США'
          info: 'Общая информация'
          history: 'История'
          highlights: 'Результаты'
          products: 'Продукция'
          map: 'Карта'
        products:
          slabs: 'Слябы'
          hire_hot: 'Горячекатаный прокат'
          hire_cold: 'Холоднокатаный прокат'
          hire_coated: 'Прокат с покрытием'
          hire_class: 'Сортовой прокат'
          hire_galvanized: 'Оцинкованный прокат'
          hire_cold_coated: 'Холоднокатаный прокат с покрытием'
          hire_plate: 'Толстолистовой прокат'
          hire_electro: 'Холоднокатаный прокат из электротехнической стали'
          hire_flat: 'Плоский прокат'
          hire_class_hardware: 'Сортовой прокат и метизы'
          hire_polymer: 'Прокат с полимерным покрытием'
          hire_hot_coated: 'Горячеоцинкованный прокат'
          steel_blank: 'Стальная заготовка'
          steel_concetrat: 'Железорудный концетрат'
          raw: 'Сырье'
          steel_electro: 'Электротехническая сталь'
          blank: 'Заготовка'
          blank_quadr: 'Заготовка непрерывнолитая квадртная'
          rod: 'Катанка'
          fittings: 'Арматура'
          steel: 'Сталь'
          hire: 'Прокат'
          koks: 'Кокс'
          black_metal: 'Лом черных металлов'
          dolomit: 'Доломит'
          fluse: 'Известняк флюсовый'
          hardware: 'Метизы'
    }

class I18n extends Service
  currentLanguage: 'ru'
  constructor: (@WORDS) ->
  setLanguage: (language)->
    @currentLanguage = language
  get:(group, key)->
    @WORDS?[@currentLanguage][group][key]


class Main extends Controller
  constructor: ($scope, $route, @$routeParams, $location, @i18nService, @popupService) ->
    $scope.$route = $route
    $scope.$location = $location
    $scope.$routeParams = $routeParams

    $scope.controller = 'main'
  getPopup:->
    'templates/'+@$routeParams.division+'/actives/'+@popupName()+'.html'
  _:(group, key)->
    @i18nService.get group, key
  closePopup:->
    @popupService.hide()
  popupName:->
    @popupService.active
  toggleLanguage:->
    @i18nService.setLanguage if @i18nService.currentLanguage is 'en' then 'ru' else 'en'

class Info extends Controller
  constructor: ($scope,$sce) ->

    $scope.volume = 1
    $scope.isCompleted = false
    $scope.API = null

    $scope.onPlayerReady = (API)->
      $scope.API = API

    $scope.onCompleteVideo = ->
      $scope.isCompleted = true

    $scope.onUpdateSize = (width, height) ->
      $scope.config.width = width
      $scope.config.height = height

    $scope.config = {
      autoHide: false,
      autoPlay: true,
      stretch: 'fill',
      sources: [
        {src: $sce.trustAsResourceUrl("http://localhost:4000//video/1.mp4"), type: "video/mp4"}
      ],
      transclude: true,
    }

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
  constructor: ($window)->
    return {
      restrict: 'AE'
      replace: true
      scope:
        total: '@'
        division: '@'
      template: '''
                <div>
                  <div class="slide" ng-repeat="image in images" ng-show="image == currentIndex + 1">
                    <div class="img">
                      <img ng-src="/images/slider/{{division}}/{{image}}.jpg" />
                    </div>
                  </div>
                </div>
                '''

      link: (scope, elem, attrs)->
        scope.images = [1..scope.total]
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

        timer = $window.setInterval ->
          scope.next()
          scope.$apply()
        , 3500

        scope.$on '$destroy', ->
          $window.clearInterval(timer);

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
          width: '600',
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
class Marker extends Directive
  constructor: (@popupService)->
    return {
      restrict: 'AE'
      replace: true
      scope:
        pos: '&'
        type: '@'
        active: '@'
      template: '''
                <div class="marker" style="left:{{pos()[0]}}px;top:{{pos()[1]}}px">
                  <img class="shadow" src="/images/map/shadow.png" />
                  <img class="type" ng-src="/images/map/{{type}}.png" />
                </div>
                '''

      link: (scope, elem, attrs)->
        elem.click ->
          popupService.show(scope.active)
          scope.$apply()
    }

class Pvideo extends Directive
  constructor: (@popupService,$sce)->
    return {
      restrict: 'AE'
      replace: true
      scope:
        auto: '@'
        file: '@'
      template: '''
                <div>
                  <videogular
                    vg-player-ready="onPlayerReady"
                    vg-complete="onCompleteVideo"
                    vg-update-state="onUpdateState"
                    vg-autoplay="config.autoPlay">
                    <vg-video vg-src="config.sources"></vg-video>
                    <vg-overlay-play></vg-overlay-play>
                  </videogular>
                </div>
                '''

      link: (scope, elem, attrs)->
        scope.volume = 1
        scope.isCompleted = false
        scope.API = null

        scope.onPlayerReady = (API)->
          scope.API = API

        scope.onCompleteVideo = ->
          setTimeout(->
            scope.API.play()
          ,1000)


        scope.onUpdateSize = (width, height) ->
          scope.config.width = width
          scope.config.height = height

        scope.config = {
          autoHide: false,
          autoPlay: scope.auto,
          stretch: 'fill',
          sources: [
            {src: $sce.trustAsResourceUrl(scope.file), type: "video/mp4"}
          ],
          transclude: true,
        }
      }
class PScroll extends Directive
  constructor: ()->
    return {
      restrict: 'AE'
      scope:
        reset: '='
      link: (scope, elem, attrs)->
        elem.perfectScrollbar()
        scope.$watch('reset',->
          elem.scrollTop(0);
        )
    }
class Popup extends Service
  constructor: () ->
    @isShow = false
    @active = ''
  isShown:->
    @isShow
  show:(active)->
    @isShow = true
    @active = active
  hide:->
    @isShow = false

class App extends App
  constructor: ->
    return [
      'ngRoute'
      'ngAnimate'
      'ngSanitize'
      "com.2fdevs.videogular"
      "com.2fdevs.videogular.plugins.controls"
      "com.2fdevs.videogular.plugins.overlayplay"
    ]


