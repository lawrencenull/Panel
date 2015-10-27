class Routes extends Config
  constructor: ($routeProvider, $locationProvider) ->
    $routeProvider
    .when '/info/:division/:lang',
      controller: 'infoController'
      controllerAs: 'info'
      templateUrl: (params)->
        "/templates/#{params.division}/info_#{params.lang}.html"
    .when '/history/:division/:lang',
      controller: 'historyController'
      controllerAs: 'history'
      templateUrl: (params)->
        "/templates/#{params.division}/history_#{params.lang}.html"
    .when '/products/:division/:lang',
      controller: 'productsController'
      controllerAs: 'products'
      templateUrl: (params)->
        "/templates/#{params.division}/products_#{params.lang}.html"
    .when '/highlights/:division/:lang',
      controller: 'highlightsController'
      controllerAs: 'highlights'
      templateUrl: (params)->
        "/templates/#{params.division}/highlights_#{params.lang}.html"
    .when '/map/:division/:lang',
      controller: 'mapController'
      controllerAs: 'map'
      templateUrl: (params)->
        "/templates/#{params.division}/map_#{params.lang}.html"
    .when '/market/:division/:lang',
      controller: 'marketController'
      controllerAs: 'market'
      templateUrl: (params)->
        "/templates/#{params.division}/market_#{params.lang}.html"
    .otherwise
        redirectTo: '/info/group/ru'

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
        market: 'Markets'
        ecology: 'Eco'
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
        hire_flat_rolled: 'Flat-rolled products'
        hire_class_hardware: 'Long products and metalware'
        hire_hot_coated: 'Hot-rolled coated steel'
        hire_polymer: 'Pre-painted steel'
        steel_blank: 'Billets'
        steel_concetrat: 'Iron ore conentrate'
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
        market: 'Рынки'
        ecology: 'Эко'
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
  get: (group, key)->
    @WORDS?[@currentLanguage][group][key]


class Main extends Controller
  constructor: ($scope, $route, @$routeParams, $location, @i18nService, @popupService) ->
    $scope.$route = $route
    $scope.$location = $location
    $scope.$routeParams = @$routeParams

    $scope.controller = 'main'

    @pagePath = $scope.$location.path().toString()
    $scope.$on '$routeChangeSuccess',
      =>
        @pagePath = $location.path().toString()

    $scope.$watch '$routeParams.division',
      =>
        @closePopup()

    $scope.$watch =>
      @i18nService.currentLanguage
    , (prev, cur) =>
      controller = if $scope.controller == 'main' or !$scope.controller then 'group' else $scope.controller
      division = $scope.$routeParams.division ? 'map'
      if prev != cur and @i18nService.currentLanguage != $scope.$routeParams.lang
        $location.path("/#{controller}/#{division}/#{@i18nService.currentLanguage}")

  getPopup: ->
    @popupService.getPopupTemplate()
  _: (group, key)->
    @i18nService.get group, key
  popupName:->
    @popupService.url
  closePopup: ->
    @popupService.hide()
  toggleLanguage: ->
    @i18nService.setLanguage if @i18nService.currentLanguage is 'en' then 'ru' else 'en'
  reload: ->
    window.location.reload()

