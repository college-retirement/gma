<?php

use Guzzle\Http\Client;

class CollegesController extends Controller
{
        
    public function findCollege()
    {
        $q = College::where('name', 'like', '%' . Input::get('name') . '%')->orderBy('name', 'asc')->limit(100)->get();
        $res = array();

        foreach ($q as $row) {
            $res[] = array(
                'name' => $row->name,
                'cb_id' => $row->cb_id,
                'city' => $row->city,
                'state' => $row->state
            );
        }

        return Response::json($res);
    }

    public function collegeInfo($cb_id)
    {
        if (Cache::has('school_info_' . $cb_id)) {
            return Rest::okay(Cache::get('school_info_' . $cb_id));
        } else {
            $client = new Client('http://api.getmoreaid.com');
            $data = $client->get('colleges/' . $cb_id . '.json')->send()->json();

            Cache::put('school_info_' . $cb_id, $data, 14400);

            return Rest::okay($data);
        }
    }
}
