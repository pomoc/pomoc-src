var home_controller = angular.module('app.controllers.home', [
  'app.services.user'
  ]);

home_controller.controller('homeController',
  function($scope,$location, $routeParams, $rootScope, userService) {


  	$scope.login = function() {
      $scope.errorMessage = '';

  		var email = $scope.login_email;
  		var pw = $scope.login_pw;

  		console.log('email =' + email);
  		console.log('pw1 =' + pw);

      if (email == undefined || pw == undefined) {
        $scope.errorMessage = 'Please ensure that both email and password is filled in';
        return;
      }

      var userLogin = userService.agentLogin(email, pw);
      userLogin.success(function(data, textStatus, xhr){
        console.log('user logged in return val!');
        console.log(data);
        console.log(textStatus);
        console.log(xhr);

        if (data.success == false) {
          $scope.errorMessage = 'Invalid login credential, please try again';
          $scope.$apply();

        } else {
          
          $rootScope.appToken = data.appToken;
          $rootScope.appSecret = data.appSecret;
          $rootScope.userId = data.userId;
          $rootScope.selectedIndex = 2; 
          $rootScope.$apply();

          $('#loginModal').modal('hide');
          $('.modal-backdrop').remove();
          $location.path('/agents');
          $scope.$apply();
        }
        
      })


      userLogin.error(function(data, textStatus, xhr){
        console.log('failed!!');
        console.log(data);
        console.log(textStatus);
        console.log(xhr);

        $scope.errorMessage = 'Invalid login credential, please try again';
        $scope.$apply();
      });

  	}

  	$scope.signUp = function() {

      $scope.errorMessage = '';

  		var email = $scope.signup_email;
  		var pw1 = $scope.signup_pw1;
  		var pw2 = $scope.signup_pw2;

      if (pw1 != pw2) {
        $scope.errorMessage = 'Password doesn\'t match please check.'
        return;
      }

      if (email == undefined || pw1 == undefined || pw2 == undefined) {
        $scope.errorMessage = 'Please ensure that both email and password is filled in';
        return;
      }

      var appRegistrationPromise = userService.registerApp(email, pw1);
      appRegistrationPromise.success(function(data, textStatus, xhr){

        console.log('app registration return!');
        console.log(data);
        console.log(textStatus);
        console.log(xhr);

       
        $('#signUpModal').modal('hide');
        $('.modal-backdrop').remove();

        $rootScope.appToken = data.appToken;
        $rootScope.appSecret = data.appSecret;
        $rootScope.userId = email;
        $rootScope.selectedIndex = 2; 
        $rootScope.$apply();

        $location.path('/setup');
        $scope.$apply();
      


      })

      appRegistrationPromise.error(function(data, textStatus, xhr){
        $scope.errorMessage = 'User already exist! Try logging in'
        $scope.$apply();

      });

      

    }

  }
);


