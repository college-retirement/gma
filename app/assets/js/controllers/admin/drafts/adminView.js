angular.module('gmaApp').controller('AdminDraftViewCtrl', function($scope, $route, $http, $location, Persona, states, AssetTypes, OwnershipTypes, LiabilityTypes, RetirementTypes, $modal){
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

	$scope.changeOwner = function() {
		$modal.open({
			templateUrl: 'assets/views/admin/drafts/modal/changeOwner.html',
			controller: "ChangeOwnerCtrl",
			resolve: {
				draft: function() {
					return $scope.student;
				}
			}
		});
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