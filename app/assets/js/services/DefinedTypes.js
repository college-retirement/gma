angular.module('gmaApp').service('OwnershipTypes', function(){
	return [
		'Personally',
		'Jointly',
		'LLC',
		'S-Corp',
		'Partnership',
		'C-Corp',
		'Other'
	];
});

angular.module('gmaApp').service('LiabilityTypes', function(){
	return [
		'Car Loan',
		'Credit Card',
		'First Mortgage',
		'Home Equity Line Of Credit',
		'Life Insurance Premium',
		'Other',
		'Second Mortgage'
	];
});

angular.module('gmaApp').service('AssetTypes', function(){
	return [
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
});

angular.module('gmaApp').service('RetirementTypes', function(){
	return [
		'401(k)',
		'403(b)',
		'IRA',
		'Keogh/SEP/Simple',
		'Pension Fund',
		'Qualified Annuities',
		'Rollover'
	];
});