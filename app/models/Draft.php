<?php
use Jenssegers\Mongodb\Model as Eloquent;

class Draft extends Eloquent {
	public $collection = "drafts";
	public $appends = array('created', 'stronghold_decrypt');
	public $fillable = array('email');

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

	function getStrongholdDecryptAttribute() {
		if (array_key_exists('stronghold', $this->attributes)) {
			if (is_array($this->attributes['stronghold'])) {
				$box = new Stronghold($this->attributes['stronghold']);
				return $box->decryptAll();
			}
		}
	}

	function setStrongholdAttribute($values) {
		$box = new Stronghold($values);
		$this->attributes['stronghold'] = $box->encryptAll();
	}
}