var user_service = angular.module('app.services.user', []);

user_service.service('userService',
  function($http, $rootScope) {

    this.registerApp = function(userid, password) {
      var url = "/appRegistration";
      return $.ajax({
        url:url,
        type: "POST",
        data: {
          userId: userid,
          password: password
        }
      })
    }

    this.agentLogin = function(userid, password) {
      var url = "/agentLogin";
      return $.ajax({
        url:url,
        type: "POST",
        data: {
          userId: userid,
          password: password
        }
      })
    }

    this.agentRegistration = function(userid, password, appToken, appSecret) {
      var url = "/userRegistration";
      return $.ajax({
        url:url,
        type: "POST",
        data: {
          userId: userid,
          password: password,
          appToken: appToken,
          appSecret: appSecret
        }
      })
    }



});
