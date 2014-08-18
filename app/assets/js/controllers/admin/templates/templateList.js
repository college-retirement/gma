angular.module('gmaApp').controller('AdminTemplateListCtrl', function($scope, Persona, $http, $location, $route){
	Persona.status();

	$http.get('/admin/newsletters').then(function(obj){
		$scope.templates = obj.data.result;
		$scope.pagination = obj.data.pagination;
	});

	$scope.sortable = {
		
		'created_at': false,
		'template.templateName': false,
		'template.templateSubject': false
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

	
    $scope.viewTemplate = function(template) {
		$location.path('/admin/templates/' + template._id);
	};

	$scope.newPage = function(page) {
		toastr.info('', 'Loading', {
			timeOut: 0,
			extendedTimeOut: 0,
		});

		var sort = [];

		for (var key in $scope.sortable) {
			var sortCol = $scope.sortable[key];
			if (sortCol == 'asc' || sortCol == 'desc') {
				sort.push(key + ':' + sortCol);
			}
		}

		$http.get('/admin/newsletters?page=' + page + '&sort=' + sort.join(',')).then(function(obj){
			if(!$scope.$$phase) {
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
	$scope.destroy = function(template) {
		if (confirm('Are you sure you want to delete this template?')) {
				$http.delete('/admin/newsletter/' + template._id).success(function(){
					toastr.success('Template deleted.');
					$http.get('/admin/newsletter/' ).then(function(obj){
						$scope.templates = obj.data.result;
						$scope.pagination = obj.data.pagination;
						
					});
				}).error(function(){
					toastr.error('Template deleted');
					$http.get('/admin/newsletter/' ).then(function(obj){
						$scope.templates = obj.data.result;
						$scope.pagination = obj.data.pagination;
						
					});
				});
			}
	}
});