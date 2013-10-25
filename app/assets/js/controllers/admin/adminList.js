angular.module('gmaApp').controller('AdminListCtrl', function($scope, Persona, $http, $location){
	Persona.status();

	$http.get('/admin/profiles').then(function(obj){
		$scope.profiles = obj.data;
	});

	$scope.viewProfile = function(profile) {
		$location.path('/admin/profiles/' + profile._id);
	}
});