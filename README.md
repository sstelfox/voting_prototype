
== TODO ==

Go through and ensure implementation against all common attacks are
implemented. Rack::Protection provides some of this but after reviewing the
code I'm not as trusting of it as I once was. OWASP seems pretty outdated but
it couldn't hurt to go through their 'cheat sheets' and ensure basic or better
protection against all of those mentioned.

* https://www.owasp.org/index.php/Cheat_Sheets#_

Another thing to do is implement protection from the CRIME attack. This will
need to be done either as part of or on it's own as part of the CSRF
protection. It's only really valuable when using SSL but the premise of the
protection is too generate a random string of numbers the same length as the
CSRF token, XOR the token with the random string and prepend the random string
to the result for every page load. When checking the CSRF token the process is
reversed before checking the validity of the form.

Source: https://github.com/rails/rails/pull/11729

Here are some notes on including an authenticity token with javascript
requests, not sure I like the solution so I might just want to use it as the
basis for something else.

http://www.randomactsofsentience.com/2013/06/the-dreaded-attack-prevented-by.html

Origin whitelisting: not sure I can implement this with a generic app:

http://t218.codeinpro.us/q/5150226be8432c04261fba2e

Github's notes on cookie tossing:

https://github.com/blog/1466-yummy-cookies-across-domains

Throttling:

https://github.com/datagraph/rack-throttle
or
http://www.kickstarter.com/backing-and-hacking/rack-attack-protection-from-abusive-clients
https://github.com/kickstarter/rack-attack

Pretty sure I want too use MarionetteJS for my frontend...

http://marionettejs.com/
https://github.com/marionettejs/backbone.marionette
