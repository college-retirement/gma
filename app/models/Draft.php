<?php
use Jenssegers\Mongodb\Model as Eloquent;

class Draft extends Eloquent {
	public $collection = "drafts";
	public $appends = array('created', 'updated');
	public $guarded = array('_id');

	function user() {
		return $this->belongsTo('User');
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

	function getStrongholdAttribute($value) {
		$box = new Stronghold($value);
		try {
			return $box->decryptAll()->toArray();
		} catch (Exception $e) {
			return false;
		}
	}

	function setStrongholdAttribute($values) {
		$box = new Stronghold($values);
		$this->attributes['stronghold'] = $box->encryptAll()->toArray();
	}
}