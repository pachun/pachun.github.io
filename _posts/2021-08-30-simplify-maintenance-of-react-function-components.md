---
layout: post
title: Simplify Maintenance of React Function Components
tags: ["Refactoring", "React", "Diligent Maintenance"]
---

Some function components expand to manage a range of responsibilities. Tracking which parts of the function body relate to the task at hand gets harder. Use well-named hooks to separate concerns out of the function body and into their own files.

Here's an example of the most complex screen in a React Native app I've been working on. It shows small business owners all their credit card and bank account transactions to make expense tracking easier.

```typescript
// imports removed for brevity

const Activity = (): React.ReactElement => {
  useAccountsFromApiInReduxOrLogout();
  useTransactionsFromApiInReduxOrLogout();
  useRefreshedPlaidLinkTokenForAddingNewBankAccounts();

  const { accountsProps, transactionsProps, searchHeaderShadowOpacity } =
    useAnimatedOutAccountsComponentWhenTransactionsAreScrolled();

  const PushNotificationPermissionPopup =
    usePushNotificationPermissionPopupOnFirstArrival();

  return (
    <>
      {PushNotificationPermissionPopup}
      <View style={styles.container}>
        <SearchHeader
          title="Activity"
          shadowOpacity={searchHeaderShadowOpacity}
        />
        <Accounts {...accountsProps} />
        <Transactions {...transactionsProps} />
      </View>
    </>
  );
};

export default Activity;
```

Changing when the push notification popup is shown doesn't require sifting through animation specific code. Or code responsible for fetching things from the API and handling those types of failures.
