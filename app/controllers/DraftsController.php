<?php

class DraftsController extends Controller {
	
	function all() {
		if (Session::get('currentUser')) {
			$user = User::with('drafts')->find(Session::get('currentUser'));
			return Response::json(array('drafts' => $user->drafts->toArray()));
		}
		else {
			return Response::json(array(), 401);
		}
	}

	function create() {
		if (Session::get('currentUser')) {
			if (Input::get('_id')) {
				$draft = DB::table('drafts')->where('_id', Input::get('_id'))->get();
				if ($draft) {
					$updatedAt = new DateTime();
					$box = new Stronghold(Input::get('stronghold'));
					$update = [
						'updated_at' => $updatedAt->format('c'),
						'stronghold' => $box->encryptAll()->toArray()
					];
					$update = DB::table('drafts')->where('_id', Input::get('_id'))->update(array_merge(Input::except(array('_id', 'updated_at', 'stronghold')), $update));

					$newDraft = Draft::find(Input::get('_id'));


					return Response::json($newDraft, 200);
				}
			}
			else {
				Draft::unguard();
				$draft = Draft::create(array_merge(Input::all(), array('user_id' => Session::get('currentUser'))));
				return Response::json($draft, 201);
			}
		}
		else {
			return Response::json(array(), 401);
		}
	}

	function show($id) {
		if (Session::get('currentUser')) {
			$draft = Draft::where('user_id', Session::get('currentUser'))->where('_id', $id)->get()->first();
			return Response::json($draft);
		}
		else {
			return Response::json(array(), 401);
		}
	}

	function delete($id) {
		if (Session::get('currentUser')) {
			Draft::where('_id', $id)->where('user_id', Session::get('currentUser'))->delete();
			return Response::json(array(), 200);
		}
		else {
			return Response::json(array(), 401);
		}
	}
}