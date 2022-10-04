---
layout: post
title: "Conditionally Initializing Immutable Values in Swift"
author: Nick Pachulski
tags: ["iOS", "Swift"]
---

Immutability is great if you can swing it, but sometimes you run into tricky
situations, like conditionally initializing an immutable value at the current
scope.

```swift
func printImmutable(condition: Bool) {
  if condition {
    let immutable = "condition (\(condition)) is true"
  } else {
    let immutable = "condition (\(condition)) is false"
  }
  print(immutable)
}
```

Xcode barks:

> error: use of unresolved identifier 'immutable'
>
> print(immutable)

Maybe you'll sacrifice immutability.

```swift
func printImmutable(condition: Bool) {
  var mutable: String

  if condition {
    immutable = "condition (\(condition)) is true"
  } else {
    immutable = "condition (\(condition)) is false"
  }
  print(mutable)
}
```

I prefer to keep immutability where I can, so here's what I've decided I like to achieve that goal:

```swift
func printImmutable(condition: Bool) {
  let immutable = { () -> String in
    if condition {
      return "condition (\(condition)) is true"
    } else {
      return "condition (\(condition)) is false"
    }
  }()
  print(immutable)
}
```

I like this approach because

- It solves the problem. It acheives the goal of maintaining immutability.
- It visually separates assignment and logic in a satisfying way.

Another way to solve the problem could look like this:

```swift
func printImmutable() {
  let immutable = newImmutable()
  print(immutable)
}

func newImmutable() -> String {
  if 1 > 2 {
    return "Swift is broken"
  } else {
    return "Swift works"
  }
}
```

I prefer reading the closure approach, though both work exactly the same way.

---

_update:_

Xcode 6.3 Beta / Swift 1.2 release notes state:

> `let` constants have been generalized to no longer require immediate initialization. The new rule is that a `let` constant must be initialized before use (like a `var`), and that it may only be initialized: not reassigned or mutated after initialization.

> This enables patterns like:

```swift
let x: SomeThing

if condition {
    x = foo()
} else {
    x = bar()
}

use(x)
```

> which formerly required the use of a `var`, even though there is no mutation taking place. (16181314)
