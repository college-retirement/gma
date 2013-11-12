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