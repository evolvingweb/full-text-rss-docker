full-text-rss-docker
====================

A Docker configuration for [full-text-rss](http://code.fivefilters.org/full-text-rss) , allowing you to easily convert RSS feeds with excerpts into full-text.

Usage
----
* Get [Docker](https://docs.docker.com/installation/) installed
* Run ``make build``, then ``make run``
* Access the app on port 14080, eg:
   curl 'http://localhost:makefulltextfeed.php?url=https://smbjorklund.no/taxonomy/term/110/feed'

Configuration
----

You can change the port by running ``make run PORT=1234``.

You can also edit ``custom_config.php`` to change the full-text-rss configuration, see [the docs](http://code.fivefilters.org/full-text-rss/src/master/config.php) for details.
