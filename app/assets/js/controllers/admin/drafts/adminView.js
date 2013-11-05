angular.module('gmaApp').controller('AdminDraftViewCtrl', function($scope, $route, $http, $location, Persona, states, AssetTypes, OwnershipTypes, LiabilityTypes, RetirementTypes){
	Persona.status();
	$scope.mode = $location.search().mode;

	$scope.states = states;
	$scope.ownershipTypes = OwnershipTypes;
	$scope.liabilityTypes = LiabilityTypes;
	$scope.assetTypes = AssetTypes;
	$scope.retirementTypes = RetirementTypes;
	

	var id = $route.current.params.profile;
	$http.get('/admin/drafts/' + id).then(function(obj){
		$scope.student = obj.data.result;
	});

	$scope.$on('$routeUpdate', function(e){
		$scope.mode = $location.search().mode;
	});

	$scope.partial = function() {
		switch ($scope.mode) {
			case 'edit':
				return 'assets/views/admin/drafts/partial/edit.html';
			break;
			
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
		if ($scope.mode == 'edit') {
			if (jQuery('form').hasClass('ng-dirty') && !$scope.submit) {
				if (confirm("Are you sure you want to change modes without saving?")) {
					$location.search('mode', mode);
				}
			}
		}
		else {
			$location.search('mode', mode);
		}
	};


	$scope.saveDraft = function() {
		$http.put('/admin/drafts/' + id, $scope.student).success(function(obj){
			toastr.success('Draft saved.');
		}).error(function(){
			toastr.error('Unable to save draft.');
		});
	}
});