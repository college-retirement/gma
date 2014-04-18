<?php

namespace Application\Model\User;

use Aura\Filter;

class Student {

	public $gender;
	public $first_name;
	public $middle_name;
	public $last_name;
	public $primary_phone;
	public $updated_at;
	public $created_at;

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