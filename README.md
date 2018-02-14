# AVWXKit


[![Swift Version][swift-image]][swift-url]
[![License][license-image]][license-url]
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)



`AVWXKit` is a swift client for the METAR/TAF [avwx.rest](https://avwx.rest/) service.


## Requirements

- iOS 11.0+
- Xcode 9.0

## Installation

#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `AVWXKit ` by adding it to your `Podfile`:

```ruby
platform :ios, '11.0'
use_frameworks!
pod 'AVWXKit'
```

#### Carthage

Create a `Cartfile` that lists the framework and run `carthage update`. Follow the [instructions](https://github.com/Carthage/Carthage#if-youre-building-for-ios) to add `$(SRCROOT)/Carthage/Build/iOS/AVWXKit.framework` to an iOS project.

```
github "JanC/AVWXKit"
```
#### Manually
1. Download and drop ```AVWXKit.swift``` in your project.  
2. Congratulations!  

## Usage example

```swift
import AVWXKit

let client = AVWXClient()

client.fetchMetar(forIcao: "KSBP") { result in
    switch result {
    case .success(let metar):
        print("Metar: \(metar.rawReport)")
        break;
    case .failure(let error):
        print("Could not fetch: \(error)")
        break
    }
}
```

## Contribute

We would love you for the contribution to **AVWXKit**, check the ``LICENSE`` file for more info.

## Meta

Jan Chaloupecky – [@TexTwil](https://twitter.com/TexTwil) 

Distributed under the XYZ license. See ``LICENSE`` for more information.


[swift-image]:https://img.shields.io/badge/swift-4.0-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[codebeat-image]: https://codebeat.co/badges/c19b47ea-2f9d-45df-8458-b2d952fe9dad
[codebeat-url]: https://codebeat.co/projects/github-com-vsouza-awesomeios-com