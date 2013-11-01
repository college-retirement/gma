<?php namespace GMA\Events;

class EmailNotify {
	private $name = "Nancy Ziering";
	private $email = "nziering@college-retirement.com";

	function userAccountCreated($event) {
		\Mail::send('emails.new_account', ['user' => $event], function($mail){
			$mail->to($this->email, $this->name)->subject('New User Account Created');
		});
	}

	function profileSubmitted($event) {
		\Mail::send('emails.new_profile', ['profile' => $event], function($mail){
			$mail->to($this->email, $this->name)->subject('New Profile Created');
		});
	}

	function subscribe($events) {
		$events->listen('user.create', 'GMA\Events\EmailNotify@userAccountCreated');
		$events->listen('profile.submit', 'GMA\Events\EmailNotify@profileSubmitted');
	}
}