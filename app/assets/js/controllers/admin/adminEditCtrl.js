angular.module('gmaApp').controller('AdminEditCtrl', function($scope, $route, $http, $location, Persona, $modal, states, AssetTypes, OwnershipTypes, LiabilityTypes, RetirementTypes){
	
	$scope.currentSchool = null;
	$scope.collegeList = {};
	$scope.collegesLoading = false;

	$scope.$watch('currentSchool', function(){
		if ($scope.currentSchool != "" && typeof $scope.currentSchool !== "object") {
			
			$scope.collegesLoading = true;

			$http.post('/colleges.json', {name: $scope.currentSchool}).then(function(obj){
				$scope.collegeList = obj.data;
				$scope.collegesLoading = false;
			});
		}
	});
});