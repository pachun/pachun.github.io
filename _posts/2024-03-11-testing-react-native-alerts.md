---
layout: post
title: "Testing React Native Alerts"
author: Nick Pachulski
tags: ["React Native", "Testing", "Jest", "Test Driven Development"]
excerpt_separator: <!--end-of-excerpt-->
---

Today I needed to test drive a feature which allows users to confirm their account. Users find their name in a list and tap a "👋 This is Me" button by it. When the button is tapped, they're sent a text message with a 6-digit confirmation code and asked to enter it into a [react native alert prompt](https://reactnative.dev/docs/alert#prompt-ios), which is also shown on screen after the "👋 This is Me" button is tapped.

<!--end-of-excerpt-->

I was able to test that the prompt was displayed by mocking out the call to show the prompt with jest.

```react
it("shows an alert with an input to enter the text message's confirmation code", async () => {
  jest.spyOn(ReactNative.Alert, "prompt")

  ERTL.renderRouter("src/app", { initialUrl: "/players/1" })

  await ERTL.waitFor(() =>
    ERTL.fireEvent.press(
      ERTL.screen.getByTestId("This is Me Button"),
    ),
  )

  // https://reactnative.dev/docs/alert#prompt-ios
  const expectedTitle = "We texted you a 6-digit code"
  const expectedMessage = "Enter it here"
  const expectedCallback = expect.any(Function)
  const expectedType = "plain-text"
  const expectedDefaultValue = ""
  const expectedKeyboardType = "number-pad"

  expect(ReactNative.Alert.prompt).toHaveBeenCalledWith(
    expectedTitle,
    expectedMessage,
    expectedCallback,
    expectedType,
    expectedDefaultValue,
    expectedKeyboardType,
  )
})
```

This worked to test that the prompt is _shown_. However, testing the behavior needed when a code is actually entered into the prompt and submitted was very difficult because React Native Alerts are native components; they're not in the view hierarchy, so there's no way for [React Native Testing Library](https://callstack.github.io/react-native-testing-library/) to find the prompt and enter in text.

I don't love adding dependencies, but after trying to test drive the behavior using React Native's native Alert prompt for several hours, I decided to use [react-native-dialog](https://github.com/mmazzarolo/react-native-dialog).

Here's the skinny...

-   React Native Dialog is pure javascript; So the component is present in the view hierarchy, and therefor testable with React Native Testing Library. 🥰
-   The native alert prompt API is imperative. [React native dialog's API is declarative](https://github.com/mmazzarolo/react-native-dialog?tab=readme-ov-file#a-complete-example). ✅
-   React Native Dialog mimics the UI of the native alert prompt. 👍
-   React Native Dialog supports light and dark mode. 💅
-   React native dialog supports iOS and Android, which is great - but since I'm working on a universal (iOS, Android, & web) Expo app, I'll need a replacement component for the web platform. However, it turns out that the native alert prompt also didn't support web, so nothing lost here. 🤷
-   I'm adding a another dependency, which I don't love 📉, but I think it's worth not spending any more hours trying to figure out how to test the native alert prompt.

*   React Native Dialog hasn't seen a commit in a few years. 😬 Living on the edge 🤙
