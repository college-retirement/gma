<?php namespace GMA\Controllers\Admin;

use GMA\Controllers\Base;
use GMA\Data\Models\Profile;
use Rest;

class ClientController extends Base
{

    public function all()
    {
        if ($this->isSorting()) {
            $query = Profile::client()->with('user')->withSortables($this->sortableColumns)->paginate(20);
            return Rest::okay($query);
        } else {
            $profiles = Profile::client()->with('user')->paginate(20);
            return Rest::okay($profiles);
        }
    }

    public function get($id)
    {
        $profile = Profile::client()->with('user')->find($id);

        if ($profile) {
            return Rest::okay($profile);
        } else {
            return Rest::notFound();
        }
    }
}
