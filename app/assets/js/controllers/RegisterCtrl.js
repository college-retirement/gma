angular.module('gmaApp').controller('RegisterCtrl', function($scope, $http, $location, Persona){
	$scope.done = false;
	$scope.submit = function() {
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
		$scope.submitted = true;

		if (!errors) {
			$http.post('/accounts', $scope.user).success(function(){
				$scope.done = true;
			}).error(function(obj){
				if (obj.hasOwnProperty('messages') && obj.messages.hasOwnProperty('duplicate_email')) {
					toastr.error("There is an account with this email already.");
				}
				else {
					toastr.error("Unable to create account.");
				}
			});
		}
	};

	$scope.login = function() {
		$scope.$emit('loginClick');
	};
});