CRMotionView
=======================
A custom photo viewer that implements device motion scrolling, inspired by [Facebook Paper][4].

[![License MIT](https://go-shields.herokuapp.com/license-MIT-blue.png)](https://github.com/chroman/CRMotionView/blob/master/LICENSE)
[![Build Platform](https://cocoapod-badges.herokuapp.com/p/CRMotionView/badge.png)](http://beta.cocoapods.org/?q=CRMotionView)
[![Build Version](https://cocoapod-badges.herokuapp.com/v/CRMotionView/badge.png)](http://beta.cocoapods.org/?q=CRMotionView)
[![Build Status](https://travis-ci.org/chroman/CRMotionView.png?branch=master)](https://travis-ci.org/chroman/CRMotionView)

![CRMotionView-main](http://chroman.me/wp-content/uploads/2014/02/main3.jpg)

Installation
-----

**CocoaPods**

* Add the dependency to your Podfile:
```ruby
platform :ios
pod 'CRMotionView'
...
```

* Run `pod install` to install the dependencies.

**Source files**

Just clone this repository or download it in zip-file. Then you will find source files under **CRMotionView** directory. Copy them to your project.

Usage
-----

* Import the header file to your view controller:
```objc
#import "CRMotionView.h"
```

* **Create an instance**
```objc
CRMotionView *motionView = [[CRMotionView alloc] initWithFrame:self.view.bounds];
```

* **Set an image...**
```objc
[motionView setImage:[UIImage imageNamed:@"Image"]];
```

* **... or set a generic view**
```objc
UIView *myView = [UIView alloc] init...
[motionView setContentView:myView];
```

* **Add to your view**
```objc
[self.view addSubview:motionView];
```

* Additionally, if you need to disable motion
```objc
[motionView setMotionEnabled:NO];
```

* **Full example:**
```objc
CRMotionView *motionView = [[CRMotionView alloc] initWithFrame:self.view.bounds];
[motionView setImage:[UIImage imageNamed:@"Image"]];
[self.view addSubview:motionView];
```

Example
----------

![CRMotionView-demo1](http://chroman.me/wp-content/uploads/2014/02/example1.gif)
<br/>
![CRMotionView-demo2](http://chroman.me/wp-content/uploads/2014/02/example2.gif)
<br/>
![CRMotionView-demo3](http://chroman.me/wp-content/uploads/2014/02/example3.gif)

Requirements
----------
* iOS 6.0 or higher
* ARC
* Core Motion

Bugs
----------
* UIScrollView's scroll bar indicator align not handled correctly in some cases.
* Device landscape orientation (Both, iPhone and iPad).

Contributing
----------
Anyone who would like to contribute to the project is more than welcome.

* Fork this repo
* Make your changes
* Submit a pull request

## License
CRMotionView is released under the MIT license. See
[LICENSE](https://github.com/chroman/CRMotionView/blob/master/LICENSE).

Contact
----------

Christian Roman
  
[http://chroman.me][1]

[chroman16@gmail.com][2]

[@chroman][3] 

  [1]: http://chroman.me
  [2]: mailto:chroman16@gmail.com
  [3]: http://twitter.com/chroman
  [4]: https://itunes.apple.com/us/app/paper-stories-from-facebook/id794163692?mt=8
