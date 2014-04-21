var install_controller = angular.module('app.controllers.install', [
  'app.services.user'
]);

install_controller.controller('installController',
  function($scope, $location, $routeParams, $rootScope, userService) {
    $rootScope.selectedIndex = 3;
  }
);


