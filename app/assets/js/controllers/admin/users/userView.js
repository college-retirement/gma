angular.module('gmaApp').controller('AdminUserViewCtrl', function($scope, $route, $http, $location){
	var id = $route.current.params.user;
	$http.get('/admin/users/' + id).then(function(obj){
		$scope.user = obj.data.result;
		$scope.drafts = obj.data.result.drafts;
		$scope.profiles = obj.data.result.profiles;
	});

	$scope.changeGroup = function(role) {
		$http.put('/admin/users/' + id, {role: role}).success(function(obj){
			$scope.user = obj.result;
			toastr.success('', 'User updated successfully!');
		}).error(function(){
			toastr.error('', 'Unable to update user.');
		});
	};

	$scope.viewDraft = function(draft) {
		$location.path('/admin/drafts/' + draft._id);
	};

	$scope.viewProfile = function(profile) {
		$location.path('/admin/profiles/' + profile._id);
	};
});