<div id="container">

    <h1 class="underline">Create an Account</h1>

    <blockquote>Welcome! Please create your account using this form. This information will help us to service your account. You'll need to enter your student's information, and create a username and password.</blockquote>

    <h2 class="underline">Your Account Information</h2>

    <blockquote>Use your email address to create your username, and select a password. Your email address must be unique!</blockquote>

    <form method="post" action="/register/post">

    <div class="form-control">
        <label>Email Address</label> <?= $this->input(['class' => 'half', 'placeholder' => 'your@email.com', 'name' => 'email'], $this->user->email); ?>
        <div class="help">You'll use this email to access your account, so make sure this address works properly.</div>
    </div>

    <div class="form-control">
        <label>Choose a Password</label>
        <?= $this->input(['type' => 'password', 'class' => 'half', 'placeholder' => 'your password', 'name' => 'password']); ?>
    </div>

    <div class="form-control">
        <label>Enter Your Password Again</label>
        <?= $this->input(['type' => 'password', 'class' => 'half', 'placeholder' => 'you password', 'name' => 'password_match']); ?>
    </div>

    <div class="form-control">
        <label>Account Role</label>
        <?= $this->select(['name' => 'role', 'class' => 'half'], ['Student' => 'Student', 'Parent' => 'Parent', 'Guardian' => 'Guardian'], $this->user->role); ?>
        <div class="help">Are you signing up as a parent, a student or a guardian? Let us know, so that we can provide the correct services.</div>
    </div>

    <h2 class="underline">Student's Information</h2>

        <blockquote>Please give us a little bit of information about the student that this account is for.</blockquote>
        <div class="form-control">

        <label>Legal Name</label>
        <?= $this->input(['class' => 'third', 'placeholder' => 'First Name', 'name' => 'first_name'], $this->user->first_name); ?>
        <?= $this->input(['class' => 'third', 'placeholder' => 'Middle Name', 'name' => 'middle_name'], $this->user->middle_name); ?>
        <?= $this->input(['class' => 'third', 'placeholder' => 'Last Name', 'name' => 'last_name'], $this->user->last_name); ?>
 </div>
            <div class="form-control">

        <label>Primary Phone Number</label>
        <?= $this->input(['class' => 'third', 'placeholder' => '(___) ___-____', 'name' => 'primary_phone'], $this->user->primary_phone); ?>
</div>
                <div class="form-control">

        <label>Gender</label>
        <?= $this->select(['name' => 'gender', 'class' => 'half'], ['M' => 'Male', 'F' => 'Female'], $this->user->gender); ?>
       </div>

    <div class="form-actions">
        <?= $this->input(['class' => 'button', 'value' => 'Register', 'type' => 'submit']); ?>
    </div>
    </form>
</div>