<?php

use Jenssegers\Mongodb\Model as Eloquent;

class Profile extends Eloquent {
	public $collection = "profiles";
	
	function user() {
		return $this->belongsTo('User');
	}

	function getStrongholdAttribute($value) {
		$box = new Stronghold($value);
		return $box->decryptAll()->toArray();
	}

	function setStrongholdAttribute($values) {
		$box = new Stronghold($values);
		$this->attributes['stronghold'] = $box->encryptAll()->toArray();
	}

	public static function boot() {
		parent::boot();

		static::created(function($profile){
			Event::fire('profile.submit', [$profile]);
		});
	}
}