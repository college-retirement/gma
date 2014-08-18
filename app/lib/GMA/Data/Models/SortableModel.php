<?php namespace GMA\Data\Models;

use Jenssegers\Mongodb\Model as Model;

class SortableModel extends Model
{
    public function scopeWithSortables($query, $sortables)
    {
        if (count($sortables)  < 1) {
            return $query;
           } 
        if (count($sortables) == 1) {
            return $query->orderBy($sortables[0]['column'], $sortables[0]['order']);
        } else {
            $q = $query;

            foreach ($sortables as $col) {
                $q->orderBy($col['column'], $col['order']);
            }

            return $q;
        }
    }
}
