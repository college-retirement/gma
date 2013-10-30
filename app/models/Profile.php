<?php

use Jenssegers\Mongodb\Model as Eloquent;

class Profile extends Eloquent {
	public $collection = "profiles";
	public $appends = array("stronghold_decrypt");

	function getStrongholdDecryptAttribute() {
		if (array_key_exists('stronghold', $this->attributes)) {
			if (is_array($this->attributes['stronghold'])) {
				$box = new Stronghold($this->attributes['stronghold']);
				return $box->decryptAll()->toArray();
			}
		}
	}

	function setStrongholdAttribute($values) {
		$box = new Stronghold($values);
		$this->attributes['stronghold'] = $box->encryptAll()->toArray();
	}
}