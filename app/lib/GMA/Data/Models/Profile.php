<?php namespace GMA\Data\Models;

use GMA\Data\Security\OwnedByUser;
use GMA\Data\Models\Common\FormatTimestamps;
use GMA\Data\Security\Stronghold;
use \DateTime;

class Profile extends SortableModel
{
    use OwnedByUser;

    protected $collection = "profiles";
    protected $guarded = ['_id'];
    public $timestamps = true;
    public $appends = array('created', 'updated', 'has_profile_school');
    
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

    public function user() {
        return $this->belongsTo('User');
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

    public function getHasProfileSchoolAttribute()
    {
        $profileSchools = null;

        if (isset($this->attributes['schools'])) {
            foreach ($this->attributes['schools'] as $school) {
                if (isset($school['finAid'])) {
                    if (isset($school['finAid']['css_profile'])) {
                        if ($school['finAid']['css_profile'] === true) {
                            $profileSchools = true;
                        } else {
                            $profileSchools = false;
                        }
                    } else {
                        return null;
                    }
                } else {
                    return null;
                }
            }
            return $profileSchools;
        } else {
            return false;
        }
    }

    public function getStrongholdAttribute($value)
    {
        $box = new Stronghold($value);
        return $box->decryptAll()->toArray();
    }

    public function setStrongholdAttribute($values)
    {

        $box = new Stronghold($values);
        $encrypted = $box->encryptAll()->toArray();
        $this->attributes['stronghold'] = $box->encryptAll()->toArray();
    }
}
