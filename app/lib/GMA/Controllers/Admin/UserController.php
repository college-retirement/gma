<?php namespace GMA\Controllers\Admin;

use GMA\Data\Models\User;
use GMA\Controllers\Base;
use \Rest;

class UserController extends Base
{
    public function all()
    {
        if ($this->isSorting()) {
        	
            $query = User::with(['profiles'])->withSortables($this->sortableColumns())->paginate(20);
            return Rest::okay($query);
        } else {
            $sortableColumns = [['column' => 'created_at',
                    'order' => 'DESC']];
            return Rest::okay(User::with([ 'profiles'])->withSortables($sortableColumns)->paginate(20));
        }
    }
}
