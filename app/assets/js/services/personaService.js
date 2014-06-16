angular.module('persona', []);
 
angular.module("persona").factory("Persona", ["$http", "$q", function ($http, $q) {
    var Persona = {
        user: {},
        getUser: function() {
            if (Persona.user.hasOwnProperty('email')) {
                return Persona.user;
            }
            else {
                return false;
            }
        },
        verify:function (user) {
            var deferred = $q.defer();
            console.log(user);
                $http.post("/persona/verify", user)
                    .then(function (response) {
                        if (response.data.status != "okay") {
                            deferred.reject(response.data.reason);
                        } else {
                            Persona.user = response.data.user;
                            deferred.resolve(response.data.email);
                        }
                    });
            
            return deferred.promise;
        },
        logout:function () {
            return $http.post("/persona/logout").then(function (response) {
                Persona.user = {}
                if (response.data.status != "okay") {
                    $q.reject(response.data.reason);
                }
                // document.location.reload(true);
                return response.data.email;
            });
        },
        status:function () {
            $http.post("/persona/status").then(function (response) {
                Persona.user = response.data.user;
                return Persona.user;
            });
        }
    };

    Persona.status();
    return Persona;
}]);