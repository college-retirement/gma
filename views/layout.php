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

    <div id="header">
        <div class="logo">
            <a href="/"><img src="/assets/img/crs-logo.png">College & Retirement Solutions</a>
         </div>

    </div>
    <?php echo $this->__raw()->inner_view; ?>


        <script src="https://login.persona.org/include.js"></script>
    </body>
</html>