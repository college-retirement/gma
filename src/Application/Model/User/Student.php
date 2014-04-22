<?php

namespace Application\Model\User;

use Aura\Filter;

class Student {

	public $student_gender;
	public $student_first_name;
	public $student_middle_name;
	public $student_last_name;
	public $student_primary_phone;
	public $student_updated_at;
	public $student_created_at;

	public function __construct() {
		$this->created_at = new \DateTime();
	}

	public function configure(array $values = array()) {
		foreach($values as $key => $value) {
			if(property_exists($this, $key)) {
				$this->$key = $value;
			}
		}
		return $this;
	}

	public function getData(){
		return get_object_vars($this);
	}
}