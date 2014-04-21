var setup_controller = angular.module('app.controllers.setup', [
  'app.services.user'
]);

setup_controller.controller('setupController',
  function($scope, $location, $routeParams, $rootScope, userService) {
    if ($rootScope.userId == undefined) {
      $location.path('/');
    }
    
  	$scope.goAgent = function() {
  		$location.path('/agents');
  	}

  }
);


