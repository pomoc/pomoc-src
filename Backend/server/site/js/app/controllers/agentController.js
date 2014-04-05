var agent_controller = angular.module('app.controllers.agent', [
  'app.services.user'
  ]);

agent_controller.controller('agentController',
  function($scope,$location, $routeParams, $rootScope, userService) {

  	$scope.goSetup = function() {
  		$location.path('/setup');
  	}

  }
);


