angular.module('gmaApp').controller('ResetCtrl', function($scope,$route, $http, $location, Persona){
	$scope.show = false;
	$scope.reset = {};
	$scope.reset.token = $route.current.params.token;
	
		
	
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
			
			
			$http.post('/reset', $scope.reset).success(function(){
				$scope.show = true;
			}).error(function(obj){
				if (obj.hasOwnProperty('messages') && obj.messages.hasOwnProperty('error')) {
					toastr.error(obj.messages.error.resone);
				}
				else {
					toastr.error("Unable to reset account.");
				}
			});
		}
	};

	$scope.login = function() {
		$scope.$emit('loginClick');
	};
});