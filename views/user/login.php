<div id="container">

    <div id="login-box">
        <div id="login-header">Log In</div>

        <div class="user-form-control">
        <label>Email Address:</label>
        <?= $this->input(['name' => 'email', 'placeholder' => 'user@example.com']); ?>
        </div>

        <div class="user-form-control">
            <label>Password:</label>
            <?= $this->input(['type' => 'password', 'name' => 'password', 'placeholder' => 'your password']); ?>
        </div>

        <div class="no-label">
            <input type="button" name="submit" value="Log In" />
        </div>

    </div>

</div>