<div id="container">

    <h3>Register an Account</h3>

    <blockquote>Registering an account with College & Retirement Solutions will allow you to securely create student profiles for use by CRS staff to assist in servicing your account.</blockquote>

    <form method="post" action="/register/post">
    <table>
        <tr>
            <td class="label"><label>Legal Name</label></td>
            <td class="control">
                <?= $this->input(['class' => 'third', 'placeholder' => 'First Name', 'name' => 'first_name'], $this->user->first_name); ?>
                <?= $this->input(['class' => 'third', 'placeholder' => 'Middle Name', 'name' => 'middle_name'], $this->user->middle_name); ?>
                <?= $this->input(['class' => 'third', 'placeholder' => 'Last Name', 'name' => 'last_name'], $this->user->last_name); ?>

            </td>
        </tr>
        <tr>
            <td class="label"><label>Email Address</label></td>
            <td class="control">
                <?= $this->input(['class' => 'half', 'placeholder' => 'your@email.com', 'name' => 'email'], $this->user->email); ?>
            </td>
        </tr>
        <tr>
            <td class="label"></td>
            <td class="control"><span class="help">You'll use this email to access your account, so make sure this address works properly.</span></td>
        </tr>

        <tr>
            <td class="label"><label>Choose a Password</label></td>
            <td class="control">
                <?= $this->input(['type' => 'password', 'class' => 'half', 'placeholder' => 'your password', 'name' => 'password']); ?>
            </td>
        </tr>

        <?php (isset($this->messages['password_confirm'])) ? $class = 'invalid' : $class = ''; ?>
        <tr>
            <td class="label <?= $class ?>"><label>Enter Your Password Again</label></td>
            <td class="control <?= $class ?>">
                <?= $this->input(['type' => 'password', 'class' => 'half', 'placeholder' => 'you password', 'name' => 'password_match']); ?>
            </td>
        </tr>

        <tr>
            <td class="label"><label>Primary Phone Number</label></td>
            <td class="control">
                <?= $this->input(['class' => 'third', 'placeholder' => '(___) ___-____', 'name' => 'primary_phone'], $this->user->primary_phone); ?>
            </td>
        </tr>
        <tr>
            <td class="label"><label>Gender</label></td>
            <td class="control"><?= $this->select(['name' => 'gender', 'class' => 'half'], ['M' => 'Male', 'F' => 'Female'], $this->user->gender); ?></td>
        </tr>
        <tr>
            <td class="label"><label>Account Role</label></td>
            <td class="control"><?= $this->select(['name' => 'role', 'class' => 'half'], ['Student' => 'Student', 'Parent' => 'Parent', 'Guardian' => 'Guardian'], $this->user->role); ?></td>
        </tr>
    </table>

    <div class="form-actions">
        <?= $this->input(['class' => 'button', 'value' => 'Register', 'type' => 'submit']); ?>
    </div>
    </form>
</div>