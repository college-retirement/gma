angular.module('gmaApp').controller('MoreInfoCtrl', function($scope, $http, $route, $location, Persona, states, AssetTypes, OwnershipTypes, LiabilityTypes, RetirementTypes){
	// Persona
	Persona.status();
	$scope.getUser = function() {
		return Persona.getUser();
	};

	// States for state selection
	$scope.states = states;


	if ($route.current.params.hasOwnProperty('profileid')) {
		$http.get('/profiles/' + $route.current.params.profileid).then(function(obj){
			$scope.student = obj.data.result;
		});
	}

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
			$http.put('/profiles/' + $route.current.params.profileid, $scope.student).success(function(){
				$scope.finished = true;
			}).error(function(){
				toastr.error("Unable to update account.");
			})
		}
	};
});