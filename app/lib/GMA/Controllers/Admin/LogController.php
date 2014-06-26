<?php namespace GMA\Controllers\Admin;

use GMA\Controllers\Base;
use GMA\Data\Models\Log;
use Rest;

/**
*  Will Acees log Model
*/
class LogController extends Base {

    public function all()
    {
    	if ($this->isSorting()) {
            
            $query = Log::with('user')->withSortables($this->sortableColumns())->paginate(30);
            return Rest::okay($query);
        } else {

            $sortableColumns = [['column' => 'created_at',
                    'order' => 'DESC']];
                    
            $logs = Log::with('user')->withSortables($sortableColumns)->paginate(30);
            return Rest::okay($logs);
        }
    }
}
