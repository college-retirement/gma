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

	function moreInfoRequired($event) {
		\Mail::send('emails.moreInfo', ['profile' => $event], function($mail) use ($event){
			$mail->to($event['user']['email'], $event['user']['name'])->subject('More Information Required');
		});
	}

	function moreInfoRecieved($event) {
		\Mail::send('emails.moreInfoRcd', ['profile' => $event], function($mail) use ($event){
			$mail->to($this->email, $this->name)->subject('Information Received for ' . $event['user']['name']);
		});
	}

	function sendTestEmail($event) {
		\Mail::send('emails.welcome', ['profile' => $event], function($message){
            $message->to('mahfuzcse05@gmail.com', 'John Smith')->subject('Welcome 2!');
        });
	}

	function subscribe($events) {
		$events->listen('user.create', 'GMA\Events\EmailNotify@userAccountCreated');
		$events->listen('mmm.test', 'GMA\Events\EmailNotify@sendTestEmail');
		$events->listen('profile.submit', 'GMA\Events\EmailNotify@profileSubmitted');
		$events->listen('profile.moreInfoRequired', 'GMA\Events\EmailNotify@moreInfoRequired');
		$events->listen('profile.moreInfoRcd', 'GMA\Events\EmailNotify@moreInfoRecieved');
	}
}