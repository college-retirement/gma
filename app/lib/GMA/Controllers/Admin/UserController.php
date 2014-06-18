<?php namespace GMA\Controllers\Admin;

use GMA\Data\Models\User;
use GMA\Controllers\Base;
use \Rest;

class UserController extends Base
{
    public function all()
    {
        if ($this->isSorting()) {
            $query = User::with(['drafts', 'profiles'])->withSortables($this->sortableColumns())->paginate(40);
            return Rest::okay($query);
        } else {
            return Rest::okay(User::with(['drafts', 'profiles'])->paginate(40));
        }
    }
}
