<?php namespace GMA\Controllers\Admin;

use GMA\Controllers\Base;
use GMA\Data\Models\Profile;
use \Rest;

class ProspectController extends Base
{
    public function all()
    {
        if ($this->isSorting()) {
            $query = Profile::prospect()->withSortables($this->sortableColumns)->paginate(20);
            return Rest::okay($query);
        } else {
            return Rest::okay(Profile::prospect()->paginate(20));
        }

    }
}
