var home_controller = angular.module('app.controllers.home', [
  'app.services.user'
  ]);

home_controller.controller('homeController',
  function($scope,$location, $routeParams, $rootScope, userService) {


  	$scope.login = function() {
  		var email = $scope.login_email;
  		var pw1 = $scope.login_pw;

  		console.log('email =' + email);
  		console.log('pw1 =' + pw1);
  		$('#loginModal').modal('hide');
  		$('body').removeClass('modal-open');
		$('.modal-backdrop').remove();

  		$location.path('/setup');
  	}

  	$scope.signUp = function() {
  		var email = $scope.signup_email;
  		var pw1 = $scope.signup_pw1;
  		var pw2 = $scope.signup_pw2;


  		console.log('email =' + email);
  		console.log('pw1 =' + pw1);
  		console.log('pw2 = ' + pw2);
  		$('#signUpModal').modal('hide');

  		$('body').removeClass('modal-open');
		$('.modal-backdrop').remove();
  		$location.path('/setup');
  	}


  }
);


