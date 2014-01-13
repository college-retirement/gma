angular.module('gmaApp').controller('AdminListCtrl', function($scope, Persona, $http, $location){
	Persona.status();

	$scope.getClients = function() {
		$http.get('/admin/clients').then(function(obj){
			$scope.profiles = obj.data.result;
		});
	};

	$scope.getProspects = function() {
		$http.get('/admin/prospects').then(function(obj){
			$scope.profiles = obj.data.result;
		});
	};

	switch ($location.search().clients) {
		case 'true':
			$scope.getClients();
			$scope.clients = true;
		break;

		case 'false':
		default:
			$scope.getProspects();
			$scope.clients = false;
		break;
	}

	$scope.type = ($scope.clients) ? 'Clients' : 'Prospects';


	$scope.viewProfile = function(profile) {
		$location.path('/admin/profiles/' + profile._id);
	};

	$scope.destroy = function(profile) {
		if (!$scope.clients) {
			if (confirm('Are you sure you want to delete this prospect?')) {
				$http.delete('/admin/prospects/' + profile._id).success(function(){
					toastr.success('Prospect deleted.');
					$scope.getProspects();
				}).error(function(){
					toastr.error('Unable to delete Prospect.');
				});
			}
		}
	};
});