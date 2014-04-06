var nav_controller = angular.module('app.controllers.nav', [
  'app.services.user'
  ]);

nav_controller.controller('navController',
  function($scope,$location, $routeParams, $rootScope, userService) {

    //$rootScope.selectedIndex = 1;

  	$rootScope.$watch('userId', function (newValue, oldValue) {

  		console.log('nav controller!!');

  		console.log('watched!');
  		$scope.userId = newValue; 
  	});

    $scope.goHome = function() {
      $location.path('/');
      $rootScope.selectedIndex = 1;
    }

  	$scope.goDashBoard = function() {
  		$location.path('/setup')
  		console.log('clicked go dashboard');
  		$rootScope.selectedIndex = 2; 
  	}

  }
);


