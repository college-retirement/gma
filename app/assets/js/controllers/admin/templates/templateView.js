angular.module('gmaApp').controller('AdminTemplateViewCtrl', function($scope, $route, $http, $location){
	var id = $route.current.params.template;
	$http.get('/admin/newsletter/' + id).then(function(obj){
		$scope.template = obj.data.result;
		
	});
	
	$scope.submitTemplate = function() {

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
			
				$http.put('/admin/newsletter/'+id, $scope.template).success(function(data){
					$scope.template = data.result;
					toastr.success('Template updated.');
				}).error(function(){
					toastr.error("Unable to update profile.");
				});
			
			
		}

	};

	
});