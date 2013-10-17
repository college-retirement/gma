angular.module('gmaApp', ['gmaApp.filters', 'gmaApp.controllers', 'ngRoute',  'ngAnimate', 'ui.utils', 'ui.bootstrap']).config(['$routeProvider', function($routeProvider){
	$routeProvider.when('/initial',{
		templateUrl: "assets/views/initialData.html",
		controller: "InitialDataController"
	}).when('/extended', {
		templateUrl: "assets/views/extendedProfile.html",
		controller: "ExtendedProfileController"
	}).otherwise('/initial');
}]);

angular.module('gmaApp').controller("MainCtrl", function($rootScope, $scope){

});



angular.module('gmaApp').controller("ExtendedProfileController", function($rootScope, $scope){

});