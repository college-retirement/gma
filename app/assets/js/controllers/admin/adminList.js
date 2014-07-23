angular.module('gmaApp').controller('AdminListCtrl', function($scope, Persona, $http, $location){
	Persona.status();

	$scope.getClients = function() {
		$http.get('/admin/clients').then(function(obj){
			$scope.profiles = $scope.getProfiles(obj.data.result);
			$scope.pagination = obj.data.pagination;
		});
	};

	$scope.getProspects = function() {
		$http.get('/admin/prospects').then(function(obj){
			$scope.profiles = $scope.getProfiles(obj.data.result);
			$scope.pagination = obj.data.pagination;
		});
	};

	

	$scope.sortable = {
		'address.city': false,
		'name.first': false,
		'name.last': false,
		'dob': false,
		'phone' : false,
		'address.state':false,
		'client_id':false
		//'created_at': false,
	};

	$scope.getProfiles = function (profiles) {
		var promises = [];

		jQuery.each(profiles, function(key, val) {
			
			var user = {};
			

		 user._id = val._id;	
		 user.client_id = val.client_id;
    	 user.name = val.name;
    	
    	 user.address  = val.address;
    	 
    	 user.phone  = val.phone;
    	 user.dob  = val.dob;

    	 user.status  = val.status;
    	 user.has_profile_school = val.has_profile_school;
    	 
    	 promises.push(user);
		});
		return promises;
	}

	$scope.checkSort = function (column) {
		return $scope.sortable[column];
	};

	$scope.sortClass = function (column) {
		var direction = $scope.sortable[column];

		if (direction === false) {
			return;
		}
		else if (direction == 'asc') {
			return 'icon-caret-up';
		}
		else if (direction == 'desc') {
			return 'icon-caret-down';
		}
	};

	$scope.changeSort = function (column) {
		
		var current = $scope.sortable[column];
		
		if (current === false) {
			$scope.sortable[column] = 'asc';
		} else if (current == 'desc') {
			$scope.sortable[column] = 'asc';
		} else if (current == 'asc') {
			$scope.sortable[column] = 'desc';
		}

		$scope.newPage(1);
	};

	$scope.clearSort = function (column) {
		$scope.sortable[column] = false;
		$scope.newPage(1);
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

	$scope.newPage = function(page) {
		toastr.info('', 'Loading', {
			timeOut: 0,
			extendedTimeOut: 0
		});

		var sort = [];

		for (var key in $scope.sortable) {
			var sortCol = $scope.sortable[key];
			if (sortCol == 'asc' || sortCol == 'desc') {
				sort.push(key + ':' + sortCol);
			}
		}
		var url;
		if($scope.type == 'Clients')
		{
			url = '/admin/clients?page=';
		}
		else {
			url = '/admin/prospects?page=';
		}

		$http.get(url + page + '&sort=' + sort.join(',')).then(function(obj){
			if (!$scope.$$phase) {
				$scope.$digest(function(){
					$scope.profiles = obj.data.result;
					$scope.pagination = obj.data.pagination;
				});
			}
			else {
				$scope.profiles = obj.data.result;
				$scope.pagination = obj.data.pagination;
			}
			toastr.clear();
		});
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