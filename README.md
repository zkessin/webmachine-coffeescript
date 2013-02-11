
This is a basic webmachine tool for on the fly compiling of coffeescript.

You should put a link to the coffeescript sources in the priv dir as "priv/www" then
you can make a HTTP request to http://yourhost.com/coffeescript/my_file.coffee and it will 
send you the compiled JS

you need dispatch rule like this

{["coffeescript", '*'], coffeescript, []}.

Created by Zachary Kessin 