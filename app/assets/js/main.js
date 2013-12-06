angular.module('gmaApp', ['gmaApp.filters', 'ngRoute',  'ngAnimate', 'ui.utils', 'ui.bootstrap', 'persona']);
angular.module('gmaApp.filters', []);

angular.module('gmaApp').config(['$routeProvider', '$httpProvider', function($routeProvider, $httpProvider){
	$routeProvider.when('/', {
		templateUrl: "assets/views/home.html",
		controller: "MainCtrl"
	}).when('/profile', {
		templateUrl: "assets/views/initialData.html",
		controller: "ProfileCtrl",
		resolve: {
			moreInfo: function() {
				return false;
			},
			profile: function() {
				return false;
			}
		}
	}).when('/moreinfo/:profileid', {
		templateUrl: "assets/views/initialData.html",
		controller: "ProfileCtrl",
		resolve: {
			moreInfo: function() {
				return true;
			},
			profile: ['$route', '$http', function($route, $http) {
				return $http.get('/profiles/' + $route.current.params.profileid).then(function(obj){
					return obj.data.result;
				});
			}]
		}
	}).when('/register', {
		templateUrl: "assets/views/register.html",
		controller: "RegisterCtrl"
	}).when('/drafts/:draft',{
		templateUrl: "assets/views/initialData.html",
		controller: "ProfileCtrl"
	}).when('/admin', {
		templateUrl: "assets/views/admin/home.html",
		controller: "AdminCtrl"
	}).when('/admin/list', {
		templateUrl: "assets/views/admin/profiles/list.html",
		controller: "AdminListCtrl"
	}).when('/admin/profiles/:profile', {
		templateUrl: "assets/views/admin/profiles/view.html",
		controller: "AdminViewCtrl",
		reloadOnSearch: false
	}).when('/admin/drafts/:profile', {
		templateUrl: "assets/views/admin/drafts/view.html",
		controller: "AdminDraftViewCtrl"
	}).when('/admin/drafts', {
		templateUrl: "assets/views/admin/drafts/list.html",
		controller: "AdminDraftListCtrl",
		reloadOnSearch: false
	}).when('/admin/users', {
		templateUrl: "assets/views/admin/users/list.html",
		controller: "AdminUserListCtrl"
	}).when('/admin/users/:user', {
		templateUrl: "assets/views/admin/users/view.html",
		controller: "AdminUserViewCtrl"
	}).otherwise('/');
	
	$httpProvider.interceptors.push('UnauthorizedXHRInterceptor');
}]);


angular.module('gmaApp').factory('UnauthorizedXHRInterceptor', function($location){
	return {
		'responseError': function(o) {
			if (o.url !== '/persona/status' && o.status == 401) {
				$location.path('/');
			}
		}
	};
});

angular.module('gmaApp').controller('AppCtrl', function($rootScope, $scope, Persona){

});

angular.module('gmaApp').controller("MainCtrl", function($rootScope, $scope, Persona, $timeout, $http){
	Persona.status();

	$scope.drafts = [];

	$scope.login = function() {
		$scope.$emit('loginClick');
	};

	$scope.getUser = function() {
		return Persona.getUser();
	};

	$scope.getDrafts = function() {
		$http.get('/drafts').then(function(obj){
			$scope.drafts = obj.data.drafts;
		});
	};

	if ($scope.getUser() !== false) {
		$scope.getDrafts();
	}


	$scope.$watch("getUser()", function(o){
		if (o !== false) {
			$scope.getDrafts();
		}
	});


	$scope.draftDelete = function(draft) {
		$http.delete('/drafts/' + draft['_id']).then(function(obj){
			toastr.success("Draft deleted successfully.");
			$http.get('/drafts').then(function(obj){
				$scope.drafts = obj.data.drafts;
			});
		});
	};
});

angular.module('gmaApp').controller("PersonaCtrl", function($rootScope, $scope, Persona){
	$scope.login = function() {
		Persona.verify();
	};

	$scope.logout = function() {
		Persona.logout();
	};

	$scope.status = function() {
		Persona.status();
	};

	$scope.getUser = function() {
		return Persona.getUser();
	};
	
	$rootScope.$on('loginClick', function(){
		$scope.login();
	});
});




angular.module('gmaApp').controller("ExtendedProfileController", function($rootScope, $scope){

});