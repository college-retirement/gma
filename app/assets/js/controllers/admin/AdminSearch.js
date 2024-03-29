angular.module('gmaApp').controller('AdminSearchCtrl', function($scope, Persona, $http, $location){
	Persona.status();
    $scope.type = "Search";

    $http.get('/admin/clients').then(function(obj){
		
    	 
		//console.log(promises);

		$scope.profiles = $scope.getProfiles(obj.data.result);
		$scope.pagination = obj.data.pagination;
	});


	$scope.sortable = {
		
		'hsGrad': false,
		'address.city': false,
		'name.first': false,
		'name.last': false,
		'phone' : false,
		'address.state': false,
		'school.name': false,
		'dob': false,
		'client_id': false
	};

	$scope.getProfiles = function(profiles) {
		var promises = [];

		jQuery.each(profiles, function(key, val) {
			
			var profile = {};
			

		 profile._id = val._id;	
		 profile.client_id = val.client_id;
    	 profile.name = val.name;
    	
    	 profile.address  = val.address;
    	 
    	 profile.dob  = val.dob;
    	 profile.phone  = val.phone;
    	 profile.hsGrad  = val.hsGrad;
    	 profile.status  = val.status;
    	 profile.updated  = val.updated;
    	 profile.school  = val.school;
    	 profile.has_profile_school  = val.has_profile_school;
    	 //profile.family  = val.family;
    	 //profile.sib_grad  = val.family;
    	 profile.sibgrad  = $scope.getGrade2(val.family);
    	 //call this function from here getGrade(profile)

		  promises.push(profile);
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

	$scope.viewProfile = function(profile) {
		$location.path('/admin/profiles/' + profile._id);
	};

	$scope.getGrade = function(profile) {
		
		if(profile.family.members.length > 0){
			for (var i=0; i< profile.family.members.length ; i++){
				//console.log(profile.family.members[i].relationship);
				if(profile.family.members[i].relationship == 'sibling' && profile.family.members[i].grade) {
					
					var gd = 0;
					if(profile.family.members[i].grade == 'Freshman' || 
						profile.family.members[i].grade == 'Sophomore' || 
						profile.family.members[i].grade == 'Junior' || 
						profile.family.members[i].grade == 'Senior' ){
						gd = 12;
					} else {
						gd = parseInt(profile.family.members[i].grade, 10);
					}

					//console.log(gd);
					return 2014 + (12- gd);
				}
			}
		}
	//return 1;
	}
	$scope.getGrade2 = function(family) {
		
		if(family && family.members.length > 0){
			for (var i=0; i< family.members.length ; i++){
				//console.log(profile.family.members[i].relationship);
				if(family.members[i].relationship == 'sibling' && family.members[i].grade) {
					
					var gd = 0;
					if(family.members[i].grade == 'Freshman' || 
						family.members[i].grade == 'Sophomore' || 
						family.members[i].grade == 'Junior' || 
						family.members[i].grade == 'Senior' ){
						gd = 12;
					} else {
						gd = parseInt(family.members[i].grade, 10);
					}

					//console.log(gd);
					return 2014 + (12- gd);
				}
			}
		}
	return "";
	}

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
		var url = '/admin/clients?page=';
		

		$http.get(url + page + '&sort=' + sort.join(',')).then(function(obj){
			if (!$scope.$$phase) {
				$scope.$digest(function(){
					$scope.profiles = $scope.getProfiles(obj.data.result);
					$scope.pagination = obj.data.pagination;
				});
			}
			else {
				$scope.profiles = $scope.getProfiles(obj.data.result);
				$scope.pagination = obj.data.pagination;
			}
			toastr.clear();
		});
	};

	

});