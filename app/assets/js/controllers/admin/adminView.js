angular.module('gmaApp').controller('AdminViewCtrl', function($scope, $route, $http, $location, Persona, $modal){
	Persona.status();
	$scope.mode = $location.search().mode;

	var id = $route.current.params.profile;
	$http.get('/admin/profiles/' + id).then(function(obj){
		$scope.student = obj.data;
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
		$location.search('mode', mode);
	};

	$scope.type = function() {
		switch ($scope.mode) {
			case 'edit':
				return 'Profile';
			break;

			case 'css':
				return 'CSS Profile';
			break;

			case 'fafsa':
				return 'FAFSA Profile';
			break;

			case 'report':
				return 'Profile';
			break;	
		}
	}

	$scope.triggerDownload = function() {
		window.open('/dl/' + id);
	}

	$scope.showStudentAssets = function() {
		$modal.open({
			templateUrl: 'assets/views/admin/profiles/modal/assets.html',
			controller: "StudentAssetModal",
			resolve: {
				assets: function() {
					return $scope.student.family.assets
				}
			}
		});
	};

	$scope.showParentAssets = function() {
		$modal.open({
			templateUrl: 'assets/views/admin/profiles/modal/parentsAssets.html',
			controller: "ParentAssetModal",
			resolve: {
				assets: function() {
					return $scope.student.family.assets
				}
			}
		});
	};

	$scope.showRetirementAssets = function() {
		$modal.open({
			templateUrl: 'assets/views/admin/profiles/modal/parentsAssets.html',
			controller: "ParentAssetModal",
			resolve: {
				assets: function() {
					return $scope.student.family.retirement
				}
			}
		});
	};
});

angular.module('gmaApp').controller('StudentAssetModal', function($scope, $modalInstance, assets){
	$scope.assets = [];

	for (asset in assets) {
		var asset = assets[asset];

		if (asset.owner == 'Student') {
			$scope.assets.push(asset);
		}
	}

	$scope.close = function() {
		$modalInstance.close();
	};
});

angular.module('gmaApp').controller('ParentAssetModal', function($scope, $modalInstance, assets){
	$scope.assets = [];

	for (asset in assets) {
		var asset = assets[asset];

		if (asset.owner != 'Student') {
			$scope.assets.push(asset);
		}
	}

	$scope.close = function() {
		$modalInstance.close();
	};
});