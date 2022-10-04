---
layout: post
title: "Addendum to UI Testing with Stubbed Network Data"
author: Nick Pachulski
tags: ["Test Driven Development", "Testing", "iOS", "Swift"]
excerpt_separator: <!--end-of-excerpt-->
redirect_from: /2016/addendum-to-ui-testing-with-stubbed-network-data/
---

This post will only be helpful to you if you intend to use [Joe Masilotti's
strategy for stubbing network data in your UI Tests](http://masilotti.com/ui-testing-stub-network-data/).

You will run into a problem when you try to set a key of
`app.launchEnvironment` to a string with an equals sign in it.<!--end-of-excerpt--> (like this one):

```sh
https://maps.googleapis.com/maps/api/distancematrix/json?origins=42.3535418,-71.0613433&destinations=42.3529193,-71.0577234&mode=walking
```

It is truncated at the first equals sign. Set a break point in your app code after
starting your UI test and run:

```swift
po NSProcessInfo.processInfo().environment
```

In the debugger to see (among a bunch of other key value pairs):

```swift
"https://maps.googleapis.com/maps/api/distancematrix/json?origins":
"your_json_stuffs"
```

You'll see our URL has been truncated at the first equals sign after the word `origin`. This means that your fake `.resume()` method won't get any json.

# Solution

Don't put any equals signs in an `app.launchEnvironment` key:

```swift
let googleApiUrl = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=42.3535418,-71.0613433&destinations=42.3529193,-71.0577234&mode=walking".stringByReplacingOccurrencesOfString("=", withString: "EQUALS")

app.launchEnvironment[googleApiUrl] = "my_json_stuffs"
```

And in your `SeededDataTask` class:

```swift
import Foundation

class SeededDataTask: NSURLSessionDataTask {
private let url: NSURL
private let completion: DataCompletion

    init(url: NSURL, completion: DataCompletion) {
        self.url = url
        self.completion = completion
    }

    override func resume() {
        let allowedURL = url.absoluteString.stringByReplacingOccurrencesOfString("=", withString: "EQUALS")

        if let json = NSProcessInfo.processInfo().environment[allowedURL] {
            let response = NSHTTPURLResponse(URL: url, statusCode: 200, HTTPVersion: nil, headerFields: nil)
            let data = json.dataUsingEncoding(NSUTF8StringEncoding)
            completion(data, response, nil)
        }
    }
}
```
