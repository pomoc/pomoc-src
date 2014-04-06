
  var app = angular.module('app', [
      'ngRoute',
      'app.controllers.home',
      'app.controllers.agent',
      'app.controllers.setup',
      'app.controllers.nav',
      'app.services.user'
    ]);

  app.config(['$routeProvider',function($routeProvider){

    $routeProvider
      .when('/agents', {
        templateUrl: 'js/app/views/agent.html',
        controller: 'agentController'
      })
      .when('/setup', {
        templateUrl: 'js/app/views/setup.html',
        controller: 'setupController'
      })
      .when('/', {
        templateUrl: 'js/app/views/home.html',
        controller: 'homeController'
      })
  }]);


  app.run(function($rootScope, $location){

    if ($rootScope.userId == undefined) {
      $location.path('/');
    }

  });
