<?php namespace GMA\Controllers\Admin;

use GMA\Controllers\Base;
use GMA\Data\Models\Draft;
use \Rest;

class DraftController extends Base
{
    public function all()
    {
        if ($this->isSorting()) {
            $user = ['user' => function ($query) {
                    $query->withSortables($this->sortableSubColumns('user'));
            }];
            $query = Draft::with($user)->withSortables($this->sortableColumns())->paginate(30);
            return Rest::okay($query);
        } else {
            return Rest::okay(Draft::with('user')->paginate(30));
        }
    }
}
