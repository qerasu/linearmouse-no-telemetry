# Accessibility permission

LinearMouse requires accessibility features to work properly.
You need to grant Accessibility permission at first launch.

## Grant Accessibility permission

1. Click “Open Accessibility”.
2. Click the lock to make changes.
3. Toggle “LinearMouse” on.

LinearMouse resumes automatically after permission is granted. You don't need to reopen it.

## Not working?

If LinearMouse continues to display accessibility permission request window even after it has been
granted, it's likely due to a common macOS bug.

To resolve this issue, you can try the following steps:

1. Remove LinearMouse from accessibility permissions using the "-" button.
2. Re-add it.

If the previous steps did not resolve the issue, you can try the following:

1. Quit LinearMouse.
2. Open Terminal.app.
3. <p>Copy and paste the following command:</p>
   <pre><code>tccutil reset Accessibility com.lujjjh.dev.LinearMouse</code></pre>
   Then press the return key.
4. Launch LinearMouse and try again.
