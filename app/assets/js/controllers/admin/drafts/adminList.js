angular.module('gmaApp').controller('AdminDraftListCtrl', function($scope, Persona, $http, $location, $route){
	Persona.status();

	$http.get('/admin/drafts').then(function(obj){
		$scope.profiles = obj.data.result;
		$scope.pagination = obj.data.pagination;
	});

	$scope.viewDraft = function(profile) {
		$location.path('/admin/drafts/' + profile._id);
	}

	$scope.newPage = function(page) {
		toastr.info('', 'Loading', {
			timeOut: 0,
			extendedTimeOut: 0,
		});
		$http.get('/admin/drafts?page=' + page).then(function(obj){
			if(!$scope.$$phase) {
				$scope.$digest(function(){
					$scope.profiles = obj.data.result;
					$scope.pagination = obj.data.pagination;
				});
			}
			else {
				$scope.profiles = obj.data.result;
				$scope.pagination = obj.data.pagination;
			}
			toastr.clear();
		});
	}
});