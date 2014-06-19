<?php namespace GMA\Controllers\Admin;

use GMA\Controllers\Base;
use GMA\Data\Models\Profile;
use Rest;

class ClientController extends Base
{

    public function all()
    {
        if ($this->isSorting()) {
            $query = Profile::client()->with('user')->withSortables($this->sortableColumns())->paginate(30);
            return Rest::okay($query);
        } else {
            $sortableColumns = [['column' => 'created_at',
                    'order' => 'DESC']];
                    
            $profiles = Profile::client()->withSortables($sortableColumns)->paginate(30);
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
