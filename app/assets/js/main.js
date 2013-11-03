angular.module('gmaApp', ['gmaApp.filters', 'ngRoute',  'ngAnimate', 'ui.utils', 'ui.bootstrap', 'persona']);
angular.module('gmaApp.filters', []);

angular.module('gmaApp').config(['$routeProvider', function($routeProvider){
	$routeProvider.when('/', {
		templateUrl: "assets/views/home.html",
		controller: "MainCtrl"
	}).when('/initial',{
		templateUrl: "assets/views/initialData.html",
		controller: "InitialDataController"
	}).when('/profile', {
		templateUrl: "assets/views/initialData.html",
		controller: "ProfileCtrl"
	}).when('/register', {
		templateUrl: "assets/views/register.html",
		controller: "RegisterCtrl"
	}).when('/drafts/:draft',{
		templateUrl: "assets/views/initialData.html",
		controller: "ProfileCtrl"
	}).when('/admin', {
		templateUrl: "assets/views/admin/home.html",
		controller: "AdminCtrl"
	}).when('/admin/profiles', {
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
	}).otherwise('/');
}]);

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
		$http.get('/drafts').then(function(obj){
			$scope.drafts = obj.data.drafts;
		});
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