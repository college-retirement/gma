<?php
use Jenssegers\Mongodb\Model as Eloquent;

class Draft extends Eloquent {
	public $collection = "drafts";
	public $appends = array('created');

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
}