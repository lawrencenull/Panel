class Routes extends Config
  constructor: ($routeProvider,$locationProvider) ->
    $routeProvider
      .when '/info/:division/:lang',
        controller: 'infoController'
        controllerAs: 'info'
        templateUrl: (params)->
          "/templates/#{params.division}/info_#{params.lang}.html"
      .when '/history/:division/:lang',
        controller: 'historyController'
        controllerAs: 'history'
        templateUrl:  (params)->
          "/templates/#{params.division}/history_#{params.lang}.html"
      .when '/products/:division/:lang',
        controller: 'productsController'
        controllerAs: 'products'
        templateUrl:  (params)->
          "/templates/#{params.division}/products_#{params.lang}.html"
      .when '/highlights/:division/:lang',
        controller: 'highlightsController'
        controllerAs: 'highlights'
        templateUrl:  (params)->
          "/templates/#{params.division}/highlights_#{params.lang}.html"
      .when '/map/:division/:lang',
        controller: 'mapController'
        controllerAs: 'map'
        templateUrl:  (params)->
          "/templates/#{params.division}/map_#{params.lang}.html"
      .otherwise
        redirectTo: '/map/group/ru'

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
          slabs: 'Slabs'
          hire_hot: 'Hot-rolled flat steel'
          hire_cold: 'Cold-rolled flat steel'
          hire_coated: 'Coated steel'
          hire_class: 'Long products'
          hire_galvanized: 'Galvanized steel'
          hire_cold_coated: 'Gold-rolled galvanized steel'
          hire_plate: 'Thick plate'
          hire_electro: 'Cold-rolled electrical steel'
          hot_dip: 'Hot-dip galvanized steel'
          hire_flat: 'Hire flat'
          hire_class_hardware: 'Hire class & hardware'
          hire_flat: 'Flat-rolled products'
          hire_class_hardware: 'Long products and metalware'
          hire_hot_coated: 'Горячеоцинкованный прокат'
          hire_polymer: 'Pre-painted steel'
          steel_blank: 'Billets'
          steel_concetrat: 'Iron ore conentrate'
          raw: 'Сырье': 'Steel blank'
          raw: 'Raw materials'
          steel_electro: 'Electrical steel'
          blank: 'Blank'
          blank_quadr: 'Continuously cast square billets'
          rod: 'Wire rod'
          fittings: 'Rebar'
          steel: 'Steel'
          hire: 'Hire'
          koks: 'Coke'
          black_metal: 'Ferrous scrap metal '
          dolomit: 'Dolomit'
          fluse: 'Fluxing limestone'
          hardware: 'Metalware'
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

    $scope.$watch '$routeParams.division',
      =>
        @closePopup()
    $scope.$watch =>
      @i18nService.currentLanguage
    ,(prev,cur) =>
      controller = if $scope.controller == 'main' or !$scope.controller then 'group' else $scope.controller
      division = $scope.$routeParams.division ? 'map'
      if prev != cur and @i18nService.currentLanguage != $scope.$routeParams.lang
        $location.path("/#{controller}/#{division}/#{@i18nService.currentLanguage}")

  getPopup:->
    'templates/'+@$routeParams.division+'/actives/'+@popupName()+'_'+@i18nService.currentLanguage+'.html'
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
  constructor: (popupService,$sce)->
    return {
      restrict: 'AE'
      replace: true
      scope:
        auto: '&'
        file: '@'
        repeat: '&'
        stop: '='
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
          if scope.repeat()
            setTimeout(->
              scope.API.play()
            ,1000)

        scope.$watch(->
          popupService.isShow
        ,->
          scope.API?.stop()
        )

        scope.$watch('stop',->
          scope.API?.stop()
        )

        scope.onUpdateSize = (width, height) ->
          scope.config.width = width
          scope.config.height = height

        scope.config = {
          autoPlay: scope.auto(),
          stretch: 'fill',
          sources: [
            {src: $sce.trustAsResourceUrl(scope.file), type: "video/mp4"}
          ],
          transclude: true,
        }
      }
class Nvideo extends Directive
  constructor: (popupService,$sce)->
    return {
      restrict: 'AE'
      replace: true
      scope:
        auto: '&'
        file: '@'
        repeat: '&'
        stop: '='
      template: '''
                <div>
                  <div class="video-wrapper">
                    <div class="video-container">
                      <video
                        class="video-js vjs-default-skin vjs-big-play-centered" width="100%" height="100%">
                      </video>
                    </div>
                  </div>
                </div>
                '''

      link: (scope, elem, attrs)->
        auto = scope.auto()
        loop2 = scope.repeat()
        if auto != true
          auto=false
        if loop2 != true
          loop2=false

        videojs(elem.children().children().children()[0], { "controls": false, "autoplay": auto, "preload": "auto", loop: loop2}).ready(->
          vv=@
          vv.src([
            { type: "video/mp4", src:  '/video/1.mp4' }
#            { type: "video/mp4", src:  scope.file }
          ]);
          isPlay = false
          vv.bigPlayButton.show()
          vv.on("pause", ->
            vv.bigPlayButton.show()
            isPlay = false
          )
          vv.on("play", ->
            vv.bigPlayButton.hide()
            isPlay=true
          )
          scope.$on '$destroy', ->
            vv.dispose()

          elem.on('click',->
            if isPlay
              vv.pause()
            else
              vv.play()
          )
        )

    }

class PScroll extends Directive
  constructor: ()->
    return {
      restrict: 'AE'
      scope:
        reset: '='
        suppressY: '='
      link: (scope, elem, attrs)->
        opt={
          useBothWheelAxes: true
          minScrollbarLength: 200
        }
        if scope.suppressY
          opt.suppressScrollY = true

        elem.perfectScrollbar(opt)
        scope.$watch('reset',->
          elem.scrollTop(0);
        )
        scope.$on '$destroy', ->
          elem.perfectScrollbar('destroy')
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
#    document.oncontextmenu = document.body.oncontextmenu = -> return false
    return [
      'ngRoute'
      'ngAnimate'
      'ngSanitize'
      "com.2fdevs.videogular"
      "com.2fdevs.videogular.plugins.controls"
      "com.2fdevs.videogular.plugins.overlayplay"
    ]


