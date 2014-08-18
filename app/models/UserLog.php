<?php

use Jenssegers\Mongodb\Model as Eloquent;

class UserLog extends Eloquent {
	protected $collection = 'log';
 

	public function user()
	{
	  	return $this->belongsTo('User');
	}
}
