<?php namespace GMA\Controllers;

use Controller;
use Input;

class Base extends Controller
{

    protected $sort = false;

    /**
     * Determine based on the input, if the collection should be sorted or not
     * @return boolean
     */
    public function isSorting()
    {
        if (Input::has('sort')) {
            $this->sort = Input::get('sort');
            return true;
        }
        return false;
    }

    /**
     * Get an array of columns that should be sorted upon
     * @return array
     */
    public function sortableColumns()
    {
        if (stristr($this->sort, ',')) {
            $columns = explode(',', $this->sort);
            $sortableCols = [];

            foreach ($columns as $col) {
                if (stristr($this->sort, ':')) {
                    $column = explode(':', $this->sort);

                    $sortableCols[] = [
                        'column' => $column[0],
                        'order' => $this->parseOrder($column[1])
                    ];
                } else {
                    $sortableCols[] = [
                        'column' => $this->sort,
                        'order' => 'ASC'
                    ];
                }
            }

            return $sortableCols;
        } else {
            if (stristr($this->sort, ':')) {
                $column = explode(':', $this->sort);

                return [
                    ['column' => $column[0],
                    'order' => $this->parseOrder($column[1])]
                ];
            } else {
                return [
                    ['column' => $this->sort,
                    'order' => 'ASC']
                ];
            }
        }
    }

    public function sortableSubColumns($collection)
    {
        $sortableCols = [];

        if (stristr($this->sort, ',')) {
            // Multiple columns
            
            $sortables = explode(',', $this->sort);

            foreach ($sortables as $sortable) {
                if (stristr($sortable, '.')) {
                    $sort_parts = explode(':', $sortable);
                    $col_parts = explode('.', $sort_parts[0]);

                    if ($col_parts[0] == $collection) {
                        array_shift($col_parts);
                        $sortableCols[] = [
                            'column' => implode('.', $col_parts),
                            'order' => $sort_parts[1]
                        ];
                    }

                }
            }
        } else {
            // Single column
            if (stristr($this->sort, '.')) {
                $sort_parts = explode(':', $this->sort);
                $col_parts = explode('.', $sort_parts[0]);

                if ($col_parts[0] == $collection) {
                    array_shift($col_parts);
                    $sortableCols[] = [
                        'column' => implode('.', $col_parts),
                        'order' => $sort_parts[1]
                    ];
                }
            }
        }
        
        return $sortableCols;
    }

    private function parseOrder($order)
    {
        $order = strtoupper($order);

        if ($order == 'ASC' || $order == 'DESC') {
            return $order;
        } else {
            return 'ASC';
        }
    }
}
