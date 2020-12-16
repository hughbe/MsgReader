# MsgReader

Swift definitions for structures, enumerations and functions defined in [MS-OXMSG](https://docs.microsoft.com/en-us/openspecs/exchange_server_protocols/ms-oxmsg/)

## Example Usage

Add the following line to your project's SwiftPM dependencies:
```swift
.package(url: "https://github.com/hughbe/MsgReader", from: "1.0.0"),
```

```swift
import MsgReader

let data = Data(contentsOfFile: "<path-to-file>.msg")!
let file = try MsgFile(data: data)
print(file.subject!)
```
