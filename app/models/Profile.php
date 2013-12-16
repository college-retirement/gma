<?php

use Jenssegers\Mongodb\Model as Eloquent;

class Profile extends Eloquent {
	public $collection = "profiles";	
	public $appends = array('created', 'updated');
	public $guarded = ['_id'];

	function scopeProspect($query) {
		return $query->where('prospect', true)->orWhereRaw(['prospect' => ['$exists' => false]]);
	}

	function scopeClient($query) {
		return $query->where('prospect', false);
	}

	function getStatusAttribute() {
		if (array_key_exists('status', $this->attributes)) {
			return $this->attributes['status'];
		}
		elseif (array_key_exists('prospect', $this->attributes) && $this->attributes['prospect'] == true) {
			return 'Initial Form Submitted';
		}
	}
	
	function getCreatedAttribute() {
		if (array_key_exists('created_at', $this->attributes)) {
			if (is_string($this->attributes['created_at'])) {
				$dt = new DateTime($this->attributes['created_at']);
				return $dt->format('c');
			}
			if (is_object($this->attributes['created_at'])) {
				$dt = new DateTime();
				$dt->setTimestamp($this->attributes['created_at']->sec);
				return $dt->format('c');
			}
		}
	}

	function getUpdatedAttribute() {
		if (array_key_exists('updated_at', $this->attributes)) {
			if (is_string($this->attributes['updated_at'])) {
				$dt = new DateTime($this->attributes['updated_at']);
				return $dt->format('c');
			}
			if (is_object($this->attributes['updated_at'])) {
				$dt = new DateTime();
				$dt->setTimestamp($this->attributes['updated_at']->sec);
				return $dt->format('c');
			}
		}	
	}
	
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