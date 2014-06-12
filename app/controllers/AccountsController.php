<?php

class AccountsController extends Controller {

	function register() {
		$user = User::where('email', Input::get('email'))->get()->first();

		if ($user) {
			return Response::json(['messages' => ['duplicate_email' => 'An account with that email already exists.']], 409);
		}

		else {
			$user = new User;
            $user->password = $password = Hash::make( Input::get('password'));
			$user->email = Input::get('email');
			$user->gender = Input::get('gender');
			$user->name = Input::get('name');
			$user->phone = Input::get('phone');
			$user->role = Input::get('role');

			if ($user->save()) {
				return Response::json($user, 201);
			}
			else {
				return Response::json(['messages' => ['db_error' => 'Unable to create account.']], 500);
			}
		}
	}

	function personaVerify() {

		$user = User::where('email', Input::get('email'));
		var_dump($user->email);
		var_dump($user->_id);
		
		
		if (Hash::make(Input::get('password')) === $user->email ) {
			
			
				Session::put('currentUser', $user->_id);
				return Response::json(array('status' => 'okay', 'user' => $user->toArray()));
			

		}
		else {
			return Response::json(array('status' => 'error', 'user' => $user->toArray()));
		}

		// $identity = App::make('persona.identity', Input::get('assertion'));
		// $verifier = App::make('persona.verifier');
		// $verifier->verify($identity);

		// if ($identity->getStatus() !== 'okay') {
		// 	return Response::json(array('status' => $identity->getStatus()));
		// }
		// else {
		// 	$user = User::where('email', $identity->getEmail())->get()->first();
		// 	if ($user) {
		// 		Session::put('currentUser', $user->_id);
		// 		return Response::json(array('status' => 'okay', 'user' => $user->toArray()));
		// 	}
		// 	else {
		// 		return Rest::conflict();
		// 	}
		// }
	}

	function personaStatus() {
		if (Session::has('currentUser')) {
			$user = User::find(Session::get('currentUser'));
			return Response::json(array('user' => $user->toArray()));
		}
		else {
			return Response::json(array('user' => null), 401);
		}
	}

	function personaLogout() {
		Session::forget('currentUser');
		return Response::json();
	}
}