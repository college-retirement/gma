<html>
<head>
    <title>
        <?php if(isset($this->title)) { ?>
            <?= $this->title ?>
        <?php } else { ?>
            College &amp; Retirement Solutions
        <?php } ?>
    </title>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge">
    <link rel="stylesheet" type="text/css" href="/assets/css/app.css" />
    <?php

    echo $this->styles()->get();

    ?>

    <!--[if lte IE 8]>
    <link rel="stylesheet" type="text/css" href="/assets/css/style-ie.css" />
    <![endif]-->

    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
    <?php

    echo $this->scripts()->get();

    ?>
</head>

<body>
<div id="main">
    <div id="header">
        <div id="logo">
            <a href="/"><img src="/assets/img/crs-logo.png" border="0" /></a>
        </div>

        <?php if(isset($this->auth_user)) { ?>
        <div id="menu">
            <ul class="menu-list">
                <li><a href="">Profile</a></li>
                <li><a href="">Checklist</a></li>
                <li><a href="">Colleges</a></li>
            </ul>
        </div>

        <div id="account-menu">
            <ul class="menu-list">
                <li>Logged in as Brandon Savage</li>
                <li><a href="">My Account</a></li>
                <li><a href="/logout">Log Out</a></li>
            </ul>
        </div>
        <?php } else { ?>
            <div id="account-menu">
                <ul class="menu-list">
                    <li><a href="/login">Log In</a></li>
                </ul>
            </div>
        <?php } ?>
    </div>

    <div id="main">
        <?php echo $this->__raw()->inner_view; ?>

    <div class="clearing"></div>

</div>
</body>
</html>