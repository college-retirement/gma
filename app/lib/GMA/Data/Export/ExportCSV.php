<?php namespace GMA\Data\Export;
use \Profile;
use \DateTime;
class ExportCSV {
	protected $columns;
	protected $profile;
	protected $location;
	protected $siblings;

	function __construct(Profile $profile, $location) {
		$cols = new CSVColumns;
		$this->columns = $cols->cols();
		$this->profile = $profile;
		$this->dotted = array_dot($this->profile->toArray());
		$this->location = $location;
		$this->siblings = $this->getsiblings();
		$this->realEstate = $this->profile['family']['realEstate'];
		$this->assets = $this->profile['family']['assets'];
		$this->liabilities = $this->profile['family']['liabilities'];
		$this->retirement = $this->profile['family']['retirement'];
	}

	function getsiblings() {
		$siblings = [];
		foreach ($this->profile->family['members'] as $member) {
			if ($member['relationship'] == 'sibling') {
				$siblings[] = $member;
			}
		}
		return $siblings;
	}

	function translateColumn($col) {
		$pro = $this->dotted;
		switch ($col) {
			case 'date':
				return date('m/d/Y H:i');
			break;
			case 'st_Name':
				return $pro['name.first'] . ' ' . $pro['name.last'];
			break;

			case 'st_Age':
				return $this->getAge($pro['dob']);
			break;

			case 'st_Grade':
				return '';
			break;

			case 'sib1_Name':
				if (count($this->siblings) > 0) {
					return $this->siblings[0]['name'];
				}
				return '';
			break;

			case 'sib1_Age':
				if (count($this->siblings) > 0) {
					return $this->getAge($this->siblings[0]['dob']);
				}
				return '';
			break;

			case 'sib1_grade':
				if (count($this->siblings) > 1) {
					if (array_key_exists('grade', $this->siblings[0])) {
						return $this->siblings[0]['grade'];
					}
				}
				return '';
			
			break;

			case 'sib2_Name':
				if (count($this->siblings) > 1) {
					return $this->siblings[1]['name'];
				}
				return '';
			
			break;

			case 'sib2_Age':
				if (count($this->siblings) > 1) {
					return $this->getAge($this->siblings[1]['dob']);
				}
				return '';

			break;

			case 'sib2_grade':
				if (count($this->siblings) > 1) {
					if (array_key_exists('grade', $this->siblings[1])) {
						return $this->siblings[1]['grade'];
					}
				}
			
			break;

			case 'sib3_Name':
				if (count($this->siblings) > 2) {
					return $this->siblings[2]['name'];
				}
				return '';

			break;

			case 'sib3_Age':
				if (count($this->siblings) > 2) {
					return $this->getAge($this->siblings[2]['dob']);
				}
				return '';
			
			break;

			case 'sib3_grade':
				if (count($this->siblings) > 2) {
					if (array_key_exists('grade', $this->siblings[2])) {
						return $this->siblings[2]['grade'];
					}
				}
				return '';
			break;

			case 'sib4_Name':
				if (count($this->siblings) > 3) {
					return $this->siblings[3]['name'];
				}
			break;

			case 'sib4_Age':
				if (count($this->siblings) > 3) {
					return $this->getAge($this->siblings[3]['dob']);
				}
				return '';
			break;

			case 'sib4_grade':
				if (count($this->siblings) > 3) {
					if (array_key_exists('grade', $this->siblings[3])) {
						return $this->siblings[3]['grade'];
					}
				}
				return '';
			break;

			case 'p1_Name':
				if ($pro['livingArrangement'] == 'Guardian') {
					return $this->dot('guardian.name.first') . ' ' . $this->dot('guardian.name.last');
				}
				return $this->dot('parents.father.name.first') . ' ' . $this->dot('parents.father.name.last');
			break;

			case 'p1_age':
				if ($pro['livingArrangement'] == 'Guardian') {
					return $this->getAge($this->dot('guardian.dob'));
				}
				return $this->getAge($this->dot('parents.father.dob'));
			break;

			case 'p1_relation':
				if ($pro['livingArrangement'] == 'Guardian') {
					return 'Guardian';
				}
				return 'Father/Step-Father';
			break;

			case 'p1_cell':
				return '';
			break;

			case 'p1_work':
				if ($pro['livingArrangement'] == 'Guardian') {
					return $this->dot('guardian.employer.phone');
				}
				return $this->dot('parents.father.employer.phone');
			break;

			case 'p1_occupation':
				if ($pro['livingArrangement'] == 'Guardian') {
					return $this->dot('guardian.occupation') . ' @ ' . $this->dot('guardian.employer.name');
				}
				return $this->dot('parents.father.occupation') . ' @ ' . $this->dot('parents.father.employer.name');
			break;

			case 'p2_Name':
				return $this->dot('parents.mother.name.first') . ' ' . $this->dot('parents.mother.name.last');
			break;

			case 'p2_age':
				return $this->getAge($this->dot('parents.mother.dob'));
			break;

			case 'p2_relation':
				return 'Mother';
			break;

			case 'p2_cell':
				return '';
			break;

			case 'p2_work':
				return $this->dot('parents.mother.employer.phone');
			break;

			case 'p2_occupation':
				return $this->dot('parents.mother.occupation') . ' @ ' . $this->dot('parents.mother.employer.name');
			break;

			case 'homePhone':
				return $this->dot('phone');
			break;

			case 'address':
				return $this->dot('address.line1');
			break;

			case 'city':
				return $this->dot('address.city');
			break;

			case 'state':
				return $this->dot('address.state');
			break;

			case 'zip':
				return $this->dot('address.zipcode');
			break;

			case 'email':
				return $this->dot('email');
			break;
			
			case 'marital_status':
				switch ($this->dot('parents.marital')) {
					case 0:
					case '0':
						return 'Never Married';
					break;

					case 1:
					case '1':
						return 'Separated';
					break;

					case 2:
					case '2':
						return 'Widowed';
					break;

					case 3:
					case '3':
						return 'Divorced';
					break;

					case 4:
					case '4':
						return 'Remarried';
					break;

					case 5:
					case '5':
						return 'Married';
					break;
				}
			break;

			case 'own_home':
				return ($this->dot('family.home.owned') == TRUE) ? 'Yes' : 'No';
			break;

			case 'credit':
				return '';
			break;

			case 'household':
				return $this->dot('household.size');
			break;

			case 'pre_college':
				return $this->dot('household.preCollege');
			break;

			case 'in_college':
				return $this->dot('household.collegeAttendees');
			break;

			case 'test_type':
			case 'sat_verbal':
			case 'sat_math':
			case 'sat_writing':
			case 'act':
			case 'class_rank':
			case 'gpa':
				return '';
			break;

			case 'st_col1':
				return $this->dot('schools.0.name');
			break;

			case 'st_col2':
				return $this->dot('schools.1.name');
			break;

			case 'st_col3':
				return $this->dot('schools.2.name');
			break;

			case 'st_col4':
				return $this->dot('schools.3.name');
			break;

			case 'st_col5':
				return $this->dot('schools.4.name');
			break;

			case 'st_cyst1':
				if ($this->dot('schools.0.name') != '') {
					return $this->dot('schools.0.city') . ', ' . $this->dot('schools.0.state');
				}
			break;

			case 'st_cyst2':
				if ($this->dot('schools.1.name') != '') {
					return $this->dot('schools.1.city') . ', ' . $this->dot('schools.1.state');
				}
			break;

			case 'st_cyst3':
				if ($this->dot('schools.2.name') != '') {
					return $this->dot('schools.2.city') . ', ' . $this->dot('schools.2.state');
				}
			break;

			case 'st_cyst4':
				if ($this->dot('schools.3.name') != '') {
					return $this->dot('schools.3.city') . ', ' . $this->dot('schools.3.state');
				}
			break;

			case 'st_cyst5':
				if ($this->dot('schools.4.name') != '') {
					return $this->dot('schools.4.city') . ', ' . $this->dot('schools.4.state');
				}
			break;

			case 'sib_college_type':
			case 'sib_col1':
			case 'sib_col2':
			case 'sib_col3':
			case 'sib_cyst1':
			case 'sib_cyst2':
			case 'sib_cyst3':
				return '';
			break;

			case 'st_ei':
				return $this->dot('income.earnedIncome');
			break;

			case 'st_ui':
				return $this->dot('income.unearnedIncome');
			break;

			case 'int_div':
				return '';
			break;

			case 'st_agi':
				return $this->dot('income.agi');
			break;

			case 'father_ei':
				if ($pro['livingArrangement'] == 'Guardian') {
					return $this->dot('guardian.income.earnedIncome');
				}
				return $this->dot('parents.income.father.earnedIncome');
			break;

			case 'mother_ei':
				return $this->dot('parents.income.mother.earnedIncome');
			break;

			case 'p_oti':
				return $this->dot('parents.income.combined.other');
			break;

			case 'ira_contributions':
				return '';
			break;

			case 'retirement_contribution':
				return $this->dot('guardian.income.retirement') + $this->dot('parents.income.father.retirement') + $this->dot('parents.income.mother.retirement');
			break;

			case 'p_agi':
				return $this->dot('guardian.income.agi') + $this->dot('parents.income.combined.agi');
			break;

			case 'itemized_deductions':
				return $this->dot('guardian.income.deductions') + $this->dot('parents.income.combined.deductions');
			break;

			case 'oui':
				return $this->dot('parents.income.combined.deductions');
			break;

			case 'total_tax':
				return $this->dot('parents.income.combined.taxPaid');
			break;

			case 'monthly_contribution':
				return $this->dot('family.contributionAbility');
			break;

			case 'extra_tuition':
				// Tution paid for ele/secondary
			break;

			case 'st_p_cont':
				// Parent Contribution for Student
			break;

			case 'st_grants':
				// Tuition Scholarships/Grants
			break;

			case 'sib_p_cont':
				// Other parental contribution to siblings education
			break;

			case 'sib_grants':
				return '';
			break;

			case 'cs_paid':
				return $this->dot("parents.income.combined.childSupport.paid");
			break;

			case 'cs_recd':
				return $this->dot('parents.income.combined.childSupport.received');
			break;


			case 'purchase_price':
				return $this->dot('family.home.price');
			break;

			case 'purchase_year':
				return $this->dot('family.home.purchasedYear');
			break;

			case 'present_value':
				return $this->dot('family.home.value');
			break;

			case 'real_estate':
				$sum = 0;
				foreach ($this->realEstate as $index => $val) {
					$sum += $val['marketValue'];
				}
				return $sum;
			break;

			case 'p_ccs':
				return $this->sumAsset('Cash, Savings', false);
			break;

			case 'st_ccs':
				return $this->sumAsset('Cash, Savings', true);
			break;

			case 'sib_ccs':
				return '';
			break;

			case 'p_cd':
				return $this->sumAsset('Certificates of Deposit', false);
			break;

			case 'st_cd':
				return $this->sumAsset('Certificates of Deposit', true);
			break;

			case 'sib_cd':
				return '';
			break;

			case 'p_tb':
				return $this->sumAsset('Treasury Bills', false);
			break;

			case 'st_tb':
				return $this->sumAsset('Treasury Bills', true);
			break;

			case 'sib_tb':
				return '';
			break;

			case 'p_mmf':
				return $this->sumAsset('Money Market Funds', false);
			break;

			case 'st_mmf':
				return $this->sumAsset('Money Market Funds', true);
			break;

			case 'sib_mmf':
				return '';
			break;
			
			case 'p_mf':
				return $this->sumAsset('Mutual Funds', false);
			break;

			case 'st_mf':
				return $this->sumAsset('Mutual Funds', true);
			break;

			case 'sib_mf':
				return '';
			break;

			case 'p_stock':
				return $this->sumAsset('Stocks', false);
			break;

			case 'st_stock':
				return $this->sumAsset('Stocks', true);
			break;

			case 'sib_stock':
				return '';
			break;

			case 'p_bond':
				return $this->sumAsset('Bonds (including Tax - Exempt)', false);
			break;

			case 'st_bond':
				return $this->sumAsset('Bonds (including Tax - Exempt)', true);
			break;

			case 'sib_bond':
				return '';
			break;

			case 'p_teb':
			case 'st_teb':
			case 'sib_teb':
				return '';
			break;

			case 'p_ann':
				return $this->sumAsset("Annuities (Non Qualified - Not Retirement)", false);
			break;

			case 'st_ann':
				return $this->sumAsset("Annuities (Non Qualified - Not Retirement)", true);
			break;

			case 'sib_ann':
				return '';
			break;

			case 'p_tf':
			case 'st_tf':
			case 'sib_tf':
				return '';
			break;

			case 'p_lp':
			case 'st_lp':
			case 'sib_lp':
				return '';
			break;

			case 'p_ba':
				return $this->sumAsset('Business Assets', false);
			break;

			case 'st_ba':
				return $this->sumAsset('Business Assets', true);
			break;

			case 'sib_ba':
				return '';
			break;

			case 'p_fa':
			case 'st_fa':
			case 'sib_fa':
				return '';
			break;

			case 'p_ppta':
				return $this->sumAsset("Pre-Paid Tuition Accounts (529 Plans)", false);
			break;

			case 'st_ppta':
				return $this->sumAsset("Pre-Paid Tuition Accounts (529 Plans)", true);
			break;

			case 'sib_ppta':
				return '';
			break;

			case 'p_oa':
				return $this->sumAsset("Other Assets", false);
			break;

			case 'st_oa':
				return $this->sumAsset("Other Assets", true);
			break;

			case 'sib_oa':
				return '';
			break;

			case 'p_csv':
			case 'st_csv':
			case 'sib_csv':
				return '';
			break;

			case 'monthlyExpense':
				return $this->dot('family.monthlyHouseholdExpense');
			break;

			case 'fm_pay':
				return $this->sumLiability('payment', 'First Mortgage');
			break;

			case 'fm_bal':
				return $this->sumLiability('balance', 'First Mortgage');
			break;

			case 'sm_pay':
				return $this->sumLiability('payment', 'Second Mortgage');
			break;

			case 'sm_bal':
				return $this->sumLiability('balance', 'Second Mortgage');
			break;

			case 'heloc_pay':
				return $this->sumLiability('payment', 'Home Equity Line Of Credit');
			break;

			case 'heloc_bal':
				return $this->sumLiability('balance', 'Home Equity Line Of Credit');
			break;

			case 'car_pay':
				return $this->sumLiability('payment', 'Car Loan');
			break;

			case 'car_bal':
				return $this->sumLiability('balance', 'Car Loan');
			break;

			case 'cc_pay':
				return $this->sumLiability('payment', 'Credit Card');
			break;

			case 'cc_bal':
				return $this->sumLiability('balance', 'Credit Card');
			break;

			case 'other1_type':
				return 'Other';
			break;

			case 'other1_pay':
				return $this->sumLiability('payment', 'Other');
			break;

			case 'other1_bal':
				return $this->sumLiability('balance', 'Other');
			break;

			case 'li_pay':
				return $this->sumLiability('payment', 'Life Insurance Premium');
			break;

			case 'f_ira':
				return $this->sumRetirement('IRA', 'Father');
			break;

			case 'm_ira':
				return $this->sumRetirement('IRA', 'Mother');
			break;

			case 'f_401k':
				return $this->sumRetirement('401(k)', 'Father');
			break;

			case 'm_401k':
				return $this->sumRetirement('401(k)', 'Mother');
			break;

			case 'f_403b':
				return $this->sumRetirement('403(b)', 'Father');
			break;

			case 'm_403b':
				return $this->sumRetirement('403(b)', 'Mother');
			break;

			case 'f_pension':
				return $this->sumRetirement('Pension Fund', 'Father');
			break;

			case 'm_pension':
				return $this->sumRetirement('Pension Fund', 'Mother');
			break;

			case 'f_ann':
				return $this->sumRetirement('Qualified Annuities', 'Father');
			break;

			case 'm_ann':
				return $this->sumRetirement('Qualified Annuities', 'Mother');
			break;

			case 'f_rollover':
				return $this->sumRetirement('Rollover', 'Father');
			break;

			case 'm_rollover':
				return $this->sumRetirement('Rollover', 'Mother');
			break;

			case 'f_sep':
				return $this->sumRetirement('Keogh/SEP/Simple', 'Father');
			break;

			case 'm_sep':
				return $this->sumRetirement('Keogh/SEP/Simple', 'Mother');
			break;

			case 'f_ret_cont':
			case 'm_ret_cont':
			case 'f_emp_match':
			case 'm_emp_match':
				return '';
			break;

			case 'comments':
				return $this->dot('comments');
			break;

			case 're_tax':
				return $this->dot('family.home.propertyTax');
			break;

			case 'home_ins':
				return '';
			break;
			case 'other1_type':
			case 'other2_type':
			case 'other2_pay':
			case 'other2_bal':
			case 'other3_type':
			case 'other3_pay':
			case 'other3_bal':
				return '';
			break;
		}

	}

