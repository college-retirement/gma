<?php namespace GMA\Controllers\Admin;

use GMA\Data\Models\User;
use GMA\Controllers\Base;
use \Rest;

class UserController extends Base
{
    public function all()
    {
        if ($this->isSorting()) {
        	
            $query = User::with(['drafts', 'profiles'])->withSortables($this->sortableColumns())->paginate(30);
            return Rest::okay($query);
        } else {
            $data = User::all();
            $d = \Illuminate\Pagination::make($data,count($data),10);
            return Rest::okay($d);
            //return Rest::okay(User::with(['drafts', 'profiles'])->paginate(30));
        }
    }
}
