angular.module('gmaApp').controller('ForgotPasswordCtrl', function($scope, $http, $location, Persona){
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
			
			$http.post('/forgot', $scope.user).success(function(){
				$scope.done = true;
			}).error(function(obj){
				if (obj.hasOwnProperty('messages') && obj.messages.hasOwnProperty('no_email')) {
					toastr.error("There is no account with this email.");
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