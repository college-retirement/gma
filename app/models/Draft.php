<?php
use Jenssegers\Mongodb\Model as Eloquent;

class Draft extends Eloquent {
	public $collection = "drafts";
	public $appends = array('created');

	function getCreatedAttribute() {
		$dt = new DateTime($this->attributes['created_at']);
		return $dt->format('c');
	}
}