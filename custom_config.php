<?php

// See http://code.fivefilters.org/full-text-rss/src/master/config.php
if (!isset($options)) $options = new stdClass();

$options->max_entries = 1000;
$options->default_entries = $options->max_entries;

$options->caching = true;
$options->cache_time = 60 * 24 * 30; // 30 days
$options->cache_cleanup = 1000000; // clear cache after this many runs
