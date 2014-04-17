<?php

return array(
    "home" => [
        "path" => "/",
        "args" => ["values" => ['controller' => 'index', 'action' => 'index']]
    ],

    "register" => [
        "path" => "/register",
        "args" => ["values" => ['controller' => 'register', 'action' => 'index']]
    ],

    "register_submit" => [
        "path" => "/register/post",
        "args" => ["values" => ['controller' => 'register', 'action' => 'register']]
    ],

    "login" => [
        "path" => "/login",
        "args" => ["values" => ['controller' => 'user', 'action' => 'login']]
    ],
);