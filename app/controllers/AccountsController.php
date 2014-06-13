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
	function forgot() {
		$user = User::where('email', Input::get('email'))->get()->first();
		if ($user) {
			
			$data['email'] = $user->email;
			$reminder = new Reminder;
			$reminder->email = $user->email;
			$reminder->token = Hash::make(time());
			$data['token'] = $reminder->token;

			if($reminder->save()){
				
				Mail::send('emails.auth.reminder', $data, function($message) use ($reminder)
				{
				    $message->from('info@college-retirement.com', 'Dev');

				    $message->to($reminder->email);

				    
				});
				return Response::json(['message' => 'success'], 201);
			}
			//return Password::remind($data);
		}
		else{
			return Response::json(['messages' => ['no_email' => 'There is no account with this email']], 409);
		}
	}

	function reset() {
		var_dump(Input::all());
		$rules = array(
                'token' => 'Required|Min:10',
                'password'  =>'Required|Confirmed',
                'password_confirmation'=>'Required'
        );

         $validator = Validator::make(Input::all(), $rules);

	    if ($validator->fails())
	    {
	    	return Response::json(['messages' => ['error' => ['resone' =>  $validator]]], 409);

	    } else { 

		$reminder = Reminder::where('token',Input::get('token'))->get()->first();
		if($reminder){
			$user = User::where('email', $reminder->email)->get()->first();
			$user->password = Hash::make(Input::get('password'));
			if ($user->save()) {
				$reminder->delete();
				return Response::json(['message' => 'success'], 201);

			}
			else {
				return Response::json(['messages' => ['db_error' => 'Unable to update account.']], 500);
			}
		}
	}
	}

	function personaVerify() {
		$data = Input::all();
		
		$email = $data[0]['value'];
		$password = $data[1]['value'];
		//$user = User::find('53998c05048321d65d0104d9');
		$user = User::where('email', $email)->get()->first();
		//$user = User::where('email', '=','mahfuz@gmail.com');
		// var_dump($user->email);
		// var_dump($user->_id);
		// var_dump($user->password);
		// var_dump(Hash::make($password));
		

		
		if (Auth::attempt(array('email' => $email, 'password' => $password))) {
			
			
				Session::put('currentUser', $user->_id);
				return Response::json(array('status' => 'okay', 'user' => $user->toArray()));
			

		}
		else {
			return Response::json(array('status' => 'error'));
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