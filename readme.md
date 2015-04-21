To test cache:

1) Git clone this repo.

2) Run command in terminal "ruby proxy.rb"

Do steps 3 and 4 every time you want to cache a url.  

3) Go to 127.0.0.1:2000.

Please use the chrome extension Postman instead of the browser for testing, as the browser will make more than one request at the same time. 

4) Enter URL of your choice.

Terminal should display "cache miss" the first time the proxy views the url. The second time the proxy views the url, terminal should display "fetching from cache." The caching mechanism works as long as the values (byte size, element size, duration) are met. You can go ahead and change these values if your URL does not fit within these parameters.

Remember: you must refresh the browser to hit the server and the terminal will ask you again which URL you would like to enter.
