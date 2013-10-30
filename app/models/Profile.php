<?php

use Jenssegers\Mongodb\Model as Eloquent;

class Profile extends Eloquent {
	public $collection = "profiles";
	
	function getStrongholdAttribute($value) {
		$box = new Stronghold($value);
		return $box->decryptAll()->toArray();
	}

	function setStrongholdAttribute($values) {
		$box = new Stronghold($values);
		$this->attributes['stronghold'] = $box->encryptAll()->toArray();
	}
}