class Info extends Controller
  constructor: ($scope, $sce) ->
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
class Market extends Controller
  constructor: ($scope) ->
    $scope.$parent.controller = 'market'

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
        if scope.currentIndex < scope.images.length - 1
          scope.currentIndex = scope.currentIndex + 1
        else
          scope.currentIndex = 0
      scope.prev = ->
        if scope.currentIndex > 0
          scope.currentIndex = scope.currentIndex - 1
        else
          scope.currentIndex = scope.images.length - 1

      timer = $window.setInterval ->
        scope.next()
        scope.$apply()
      , 3500

      scope.$on '$destroy', ->
        $window.clearInterval(timer);

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
      name: '@'
      angle: '@'
    template: '''
                <div class="marker" style="left:{{pos()[0]}}px;top:{{pos()[1]}}px">
                  <img class="shadow" src="/images/map/shadow.png" />
                  <img class="type" ng-src="/images/map/{{type}}.png" />
                  <div style="
    border: 1px solid white;
    width: {{length}}px;
    top: {{top}}px;
    position: absolute;
    left: {{left}}px;
    transform: rotate({{angle}}deg);
"></div>
<div style="top: {{top_n}}px;
    position: absolute;
    left: {{left_n}}px;
    z-index: 1">
{{name}}
</div>
                </div>
                '''

    link: (scope, elem, attrs)->
      scope.angle = scope.angle ? 0
      scope.length = 30
      scope.left = -scope.length / 2
      scope.top = 0

      scope.top += 46 * Math.sin(scope.angle / 180 * Math.PI)
      scope.left += 46 * Math.cos(scope.angle / 180 * Math.PI)

      scope.top += 30
      scope.left += 32

      scope.top_n = 12
      scope.left_n = 0

      scope.top_n += 96 * Math.sin(scope.angle / 180 * Math.PI)
      scope.left_n += 96 * Math.cos(scope.angle / 180 * Math.PI)
      elem.click ->
        popupService.show(scope.active, true)
        scope.$apply()
    }

class Pvideo extends Directive
  constructor: (popupService, $sce)->
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
                    <vg-overlay-play vg-native-controls="true" style="height: 90%"></vg-overlay-play>
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
          , 1000)

      scope.$watch(->
        popupService.isShow
      , ->
        scope.config.sources = [
          {src: $sce.trustAsResourceUrl(popupService.filedata), type: "video/mp4"}
        ] if popupService.filedata?

        if !popupService.isShow
          scope.API?.stop()
        else if scope.auto
          scope.API?.play()
      )

      scope.$watch('stop', ->
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
        transclude: true
      }
    }

class Nvideo extends Directive
  constructor: (popupService, $sce)->
    return {
    restrict: 'AE'
    replace: true
    scope:
      auto: '&'
      file: '@'
      repeat: '&'
      stop: '='
    template: '''
                <video class="video-js vjs-default-skin vjs-big-play-centered" width="100%" height="100%"/>
              '''
    link: (scope, elem, attrs)->
      auto = scope.auto()
      loop2 = scope.repeat()
      auto = false if auto != true
      loop2 = false if loop2 != true

      videojs(elem[0],
        {"controls": false, "autoplay": auto, "preload": "auto", loop: loop2}).ready(->
        vv = @
        vv.src([
#            { type: "video/mp4", src:  '/video/1.mp4' }
          {type: "video/mp4", src: scope.file}
        ]);
        isPlay = false
        vv.bigPlayButton.show()
        vv.on("pause", ->
          vv.bigPlayButton.show()
          isPlay = false
        )
        vv.on("play", ->
          if  scope.file?
            vv.bigPlayButton.hide()
            vv.pause() if !scope.stop? || !scope.stop == 3
            popupService.show("/templates/popup_videos/popup_video_tmpl", false, 'popup-video', scope.file)
            isPlay = true
        )
        scope.$on '$destroy', ->
          vv.pause()
          setTimeout(->
            vv.dispose()
            elem.remove()
          , 0)

        scope.$watch(->
          popupService.isShow
        , (v1, v2)->
          if v1 != v2
            console.log('pop')
            vv.pause()
        )

        scope.$watch('stop', (v1, v2)->
          if v1 != v2
            console.log('stop')
            vv.pause()
        )

        elem.on('click', ->
          if isPlay
            vv.pause()
          else
            vv.play()
        )
      )

    }

