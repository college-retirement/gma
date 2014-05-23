<?php
use Jenssegers\Mongodb\Model as Eloquent;

use Illuminate\Auth\UserInterface;
use Illuminate\Auth\Reminders\RemindableInterface;

use GMA\Data\Models\SortableModel;

class User extends SortableModel implements UserInterface, RemindableInterface
{

    /**
     * The database table used by the model.
     *
     * @var string
     */
    protected $collection = 'users';

    public $appends = array("full_name", "is_admin", "created", "updated");

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

    /**
     * The attributes excluded from the model's JSON form.
     *
     * @var array
     */
    protected $hidden = array();

    /**
     * Get the unique identifier for the user.
     *
     * @return mixed
     */
    public function getAuthIdentifier()
    {
        return $this->getKey();
    }

    /**
     * Get the password for the user.
     *
     * @return string
     */
    public function getAuthPassword()
    {
        return $this->password;
    }

    /**
     * Get the e-mail address where password reminders are sent.
     *
     * @return string
     */
    public function getReminderEmail()
    {
        return $this->email;
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

    public static function boot()
    {
        parent::boot();

        static::created(function ($user) {
            Event::fire('user.create', [$user]);
        });
    }
}
