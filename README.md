# This One Weird Trick for Making Interesting UI.

---

## Matt Gillingham
- CTO at Eventacular
- Co-Organizer of Tokyo iOS Meetup
- @gillygize

---

```swift
class RelativePositionView : UIView 
```

---

```swift
  func setupView() {
    let panGesture = UIPanGestureRecognizer(
        target: self,
        action: Selector("panGestureRecognized:")
    )
    self.addGestureRecognizer(panGesture)
  }
```

---

```swift
  func panGestureRecognized(panGesture:UIPanGestureRecognizer) {
    let touchPosition = panGesture.locationInView(self)
    let relativePosition = relativePositionForPoint(touchPosition, rect:self.bounds)

    switch(panGesture.state) {
      case .Began:
        self.delegate?.relativePositionView(self,
         didBeginMovingToRelativePosition: relativePosition,
         velocity: panGesture.velocityInView(self)
        )
        break;
      case .Changed:
        self.delegate?.relativePositionView(self,
         didMoveToRelativePosition: relativePosition,
         velocity: panGesture.velocityInView(self)
        )
        break;
      case .Ended:
        self.delegate?.relativePositionView(self,
         didEndMovingToRelativePosition: relativePosition,
         velocity:panGesture.velocityInView(self)
        )
        break;
      default:
        break;
    }
  }
```

---

```swift
  private func relativePositionForPoint(point:CGPoint, rect:CGRect) -> CGPoint {
    return CGPoint(
      x: min(0.999999999, max(point.x / rect.size.width, 0.000000001)),
      y: min(0.999999999, max(point.y / rect.size.height, 0.0000000001))
    )
  }
```

---

```swift
@objc protocol RelativePositionViewDelegate {
  func relativePositionView(
    relativePositionView:RelativePositionView, didBeginMovingToRelativePosition position:CGPoint,
    velocity:CGPoint
  )
  func relativePositionView(
    relativePositionView:RelativePositionView,
    didEndMovingToRelativePosition position:CGPoint,
    velocity:CGPoint
  )
  func relativePositionView(
    relativePositionView:RelativePositionView,
    didMoveToRelativePosition position:CGPoint,
    velocity:CGPoint
  )
}
```

---

# Show Example

---


```swift
  var displayView : UIView

  func relativePositionView(
   relativePositionView:RelativePositionView,
   didMoveToRelativePosition position:CGPoint,
   velocity:CGPoint) {
    displayView.frame.origin.x = self.view.bounds.width * position.x
  }
```

---

# Show Example

---

```swift
  var displayView : UIView

  func relativePositionView(
   relativePositionView:RelativePositionView,
   didMoveToRelativePosition position:CGPoint,
   velocity:CGPoint) {
    displayView.frame.origin.x = self.view.bounds.width * position.x -
     displayView.bounds.size.width * position.x
  }
```

---

# Show example

---

## UIView properties have range from 0 to 1 (eg. alpha)

---

```swift
  func relativePositionView(
   relativePositionView:RelativePositionView,
   didMoveToRelativePosition position:CGPoint,
   velocity:CGPoint) {
    displayView.frame.origin.x = self.view.bounds.width * position.x -
     displayView.bounds.size.width * position.x
    displayView.alpha = position.x
  }
```

---

# Show Example

---

## UIView also have a transform property

Change:

- position (translate)
- scale
- rotation

---

```swift
  func relativePositionView(
   relativePositionView:RelativePositionView,
   didMoveToRelativePosition position:CGPoint,
   velocity:CGPoint) {
    displayView.frame.origin.x = self.view.bounds.width * position.x - 
     displayView.bounds.size.width * position.x
    displayView.transform = CGAffineTransformMakeScale(position.x, position.x)
  }
```

---

# Show Example

---

```swift
  func relativePositionView(
  relativePositionView:RelativePositionView,
  didMoveToRelativePosition position:CGPoint,
  velocity:CGPoint) {
    displayView.transform = CGAffineTransformTranslate(
      CGAffineTransformIdentity,
      self.view.bounds.width * position.x - 100 * position.x,
      0
    )
    displayView.transform = CGAffineTransformScale(displayView.transform, position.x, position.x)
    displayView.transform = CGAffineTransformRotate(displayView.transform, position.y * CGFloat(M_2_PI))
  }
  
```

---

# Show Example

---

There is also `CALayer` property which provides even more possibilities.

