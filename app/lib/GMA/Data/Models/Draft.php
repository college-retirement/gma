<?php namespace GMA\Data\Models;

use GMA\Data\Security\Stronghold;
use \DateTime;

class Draft extends SortableModel
{
    protected $collection = "drafts";
    protected $softDelete = true;
    protected $guarded = ['_id'];
    public $timestamps = true;
    public $appends = array('created', 'updated');

    public function user()
    {
        return $this->belongsTo('User');
    }

    public function getCreatedAttribute()
    {
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

    public function getStrongholdAttribute($value)
    {
        if (!is_array($value)) {
            $stronghold = new Stronghold([$value]);
        } else {
            $stronghold = new Stronghold($value);
        }
        return $stronghold->decryptAll()->toArray();
    }

    public function setStrongholdAttribute($value)
    {
        if (!is_array($value)) {
            $stronghold = new Stronghold([$value]);
        } else {
            $stronghold = new Stronghold($value);
        }
        return $stronghold->encryptAll()->toArray();
    }
}
