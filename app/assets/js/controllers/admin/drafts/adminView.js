angular.module('gmaApp').controller('AdminDraftViewCtrl', function($scope, $route, $http, $location, Persona, states, AssetTypes, OwnershipTypes, LiabilityTypes, RetirementTypes, $modal){
	Persona.status();
	$scope.mode = $location.search().mode;

	$scope.profileCreated = false;
	$scope.moreInfo = true;

	$scope.states = states;
	$scope.ownershipTypes = OwnershipTypes;
	$scope.liabilityTypes = LiabilityTypes;
	$scope.assetTypes = AssetTypes;
	$scope.retirementTypes = RetirementTypes;
	

	var id = $route.current.params.profile;
	$http.get('/admin/drafts/' + id).then(function(obj){
		$scope.student = obj.data.result;

		if (!$scope.student.hasOwnProperty('siblings')) {
			$scope.student.siblings = {
				schools: []
			};
		}
	});

	$scope.$on('$routeUpdate', function(e){
		$scope.mode = $location.search().mode;
	});

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

	$scope.partial = function() {
		switch ($scope.mode) {
			case 'edit':
				return 'assets/views/admin/drafts/partial/edit.html';
			break;

			case 'view':
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
			else {
				$location.search('mode', mode);
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
		$scope.submit = true;

		if (!errors) {
			if ($scope.profileCreated) {
				$http.put('/admin/profiles', $scope.student).success(function(data){
					$scope.student = data.result;
					toastr.success('Profile updated.');
				}).error(function(){
					toastr.error("Unable to update profile.");
				});
			}
			else {
				$http.post('/admin/profiles', $scope.student).success(function(data, obj){
					$location.search('mode', null);
					$location.path('/admin/profiles/' + data.result._id);
				});
			}
		}
	};

	$scope.changeOwner = function() {
		var modal =  $modal.open({
			templateUrl: 'assets/views/admin/drafts/modal/changeOwner.html',
			controller: "ChangeOwnerCtrl",
			resolve: {
				draft: function() {
					return $scope.student;
				}
			}
		});

		modal.result.then(function(){
			$http.get('/admin/drafts/' + id).then(function(obj){
				$scope.student = obj.data.result;
			});
		})
	}

});

angular.module('gmaApp').controller('ChangeOwnerCtrl', function($rootScope, $scope, $modalInstance, $http, draft){
	$scope.data = {
		draft: draft
	};
	$scope.users = {
		list: []
	};

	$scope.user = {
		name: null,
		isSelected: false,
		selected: {}
	};

	$scope.$watch('user.name', function(val){
		if (val !== undefined && val !== '') {
			$http.get('/admin/users', {params: {name: $scope.user.name}}).success(function(data){
				$scope.users.list = data.result;
			});
		}
	});

	$scope.updateUser = function(user, index) {
		$scope.user.isSelected = true;
		$scope.user.selected = user;
	};

	$scope.doUpdateUser = function() {
		$http({
			method: 'PATCH',
			url: '/admin/drafts/' + $scope.data.draft._id,
			data: {
				'user_id': $scope.user.selected._id
			},
		}).success(function() {
			$modalInstance.close();
			toastr.success('Draft reassigned successfully');
		});
	};

	
	$scope.$on('newUserCreate', function(e, data){
		$scope.user.selected = data;
		$scope.doUpdateUser();
	});

	$scope.close = function() {
		$modalInstance.close();
	};
});

angular.module('gmaApp').controller('NewUserFormCtrl', function($scope, $rootScope, $http){
	$scope.newUser = {};

	$scope.tryCreateUser = function() {
		if ($scope.userForm.$valid) {
			$http.post('/accounts', $scope.newUser).success(function(data, status){
				if (status == 201) {
					toastr.success('New user created successfully.');
					$scope.$emit('newUserCreate', data);
				}
			}).error(function(data, status){
				if (status == 409) {
					$scope.userForm.email.$setValidity(false);
					toastr.error("This email address belongs to an existing user.");
				}
			});
		}
	};

});