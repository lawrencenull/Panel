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
          steel_blank: 'Стальная заготовка'
          raw: 'Сырье': 'Steel blank'
          raw: 'Raw'
          steel_electro: 'Electrical steel'
          blank: 'Blank'
          rod: 'Rod'
          fittings: 'Fittings'
          steel: 'Steel'
          hire: 'Hire'
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
          steel_blank: 'Стальная заготовка'
          raw: 'Сырье'
          steel_electro: 'Электротехническая сталь'
          blank: 'Заготовка'
          rod: 'Катанка'
          fittings: 'Арматура'
          steel: 'Сталь'
          hire: 'Прокат'
    }

class I18n extends Service
  currentLanguage: 'ru'
  constructor: (@WORDS) ->
  setLanguage: (language)->
    @currentLanguage = language
  get:(group, key)->
    @WORDS?[@currentLanguage][group][key]


class Main extends Controller
  constructor: ($scope, $route, $routeParams, $location, @i18nService, @popupService) ->
    $scope.$route = $route
    $scope.$location = $location
    $scope.$routeParams = $routeParams

    $scope.controller = 'main'

  _:(group, key)->
    @i18nService.get group, key
  closePopup:->
    @popupService.hide()
  toggleLanguage:->
    @i18nService.setLanguage if @i18nService.currentLanguage is 'en' then 'ru' else 'en'

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
  constructor: ($window)->
    return {
      restrict: 'AE'
      replace: true
      scope:
        images: '='
      template: '''
                <div class="slide" ng-repeat="image in images" ng-show="image.visible">
                  <div class="img"><img ng-src="/img/{{image.src}}" /></div>
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

        timer = $window.setInterval ->
          scope.next()
        , 2500

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
      template: '''
                <div class="marker" style="left:{{pos()[0]}}px;top:{{pos()[1]}}px">
                  <img class="shadow" src="/images/map/shadow.png" />
                  <img class="type" ng-src="/images/map/{{type}}.png" />
                </div>
                '''

      link: (scope, elem, attrs)->
        elem.click ->
          popupService.show()
          scope.$apply()
    }

class Pvideo extends Directive
  constructor: (@popupService,sce)->
    return {
      restrict: 'AE'
      replace: true
      scope:
        file: '@'
      template: '''
                <div>
                  <videogular
                    vg-player-ready="onPlayerReady"
                    vg-complete="onCompleteVideo"
                    vg-update-time="onUpdateTime"
                    vg-update-volume="onUpdateVolume"
                    vg-update-state="onUpdateState"
                    vg-theme="config.theme.url"
                    vg-autoplay="config.autoPlay">
                  <vg-video vg-src="config.sources"></vg-video>
                  <vg-controls vg-autohide="config.autoHide" vg-autohide-time="config.autoHideTime">
                  <vg-play-pause-button></vg-play-pause-button>
                  <vg-timedisplay>{{ API.currentTime | date:'mm:ss' }}</vg-timedisplay>
                  <vg-scrubBar>
                  <vg-scrubbarcurrenttime></vg-scrubbarcurrenttime>
                  </vg-scrubBar>
                  <vg-timedisplay>{{ API.timeLeft | date:'mm:ss' }}</vg-timedisplay>
                  <vg-volume>
                  <vg-mutebutton></vg-mutebutton>
                  <vg-volumebar></vg-volumebar>
                  </vg-volume>
                  <vg-fullscreenButton></vg-fullscreenButton>
                  </vg-controls>
                  </videogular>
                </div>
                '''

      link: (scope, elem, attrs)->
        scope.currentTime = 0
        scope.totalTime = 0
        scope.state = null
        scope.volume = 1
        scope.isCompleted = false
        scope.API = null

        scope.onPlayerReady = (API)->
          scope.API = API

        scope.onCompleteVideo = ->
          scope.isCompleted = true

        scope.onUpdateState = (state) ->
          scope.state = state

        scope.onUpdateTime = (currentTime, totalTime)->
          scope.currentTime = currentTime
          scope.totalTime = totalTime

        scope.onUpdateVolume = (newVol)->
          scope.volume = newVol

        scope.onUpdateSize = (width, height) ->
          scope.config.width = width
          scope.config.height = height

        scope.config = {
          autoHide: false,
          autoPlay: true,
          stretch: 'fill',
          sources: [
            {src: $sce.trustAsResourceUrl("http://localhost:4000/video/1.mp4"), type: "video/mp4"}
          ],
          transclude: true,
          theme: {
#            url: "/css/videoangular.css"
          },
          plugins: {
            poster: {
              url: "/img/videogular.png"
            }
          }
        }
    }
class Popup extends Service
  constructor: () ->
    @isShow= false
  isShown:->
    @isShow
  show:->
    @isShow = true
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
      "com.2fdevs.videogular.plugins.poster"
    ]


