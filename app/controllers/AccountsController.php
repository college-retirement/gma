<?php

class AccountsController extends Controller {

    public function register()
    {
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

	/**
	* as we are using previous version of enssegers/mongodb for that reasone we can not use password reminder 
	*  so we are using manual password recovery
	*/
	function forgot() {
		$user = User::where('email', Input::get('email'))->get()->first();
		if ($user) {
			
			$data['email'] = $user->email;
			$reminder = new Reminder;
			$reminder->email = $user->email;
			$value = str_shuffle(sha1($email.microtime(true)));

		   
			$reminder->token = hash_hmac('sha1', $value, 'EwXnBN7LYptXYUr5qRKT9P0IGJrRFQ7T');
			if($reminder->save()){
				\Mail::send('emails.auth.reminder', ['token' => $reminder->token], function($mail) use ($user) {
			        $mail->to($user->email, $user->full_name)->subject('User Account Reset');
		        });
		        return Response::json(["success" => true], 201);
			}

			
		}
		else{
			return Response::json(['messages' => ['no_email' => 'There is no account with this email']], 409);
		}
	}

	/**
	 * Display the password reset view for the given token.
	 *
	 * @param  string  $token
	 * @return Response
	 */

    public function getReset($token = null)
    {
        if (is_null($token)) App::abort(404);

		return View::make('password.reset')->with('token', $token);
	}

	/**
	 * Handle a POST request to reset a user's password.
	 *
	 * @return Response
	 */
    public function postReset()
    {
        $rules  = [
        'token' => 'required',
        'password' => 'Required|AlphaNum|min:6|Confirmed',
        'password_confirmation' => 'required|min:6|AlphaNum',
        'email' => 'required|email'];

        $validator = Validator::make(Input::all(), $rules);

        if (!$validator->passes()) {
        	return Response::json(['messages' => ['error' => $validator->messages()]], 409);
         } else {	

                $reminder = Reminder::where('token', Input::get('token'))->where('email', Input::get('email'))->get()->first();
        
		        if(!$reminder) {
		        	return Response::json(['messages' => ['error' => 'Invalid token']], 409);
		        }

                $user = User::where('email', Input::get('email'))->get()->first();

                $user->password = Hash::make(Input::get('email'));

		        if($user->save()) {
		        	$reminder->delete();
		        	return Response::json(['messages' => ['success' => 'true']], 202);
		        }
		    }
}

	function personaVerify() {

		$email = Input::get('email');
		$password = Input::get('password');

		
		$user = User::where('email', $email)->get()->first();
		
		
		if (Auth::attempt(array('email' => $email, 'password' => $password))) {
			
			
				Session::put('currentUser', $user->_id);
				return Response::json(array('status' => 'okay', 'user' => $user->toArray()));
			

		}
		else {
			return Response::json(array('status' => 'error'));
		}

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