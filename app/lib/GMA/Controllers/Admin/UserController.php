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
           
            return Rest::okay(User::with([ 'profiles'])->paginate(20));
        }
    }
}
