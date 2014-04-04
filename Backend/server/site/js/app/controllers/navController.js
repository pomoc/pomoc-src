var nav_controller = angular.module('app.controllers.nav', [
  'app.services.user'
  ]);

nav_controller.controller('navController',
  function($scope,$location, $routeParams, $rootScope, userService) {


  	$rootScope.$watch('userId', function (newValue, oldValue) {

  		$scope.userId = newValue; 

  	});

  }
);


