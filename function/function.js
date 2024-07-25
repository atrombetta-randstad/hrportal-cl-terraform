function handler(event) {
    var request = event.request;
    var uri = request.uri;
    /*  
        Whitelist
        If there is no uri, that means the user is requesting the main page
        simply return the request back without changes
    */
    var whitelist = /static\/|favicon|assets\/|\w+.json|\w+.svg|\w+.js|\w+.png|\w+.css|\w+.txt|\w+.js.map/g;
    if (
        uri.trim().length === 0 ||
        uri.trim() === "/" ||
        uri.match(whitelist).length > 0
    )
        return request;
    /*
        To allow the React router to parse the pages, we will change all requests
        between cf and bucket that are not whitelisted to "index.html"
        This will always load the react router and keep the uri & querystring 
        the same as the user had input ont their navbar.
    */
    request.uri = "/";
    return request;
}