<?php

$di->params['Application\Form\Register'] = [
    'user' => $di->lazyNew('Application\Model\User\User'),
    'validator' => $di->lazyNew('Aura\Filter\RuleCollection'),
];

$di->setter['Application\Controller\Register']['setForm'] = $di->lazyNew('Application\Form\Register');