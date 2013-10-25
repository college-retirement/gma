angular.module('gmaApp').controller('AdminViewCtrl', function($scope, $route, $http, $location, Persona){
	Persona.status();

	var id = $route.current.params.profile;
	$http.get('/admin/profiles/' + id).then(function(obj){
		$scope.student = obj.data;
	});

	$scope.$on('$routeChangeSuccess', function(){
		$scope.mode = $location.search().mode;
	});

	$scope.partial = function() {
		switch ($scope.mode) {
			case 'css':
				return 'assets/views/admin/profiles/partial/css.html';
			break;

			case 'fafsa':
				return 'assets/views/admin/profiles/partial/fafsa.html';
			break;

			case 'report':
			default:
				return 'assets/views/admin/profiles/partial/report.html';
			break;
		}
	};

	$scope.changeMode = function(mode) {
		$location.search().mode = mode;
	};
});