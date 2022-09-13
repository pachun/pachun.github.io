---
layout: post
title: "Finding Endpoints"
tags: ["Javascript", "Rails"]
---

Sometimes I want to know what server side endpoints I'm hitting as I click around in the browser. The app I maintain at work is large, containing a server side rails app and client side angular app all shoved into a single repository which (in large part) lacks tests and RESTful routes.

As an iOS native, I've been unsure the best way to figure out the endpoints I'm hitting as I click through the app. I learned about Chrome's `right-click > inspect element` dev tool a while back and have been using that for some time to track down the action of the button (e.g. find the `ng-click='...'` attribute for it) and follow the javascript from there.

Last week a coworker showed me something that I've been using heavily since
then: the Network section of the Chrome inspecter. It shows a live-updated list
of all requests the client side app is making to the back end. From here you can
inspect every request, in addition to the parameters passed and URL hit by the
client. Open the inspector with `⌘ ⌥ i` (that's `command option i`) and click on
the Network tab to display it.

From here (especially for me since none of my app's routes are RESTful) you can search your `routes.rb` file for the request path and find the corresponding controller and action.
