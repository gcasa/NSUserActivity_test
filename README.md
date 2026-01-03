# NSUserActivity_test

Small macOS sample that builds and archives an `NSUserActivity` with a populated `CSSearchableItemAttributeSet`, then writes the encoded data to the temporary directory.

## Requirements

- macOS 11+
- Xcode 15+

## Running

1. Open `NSUserActivity_test.xcodeproj` in Xcode.
2. Select the `NSUserActivity_test` scheme and run.
3. On launch, the app encodes a sample activity and logs the archive path in the Xcode console.

## Notes

- `NSUserActivity` itself is not `NSSecureCoding`, so the app archives a dictionary of its serializable fields instead.
- The archive is written to `NSTemporaryDirectory()` as `NSUserActivityArchive.data`.
