<div id="container">

    <h1 class="underline">Create an Account</h1>

    <blockquote>Welcome! Please create your account using this form. This information will help us to service your account. You'll need to enter your student's information, and create a username and password.</blockquote>

    <h2>Your Account Information</h2>

    <blockquote>Please provide us with some information about yourself. We'll use your email address as a username as well as to contact you about your account, so please provide your very best email address!</blockquote>

    <form method="post" action="/register/post">

    <div class="form-control">
        <label>Your Name</label>
        <?= $this->input(['class' => 'half', 'placeholder' => 'First Name', 'name' => 'first_name'], $this->user->first_name); ?>
        <?= $this->input(['class' => 'half', 'placeholder' => 'Last Name', 'name' => 'last_name'], $this->user->last_name); ?>
    </div>



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
        <?= $this->input(['type' => 'password', 'class' => 'half', 'placeholder' => 'you password', 'name' => 'password_confirm']); ?>
    </div>

    <div class="form-control">
        <label>Account Role</label>
        <?= $this->select(['name' => 'role', 'class' => 'half'], ['Student' => 'Student', 'Parent' => 'Parent', 'Guardian' => 'Guardian'], $this->user->role); ?>
        <div class="help">Are you signing up as a parent, a student or a guardian? Let us know, so that we can provide the correct services.</div>
    </div>

    <h2>Student's Information</h2>

        <blockquote><p>All accounts must be associated with at least one student, so please provide us with student information here.</p><p>Have more than one student? Don't worry; you can create additional students later once you're logged in.</p></blockquote>
        <div class="form-control">

        <label>Legal Name</label>
        <?= $this->input(['class' => 'third', 'placeholder' => 'First Name', 'name' => 'student[first_name]'], $this->student->first_name); ?>
        <?= $this->input(['class' => 'third', 'placeholder' => 'Middle Name', 'name' => 'student[middle_name]'], $this->student->middle_name); ?>
        <?= $this->input(['class' => 'third', 'placeholder' => 'Last Name', 'name' => 'student[last_name]'], $this->student->last_name); ?>
 </div>
            <div class="form-control">

        <label>Primary Phone Number</label>
        <?= $this->input(['class' => 'third', 'placeholder' => '(___) ___-____', 'name' => 'student[primary_phone]'], $this->student->primary_phone); ?>
</div>
                <div class="form-control">

        <label>Gender</label>
        <?= $this->select(['name' => 'student[gender]', 'class' => 'half'], ['M' => 'Male', 'F' => 'Female'], $this->student->gender); ?>
       </div>

    <div class="form-actions">
        <?= $this->input(['class' => 'button', 'value' => 'Register', 'type' => 'submit']); ?>
    </div>
    </form>
</div>