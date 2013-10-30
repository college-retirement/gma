<?php

class AccountsController extends Controller {

	function register() {
		$user = User::where('email', Input::get('email'))->get()->first();

		if ($user) {
			return Response::json(['messages' => ['duplicate_email' => 'An account with that email already exists.']], 409);
		}

		else {
			$user = new User;
			$user->email = Input::get('email');
			$user->gender = Input::get('gender');
			$user->name = Input::get('name');
			$user->phone = Input::get('phone');
			$user->role = Input::get('role');

			try {
				$user->save();
				return Response::json($user, 201);
			} catch (Exception $e) {
				return Response::json(['messages' => ['db_error' => 'Unable to create account.']], 500);
			}
		}
	}
}