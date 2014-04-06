var agent_controller = angular.module('app.controllers.agent', [
  'app.services.user'
  ]);

agent_controller.controller('agentController',
  function($scope,$location, $routeParams, $rootScope, userService) {

  	$scope.goSetup = function() {
  		$location.path('/setup');
  	}

  	$scope.addAgent = function() {
      console.log('add agent pressed');
  		var email = $scope.signup_email;
  		var pw1 = $scope.signup_pw1;
  		var pw2 = $scope.signup_pw2;

  		if (pw1 != pw2) {
	        $scope.errorMessage = 'Password doesn\'t match please check.'
	        return;
	    }

	    if (email == undefined || pw1 == undefined || pw2 == undefined) {
	     	$scope.errorMessage = 'Please ensure that all the fields are filled in';
	    	return;
	    }

      var token = $rootScope.appToken;
      var secret = $rootScope.appSecret;

      console.log('about to add agent with');
      console.log('token =='+token);
      console.log('secret =='+secret);
      console.log('userid =='+email);
      console.log('password =='+pw1);
      
	    var addAgentPromise = userService.agentRegistration(email, pw1, token, secret);
      addAgentPromise.success(function(data, textStatus, xhr){
        console.log('add agent success!');
        console.log(data);
        console.log(textStatus);
        console.log(xhr);

        $('#signUpModal').modal('hide');
        $('.modal-backdrop').remove();
      })

      addAgentPromise.error(function(data, textStatus, xhr){
        $scope.errorMessage = 'User already exist!'
        $scope.$apply();
      })

  	}

  }
);


