<?php

// See http://code.fivefilters.org/full-text-rss/src/master/config.php
if (!isset($options)) $options = new stdClass();

$options->max_entries = 1000;
$options->default_entries = $options->max_entries;

$options->caching = false;
