angular.module('gmaApp.controllers', []);
angular.module('gmaApp.controllers').controller("InitialDataController", function($rootScope, $scope, states, $http){
	$scope.states = states;
	$scope.currentSchool = null;
	
	$http.get('/assets/js/colleges.json').then(function(obj){
		$scope.collegeList = obj.data;
	});
	
	$scope.ownershipTypes = [
		'Personally',
		'Jointly',
		'LLC',
		'S-Corp',
		'Partnership',
		'C-Corp',
		'Other'
	];

	$scope.liabilityTypes = [
		'Car Loan',
		'Credit Card',
		'First Mortgage',
		'Home Equity Line Of Credit',
		'Life Insurance Premium',
		'Other',
		'Second Mortgage'
	];

	$scope.assetTypes = [
		'Annuities (Non Qualified - Not Retirement)',
		'Bonds (including Tax - Exempt)',
		'Business Assets',
		'Cash, Savings',
		'Certificates of Deposit',
		'Checking',
		'Money Market Funds',
		'Mutual Funds',
		'Other Assets',
		'Pre-Paid Tuition Accounts (529 Plans)',
		'Sibling Assets Held By Parents',
		'Stocks',
		'Treasury Bills'
	];

	$scope.retirementTypes = [
		'401(k)',
		'403(b)',
		'IRA',
		'Keogh/SEP/Simple',
		'Pension Fund',
		'Qualified Annuities',
		'Rollover'
	];
	
	$scope.student = {
		schools: [],
		family: {
			members: [],
			realEstate: [],
			assets: [],
			liabilities: [],
			retirement: []
		}
	};


	$scope.addSchool = function() {
		$scope.student.schools.push($scope.currentSchool);
		$scope.currentSchool = null;
	};

	$scope.updateSchool = function(school, index) {
		$scope.currentSchool = school;
		$scope.currentSchool.profile = true;
		$scope.currentSchool.ncProfile = false;
		$scope.currentSchool.idoc = true;
	};

	$scope.dumpJSON = function() {
		$http.post('/try', $scope.student);
	};

	$scope.addFamily = function() {
		$scope.student.family.members.push({student: false});
	};

	$scope.addProperty = function() {
		$scope.student.family.realEstate.push({});
	};

	$scope.addAsset = function() {
		$scope.student.family.assets.push({});
	};

	$scope.addLiability = function() {
		$scope.student.family.liabilities.push({});
	};

	$scope.addRetirement = function() {
		$scope.student.family.retirement.push({});
	}
});