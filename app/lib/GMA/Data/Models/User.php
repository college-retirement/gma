<?php namespace GMA\Data\Models;

use GMA\Data\Security\OwnedByUser;
use GMA\Data\Models\Common\FormatTimestamps;
use \DateTime;

class User extends SortableModel
{
    protected $collection = 'users';
    public $timestamps = true;
    public $appends = array("full_name", "is_admin",'created',"updated");
    //protected $dates = array('created');
//    public function getCreatedAttribute($value)
//    {
//        
//        if (array_key_exists('created_at', $this->attributes)) {
//            if (is_string($this->attributes['created_at'])) {
//                $dt = new DateTime($this->attributes['created_at']);
//                return $dt->format('c');
//            }
//            if (is_object($this->attributes['created_at'])) {
//                $dt = new DateTime();
//                $dt->setTimestamp($this->attributes['created_at']->sec);
//                return $dt->format('c');
//            }
//        }
//    }
    
    public function getCreatedAttribute() { 

      if (array_key_exists('created_at', $this->attributes)) {
       
        if (is_string($this->attributes['created_at'])) {
            //var_dump("String");
           // return $carbonDate = \Carbon\Carbon::createFromDate($this->attributes['created_at']);
              $dt = new DateTime($this->attributes['created_at']);
                return $dt->format('c');
        }
        if (is_object($this->attributes['created_at'])) {
            $dt = new DateTime();
                $dt->setTimestamp($this->attributes['updated_at']->sec);
              
           //$c = new \Carbon\Carbon($this->attributes['created_at']->sec);
          // return $carbonDate = $c->toDateTimeString();
                 return $dt->format('c');
        }
      }
       //return true; 
    }

    public function getUpdatedAttribute()
    {
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

    public function drafts()
    {
        return $this->hasMany('Draft');
    }

    public function profiles()
    {
        return $this->hasMany('Profile');
    }

    public function getFullNameAttribute()
    {
        if (array_key_exists('name', $this->attributes)) {
            return $this->attributes['name']['first'] . ' ' . $this->attributes['name']['last'];
        } else {
            return $this->attributes['email'];
        }
    }

    public function getIsAdminAttribute()
    {
        if (array_key_exists('role', $this->attributes)) {
            return $this->attributes['role'] == 'Administrator';
        }
        return false;
    }
    
    public function getDates()
    {
        // only this field will be converted to Carbon
        return array();
    }
}