---

```swift
  func applyDisplayViews(f:(Int, UIView)->()) {
    for (index, displayView) in displayViews.enumerate() {
      f(index, displayView)
    }
  }
```

---

```swift
  func relativePositionView(
   relativePositionView:RelativePositionView,
   didBeginMovingToRelativePosition position:CGPoint,
   velocity:CGPoint) {
    UIView.animateWithDuration(0.2) {
      self.applyDisplayViews() { _, displayView in
        let difference = (self.view.frame.size.width - abs(displayView.frame.origin.x - self.view.frame.size.width * position.x)) / 10
        displayView.frame.origin.y = 200 - difference
      }
    }
  }

  func relativePositionView(
  relativePositionView:RelativePositionView,
  didEndMovingToRelativePosition position:CGPoint,
  velocity:CGPoint) {
    UIView.animateWithDuration(0.2) {
      self.applyDisplayViews() { index, displayView in
        displayView.frame = CGRect(x: 20 * index + 20 * index + 20, y: 200, width: 20, height: 20)
      }
    }
  }

  func relativePositionView(
   relativePositionView:RelativePositionView,
   didMoveToRelativePosition position:CGPoint,
   velocity:CGPoint) {
    applyDisplayViews() { _, displayView in
      let difference = (self.view.frame.size.width - abs(displayView.frame.origin.x - self.view.frame.size.width * position.x)) / 10
      displayView.frame.origin.y = 200 - difference
    }
  }
```

---

# Show Example

---

```swift
  func relativePositionView(
   relativePositionView:RelativePositionView,
   didBeginMovingToRelativePosition position:CGPoint,
   velocity:CGPoint) {
    UIView.animateWithDuration(0.2) {
      self.applyDisplayViews() { _, displayView in
        let differenceBetweenPositionAndFrame = abs(displayView.frame.origin.x - self.view.frame.size.width * position.x)
        let difference = (self.view.frame.size.width - differenceBetweenPositionAndFrame) / 10
        let adjustment = 1.0 - differenceBetweenPositionAndFrame/self.view.frame.size.width
        displayView.transform = CGAffineTransformMakeScale(adjustment,adjustment)
        displayView.transform = CGAffineTransformTranslate(displayView.transform, 0, -difference)
        displayView.alpha = adjustment
      }
    }
  }

  func relativePositionView(
   relativePositionView:RelativePositionView,
   didEndMovingToRelativePosition position:CGPoint,
   velocity:CGPoint) {
    UIView.animateWithDuration(0.2) {
      self.applyDisplayViews() { index, displayView in
        displayView.transform = CGAffineTransformIdentity
        displayView.alpha = 1.0
      }
    }
  }

  func relativePositionView(
   relativePositionView:RelativePositionView,
   didMoveToRelativePosition position:CGPoint,
   velocity:CGPoint) {
    applyDisplayViews() { _, displayView in
      let differenceBetweenPositionAndFrame = abs(displayView.frame.origin.x - self.view.frame.size.width * position.x)
      let difference = (self.view.frame.size.width - differenceBetweenPositionAndFrame) / 10
      let adjustment = 1.0 - differenceBetweenPositionAndFrame/self.view.frame.size.width
      displayView.transform = CGAffineTransformMakeScale(adjustment,adjustment)
      displayView.transform = CGAffineTransformTranslate(displayView.transform, 0, -difference)
      displayView.alpha = adjustment
    }
  }
```

---

# Show Example

---

## It is also possible to interactive with other views.

---

```swift
  func relativePositionView(
   relativePositionView:RelativePositionView,
   didMoveToRelativePosition position:CGPoint,
   velocity:CGPoint) {
    textView.contentOffset.y = textView.contentSize.height * position.x
  }

  func scrollViewDidScroll(scrollView: UIScrollView) {
    let percentageOfScrollView = scrollView.contentOffset.y / scrollView.contentSize.height * relativePositionView.bounds.size.width
    let positionInPositionView = percentageOfScrollView * relativePositionView.bounds.size.width
    let centerPosition = self.indicatorView.bounds.width / 2
    self.indicatorView.frame.origin.x = positionInPositionView - centerPosition
  }
```

---

# Show Example

---

- Most of these effects are done without animation
- They are simple functions, so debugging is easy and they work reliably
- Direct manipulation is a powerful experience
- If you are doing a lot of work, this may be too slow

