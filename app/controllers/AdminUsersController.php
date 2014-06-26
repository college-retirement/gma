<?php

class AdminUsersController extends Controller {
	function users() {
		if (Input::get('name')) {
			$name = Input::get('name');
			$users = User::where('name.first', 'like', '%' . $name . '%')->orWhere('name.last', 'like', '%' . $name . '%')->get();
			return Rest::okay($users->toArray());

		}
		else {
			$page = Input::get('page') ?: 1;
			$total = User::count();
			$pagesCount = ceil($total / 20);

			$offset = (($page - 1) * 20);
			$offset = ($offset >= 20) ? $offset : 0;

			$users = User::with(['drafts', 'profiles'])->skip($offset)->take(20)->get();
			return Rest::currentPage($page)->of($pagesCount)->limited(20)->totalItems($total)->okay($users->toArray());
		}
	}

	function user($id) {
		$user = User::with(['drafts', 'profiles'])->find($id);

		if (!$user) return Rest::notFound();

		return Rest::okay($user->toArray());
	}

	function editUser($id) {
		$user = User::find($id);

		if (!$user) return Rest::notFound();

		$user->role = Input::get('role');

		if ($user->save()) {
			$log = new Log;
			$log->action = "Edit";
			$log->details = "User Profile Updated";
			$log->user_id = Session::get('currentUser');
			$log->save();
			
			return Rest::okay($user->toArray());
		}
		else {
			return Rest::conflict();
		}
	}
}