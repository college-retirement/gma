<?php namespace GMA\Data\Models;

use GMA\Data\Security\OwnedByUser;
use GMA\Data\Models\Common\FormatTimestamps;
use \DateTime;

class Profile extends SortableModel
{
    use OwnedByUser;

    protected $collection = "profiles";
    protected $softDelete = true;
    protected $guarded = ['_id'];
    public $timestamps = true;
    public $appends = array('created', 'updated');
    
    /**
     * Query Scopes
     */

    public function scopeProspect($query)
    {
        return $query->where('prospect', true)->orWhereRaw(['prospect' => ['$exists' => false]]);
    }

    public function scopeClient($query)
    {
        return $query->where('prospect', false);
    }

    /**
     * Accessors and Mutators
     */

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
}