<?php

namespace Application\Model\User;

use Modus\Common\Model\User as ModusUser;

use Aura\Filter;

class User extends ModusUser\User {

    public $gender;
    public $first_name;
    public $middle_name;
    public $last_name;
    public $primary_phone;
    public $role;
    public $updated_at;
    public $created_at;
    public $is_admin;

    public function __construct() {
        $this->created_at = new \DateTime();
    }

    public function setAdmin($admin = true) {
        $this->is_admin = $admin;
    }
    
    public function getData(){
    	return get_object_vars($this);
    }
}