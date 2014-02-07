CRMotionView
=======================
Custom motion photo viewer inspired by [Facebook Paper][4].

![CRMotionView-main](http://chroman.me/wp-content/uploads/2014/02/main2.png)

Usage
-----

* Add the dependency to your Podfile:
```ruby
platform :ios
pod 'CRMotionView'
...
```

* Run `pod install` to install the dependencies.

* Import the header file wherever you want to use:
```objc
#import "CRMotionView.h"
```

* **Create an instance**
```objc
CRMotionView *motionView = [[CRMotionView alloc] initWithFrame:self.view.bounds];
```

* **Set the image**
```objc
[motionView setImage:[UIImage imageNamed:@"Image"]];
```

* Add to your view
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

![CRMotionView-demo1](http://chroman.me/wp-content/uploads/2014/02/demo1.gif)
![CRMotionView-demo2](http://chroman.me/wp-content/uploads/2014/02/demo2.gif)


TODO
----------
* UIScrollView horizontal scroll bar (Working on it).
* Behaviour similarly to Facebook paper app.

Requirements
----------
* iOS 6.0 or higher
* ARC

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