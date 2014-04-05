var user_service = angular.module('app.services.user', []);

user_service.service('userService',
  function($http, $rootScope) {

    this.sendfeedback = function(userFeedback,userEmail){

      var url = "/api/feedback/";
      return $.ajax({
        url:url,
        type: "POST",
        data: {
          userEmail: userEmail,
          feedback: userFeedback
        }
      })
    }



});
