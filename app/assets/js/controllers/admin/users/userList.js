angular.module('gmaApp').controller('AdminUserListCtrl', function($scope, $location, $http, Persona){
	Persona.status();

	$http.get('/admin/users').then(function(obj){
		$scope.users = obj.data.result;
		$scope.pagination = obj.data.pagination;
	});

	$scope.viewUser = function(user) {
		$location.path('/admin/users/' + user._id);
	};

	$scope.newPage = function(page) {
		toastr.info('', 'Loading', {
			timeOut: 0,
			extendedTimeOut: 0
		});

		$http.get('/admin/users?page=' + page).then(function(obj){
			if (!$scope.$$phase) {
				$scope.$digest(function(){
					$scope.users = obj.data.result;
					$scope.pagination = obj.data.pagination;
				});
			}
			else {
				$scope.users = obj.data.result;
				$scope.pagination = obj.data.pagination;
			}
		});
	};

});