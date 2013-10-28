angular.module('gmaApp', ['gmaApp.filters', 'gmaApp.controllers', 'ngRoute',  'ngAnimate', 'ui.utils', 'ui.bootstrap', 'persona']);
angular.module('gmaApp.filters', []);

angular.module('gmaApp').config(['$routeProvider', function($routeProvider){
	$routeProvider.when('/', {
		templateUrl: "assets/views/home.html",
		controller: "MainCtrl"
	}).when('/initial',{
		templateUrl: "assets/views/initialData.html",
		controller: "InitialDataController"
	}).when('/drafts/:draft',{
		templateUrl: "assets/views/initialData.html",
		controller: "DraftCtrl"
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

	$http.get('/drafts').then(function(obj){
		$scope.drafts = obj.data.drafts;
	});
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

	$scope.dumpStatus = function() {
		console.log($scope.status());
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