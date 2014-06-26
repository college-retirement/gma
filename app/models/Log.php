<?php

use Jenssegers\Mongodb\Model as Eloquent;
class Log extends Eloquent {
  public $collection = "log";

  public function user()
  {
  	 return $this->belongsTo('User');
  }
}
