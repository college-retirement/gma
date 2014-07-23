angular.module('gmaApp').controller('AdminViewCtrl', function($scope, $route, $http, $location, Persona, $modal, states, AssetTypes, OwnershipTypes, LiabilityTypes, RetirementTypes){

	Persona.status();
	$scope.mode = $location.search().mode;

	var id = $route.current.params.profile;
	$http.get('/admin/profiles/' + id).then(function(obj){
		$scope.student = obj.data;
		if ($scope.student.hasOwnProperty('prospect') && $scope.student.prospect == false) {
			$scope.clients = true;
		}
		else {
			$scope.clients = false;
		}

		if (!$scope.student.hasOwnProperty('siblings')) {
			$scope.student.siblings = {
				schools: []
			}
		}

		if (!$scope.student.hasOwnProperty('family')) {
			$scope.student.family = {
				members: [],
				realEstate: [],
				assets: [],
				liabilities:[],
				retirement:[]
			}
		}
	});

	$http.get('/admin/newsletters').then(function(obj){
		$scope.newsletters = obj.data.result;
		
	});


	$scope.moreInfo = true;

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

			case 'summary':
			default:
				return 'Summary';
			break;	
		}
	}

	$scope.triggerDownload = function() {
		window.open('/admin/dl/' + id);
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

	$scope.previewNewsletter = function(newsletter) {
		$modal.open({
			templateUrl: 'assets/views/admin/profiles/modal/newsletterAssets.html',
			controller: "NewsletterAssetModal",
			resolve: {
				newsletter: function() {
					return newsletter;
				},
				userid: function() {
					return id;
				},
				http: function() {
					return $http;
				}
			}
		});
	}

	$scope.notifyUser = function() {
		$http.get('admin/notify/moreinfo/' + id).success(function(obj){
			$scope.student = obj.result;
			toastr.success("Notification email sent!");
		}).error(function(){
			toastr.error("Unable to send notification email.");
		});
	}

	// States for state selection
	$scope.states = states;

	// Typeahead college name stuff
	$scope.currentSchool = null;
	$scope.currentSibSchool = null;
	$scope.collegeList = [];
	$scope.collegeSibList = [];
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

	$scope.$watch('currentSibSchool', function(){
		if ($scope.currentSibSchool != "" && typeof $scope.currentSibSchool !== "object") {
			
			$scope.collegesLoading = true;

			$http.post('/colleges.json', {name: $scope.currentSibSchool}).then(function(obj){
				$scope.collegeSibList = obj.data;
				$scope.collegesLoading = false;
			});
		}
	});
	// Defined types
	$scope.ownershipTypes = OwnershipTypes;
	$scope.liabilityTypes = LiabilityTypes;
	$scope.assetTypes = AssetTypes;
	$scope.retirementTypes = RetirementTypes;

	$scope.addSchool = function(siblings) {
		if (siblings === true) {
			$scope.student.siblings.schools.push($scope.currentSibSchool);
			$scope.currentSibSchool = null;
		}
		else {
			$scope.student.schools.push($scope.currentSchool);
			$scope.currentSchool = null;
		}

	};

	$scope.updateSchool = function(school, index, siblings) {
		if (siblings === true) {
			$scope.currentSibSchool = school;
		}
		else {
			$scope.currentSchool = school;
		}
	};
	
	$scope.deleteSchool = function(index, siblings) {
		if (siblings) {
			$scope.student.siblings.schools.splice(index, 1);
		}
		else {
			$scope.student.schools.splice(index, 1);
		}
	};

	$scope.checkMember = function() {
		
		if($scope.student.household.size != $scope.student.family.members.length){
			toastr.error('Please add same number family member');
			jQuery("#addfamily").focus();
			
		}
	}

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

	$scope.setClient = function() {
		$scope.student.prospect = false;
		$http.put('/admin/prospects/' + $scope.student._id, $scope.student).success(function(obj){
			$scope.student = obj.result;

			if ($scope.student.hasOwnProperty('prospect') && $scope.student.prospect == false) {
				$scope.clients = true;
			}
			else {
				$scope.clients = false;
			}

			toastr.success('Client updated successfully');
		}).error(function(){
			toastr.error('Unable to update account.');
		});
	};

	

	$scope.submitProfile = function() {
		var errors = false;

		jQuery('.has-error').removeClass('has-error');
		
		jQuery(".ng-invalid").each(function(e){
			errors = true;
			jQuery(this).parent('.control').parent('.form-group').addClass('has-error');
		});
		
		jQuery(".btn.ng-invalid").each(function(e){
			errors = true;
			jQuery(this).parent('.btn-group').parent('.control').parent('.form-group').addClass('has-error');
		});

		jQuery('.input-group>.ng-invalid').each(function(e){
			errors = true;
			jQuery(this).parent('.input-group').parent('.control').parent('.form-group').addClass('has-error');
		});

		jQuery(".ng-invalid:not(form)").first().focus();

		if($scope.student.household.size != $scope.student.family.members.length){
			errors = true;
			toastr.error('Please add same number family member');
			jQuery("#addfamily").focus();

		}
		$scope.submit = true;

		if (!errors) {
			$http.put('/admin/profiles', $scope.student).success(function(data){
				$scope.student = data.result;
				toastr.success('Profile updated.');
			}).error(function(){
				toastr.error("Unable to update profile.");
			});
		}
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

angular.module('gmaApp').controller('NewsletterAssetModal', function($scope, $modalInstance, newsletter,userid,http){
	$scope.newsletter = newsletter;
	$scope.close = function() {
		$modalInstance.close();
	};

	$scope.submit = function() {
		$modalInstance.close();
	}
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