	function getAge($dob) {
		return DateTime::createFromFormat('mdY', $dob)
			->diff(new DateTime('now'))
			->y;
	}

	function dot($key) {
		if (array_key_exists($key, $this->dotted)) {
			return $this->dotted[$key];
		}
		return null;
	}

	private function sumAsset($type, $student = false) {
		$sum = 0;

		foreach ($this->assets as $asset) {
			if ($asset['type'] == $type) {
				if (!$student && $asset['owner'] != 'Student') {
					$sum += $asset['value'];
				}
				elseif (!$student && $asset['owner'] == 'Student') {
					$sum += $asset['value'];
				}
			}
		} 
		return $sum;
	}

	private function sumLiability($sub, $type) {
		$sum = 0;

		foreach ($this->liabilities as $liability) {
			if ($liability['type'] == $type) {
				$sum += $liability[$sub];
			}
		}
		return $sum;
	}

	private function sumRetirement($type, $owner) {
		$sum = 0;

		foreach ($this->retirement as $asset) {
			if ($asset['type'] == $type) {
				if ($asset['owner'] == $owner) {
					$sum += $asset['value'];
				}
			}
		}
		return $sum;
	}

	function export() {
		$rows = [];
		$csvFile = new \Keboola\Csv\CsvFile($this->location);

		$values = [];

		foreach ($this->columns as $col) {
			$values[] = $this->translateColumn($col);
		}

		$csvFile->writeRow($this->columns);
		$csvFile->writeRow($values);
	}
}