angular.module('gmaApp').controller('AdminViewCtrl', function($scope, $route, $http, $location, Persona, $modal, states, AssetTypes, OwnershipTypes, LiabilityTypes, RetirementTypes){

	Persona.status();
	$scope.mode = $location.search().mode;

	var id = $route.current.params.profile;
	$http.get('/admin/profiles/' + id).then(function(obj){
		$scope.student = obj.data;
	});

	$scope.$on('$routeUpdate', function(e){
		$scope.mode = $location.search().mode;
	});

	$scope.credentials = {
		studentFAFSA: false,
		parentFAFSA: false,
		cssUsername: false,
		cssPassword: false
	};
	

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
			default:
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

	$scope.notifyUser = function() {
		$http.get('admin/notify/moreinfo/' + id).success(function(){
			toastr.success("Notification email sent!");
		}).error(function(){
			toastr.error("Unable to send notification email.");
		});
	}

	// States for state selection
	$scope.states = states;

	// Typeahead college name stuff
	$scope.currentSchool = null;
	$scope.collegeList = {};
	$scope.collegesLoading = false;

	// Defined types
	$scope.ownershipTypes = OwnershipTypes;
	$scope.liabilityTypes = LiabilityTypes;
	$scope.assetTypes = AssetTypes;
	$scope.retirementTypes = RetirementTypes;

	$scope.addSchool = function() {
		$scope.student.schools.push($scope.currentSchool);
		$scope.currentSchool = null;
	};

	$scope.updateSchool = function(school, index) {
		$scope.currentSchool = school;
	};
	
	$scope.deleteSchool = function(index) {
		$scope.student.schools.splice(index, 1);
	};


	$scope.addFamily = function() {
		$scope.student.family.members.push({student: false});
	};

	$scope.deleteFamily = function(index) {
		$scope.student.family.members.splice(index, 1);
	}

	$scope.addProperty = function() {
		$scope.student.family.realEstate.push({});
	};

	$scope.deleteProperty = function(index) {
		$scope.student.family.realEstate.splice(index, 1);
	}

	$scope.addAsset = function() {
		$scope.student.family.assets.push({});
	};

	$scope.deleteAsset = function(index) {
		$scope.student.family.assets.splice(index, 1);
	}

	$scope.addLiability = function() {
		$scope.student.family.liabilities.push({});
	};

	$scope.deleteLiability = function(index) {
		$scope.student.family.liabilities.splice(index, 1);
	};

	$scope.addRetirement = function() {
		$scope.student.family.retirement.push({});
	};

	$scope.deleteRetirement = function(index) {
		$scope.student.family.retirement.splice(index, 1);
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