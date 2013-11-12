<?php

class CollegesController extends Controller {
	
	function findCollege() {
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
}