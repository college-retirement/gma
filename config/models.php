<?php
/*
 * --------------------------------------------------
 * Model Configuration
 * --------------------------------------------------
 */
$di->params['Modus\Common\Model\Factory'] = array(
    'map' => array(
        'user' => $di->newFactory('Application\Model\User\Gateway', [$di->lazyNew('Application\Model\User\Storage')]),

    ),
);

$di->setter['Application\Model\User\Gateway']['setFilter'] = $di->lazyNew('Aura\Filter\RuleCollection');

$di->params['Modus\Common\Model\Storage\Database'] = array(
    'master' => $di->lazyGet('master'),
    'slave' => $di->lazyGet('slave'),
);