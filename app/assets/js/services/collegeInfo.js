angular.module('colleges', []);

angular.module('colleges').factory("Colleges", ['$http', '$q', function($http, $q){
	var Colleges = {
		getSchool: function(id) {
			return $http.get('/colleges/' + id);
		}
	};
	return Colleges;
}]);