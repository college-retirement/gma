<?php

class AdminUsersController extends Controller {
	function users() {
		$page = Input::get('page') ?: 1;
		$total = User::count();
		$pagesCount = ceil($total / 20);

		$offset = (($page - 1) * 20);
		$offset = ($offset >= 20) ? $offset : 0;

		$users = User::with(['drafts', 'profiles'])->skip($offset)->take(20)->get();
		return Rest::currentPage($page)->of($pagesCount)->limited(20)->totalItems($total)->okay($users->toArray());
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
			return Rest::okay($user->toArray());
		}
		else {
			return Rest::conflict();
		}
	}
}