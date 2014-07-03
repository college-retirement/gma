angular.module('gmaApp').controller('AdminUserListCtrl', function($scope, $location, $http, Persona){
	Persona.status();

	$http.get('/admin/users').then(function(obj){
		$scope.users = obj.data.result;
		$scope.pagination = obj.data.pagination;
	});

	$scope.sortable = {
		'name.last': false,
		'name.first': false,
		'created_at': false,
	};

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

	$scope.viewUser = function(user) {
		$location.path('/admin/users/' + user._id);
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

		$http.get('/admin/users?page=' + page + '&sort=' + sort.join(',')).then(function(obj){
			if (!$scope.$$phase) {
				$scope.$digest(function(){
					$scope.users = obj.data.result;
					$scope.pagination = obj.data.pagination;
				});
			}
			else {
				$scope.users = obj.data.result;
				$scope.pagination = obj.data.pagination;
			}
			toastr.clear();
		});
	};

});