class Navselector extends Directive
  constructor: ($routeParams,i18nService)->
    return {
    restrict: 'E'
    replace: true
    scope:
      controller: '='
    template: '''
            <div class="selector">
                <a class="prev"></a>
                <a class="next"></a>
                <div class="border--top"></div>
                <div class="border--left"></div>
                <div class="border--middle"></div>
                <div class="border--right"></div>
                <div class="border--bottom"></div>
            </div>
'''
    link: (scope, elem, attrs)->
      slideToNavItem = ->
        return if scope.controller is "main"
        links = elem
        .parent()
        .children('a')
        .map((i, a)-> $(a))

        i = 0
        a = links[i]
        pos =
          left: 0
          width: 0

        loop
          if not a.children().hasClass('ng-hide')
#            console.log a.attr('ng-href'), a.width(), scope.controller, a.attr('ng-href').indexOf(scope.controller) isnt -1
            pos.left += pos.width
            pos.width = a.width()
#            console.log pos
            break if a.attr('ng-href').indexOf(scope.controller) isnt -1
          a = links[++i]

#        console.log pos
        elem.css width: pos.width + 6 + "px", left: pos.left - 2 + "px"

      scope.$watch ->
        scope.controller + i18nService.currentLanguage
      , slideToNavItem

      scope.$watch ->
        $routeParams.division
      , ->
        setTimeout slideToNavItem, 100

      setTimeout slideToNavItem, 500
    }

class PScroll extends Directive
  constructor: ()->
    return {
    restrict: 'AE'
    scope:
      reset: '='
      suppressY: '='
    link: (scope, elem, attrs)->
      opt = {
        useBothWheelAxes: true
        minScrollbarLength: 200
      }
      if scope.suppressY
        opt.suppressScrollY = true

      elem.perfectScrollbar(opt)
      scope.$watch('reset', ->
        elem.scrollTop(0);
      )
      scope.$on '$destroy', ->
        elem.perfectScrollbar('destroy')
    }

class Popup extends Service
  constructor: (@$routeParams, @i18nService) ->
    @isActive = false
    @isShow = false
    @url = ''
    @tclass = ''
    @filedata = null
  isShown: ->
    @isShow
  show: (url, isActive = false, tclass = '',  filedata = null)->
    @filedata = filedata
    @isShow = true
    @isActive = isActive
    @url = url
    @tclass = tclass

  hide: ->
    @filedata = null if @filedata?
    @isShow = false

  getPopupTemplate:  ->
      url = if @isActive then 'templates/' + @$routeParams.division + '/actives/' + @url else @url
      url += '_' + @i18nService.currentLanguage + '.html'
      console.log url
      url


class LineChart extends Directive
  constructor: ->
    return {
    replace: true
    scope:
      data: '=lineChart'
      name: '@chartTitle'
    template: '<section class="chart bar-chart"><header>{{name}}</header><section></section></section>'
    link: (scope, el, attr)->
      data =
        labels: []
        series: [[]]
      for [x, y] in scope.data
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
      Chartist.Line(el[0].children[1], data, options)
    }
class BarChart extends Directive
  constructor: ->
    return {
    replace: true
    scope:
      data: '=barChart'
      name: '@chartTitle'
    template: '<section class="chart bar-chart"><header>{{name}}</header><section></section></section>'
    link: (scope, el, attr)->
      data =
        labels: []
        series: [[]]
      for [x, y] in scope.data
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
      Chartist.Bar(el[0].children[1], data, options)
    }

class Sphere extends Directive
  constructor:->
    imgs =
      auto: 'auto2.png'
      build: 'building.png'
      byto: 'bytovaia_tehnica.png'
      ener: 'energooborudovanie.png'
      infr: 'infrastruktura.png'
      mach: 'machine2.png'
      obor: 'oborudovanie.png'
      offs: 'offshore2.png'
      pere: 'pererabotka.png'
      sudo: 'sudostroenie.png'
    return {
      scope:
        sphere: '@'
      template: """
<div><img style="width:80px;margin-right:5px;vertical-align: top;" ng-src='/img/sphere/{{imgs[sf]}}' ng-repeat='sf in sphere.split(",")'/></div>
"""
      link:(scope)->
        scope.imgs = imgs

    }
class App extends App
  constructor: ->
    document.oncontextmenu = document.body.oncontextmenu = -> return false
    return [
      'ngRoute'
      'ngAnimate'
      'ngSanitize'
      "com.2fdevs.videogular"
      "com.2fdevs.videogular.plugins.controls"
      "com.2fdevs.videogular.plugins.overlayplay"
    ]


