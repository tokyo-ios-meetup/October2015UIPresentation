//
//  ViewController.swift
//  October2015
//
//  Created by Matt on 10/14/15.
//  Copyright © 2015 Matthew Gillingham. All rights reserved.
//

import UIKit

class Example4ViewController: UIViewController, RelativePositionViewDelegate {
  lazy var relativePositionView : RelativePositionView = {
    let view = RelativePositionView(frame:
      CGRectOffset(
        CGRectInset(self.view.bounds, 0, self.view.bounds.height / 3),
        0,
        self.view.bounds.height/4 - 84
      )
    )
    view.backgroundColor = UIColor.redColor()
    view.delegate = self
    return view
  }()
  lazy var nextButton : UIButton =  {
    let button = UIButton(type: .System)
    button.addTarget(self, action: Selector("nextButtonPressed:"), forControlEvents: .TouchUpInside)
    button.setTitle("Next", forState: .Normal)
    button.frame = CGRect(x: 20, y: self.view.bounds.size.height - 64, width: self.view.bounds.size.width-40, height: 44.0)
    return button
  }()
  lazy var displayViews : [UIView] = {
    return (0...7).map() { i in
      let view = UIView(frame:CGRect(x: 20 * i + 20 * i + 20, y: 200, width: 20, height: 20))
      view.backgroundColor = UIColor.blueColor()
      return view
    }
  }()

  override func loadView() {
    super.loadView()
    view.backgroundColor = UIColor.whiteColor()
    self.view.addSubview(relativePositionView)
    self.view.addSubview(nextButton)
    for displayView in displayViews {
      self.view.addSubview(displayView)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  func applyDisplayViews(f:(Int, UIView)->()) {
    for (index, displayView) in displayViews.enumerate() {
      f(index, displayView)
    }
  }

  func relativePositionView(relativePositionView:RelativePositionView, didBeginMovingToRelativePosition position:CGPoint, velocity:CGPoint) {
    UIView.animateWithDuration(0.2) {
      self.applyDisplayViews() { _, displayView in
        let difference = (self.view.frame.size.width - abs(displayView.frame.origin.x - self.view.frame.size.width * position.x)) / 10
        displayView.frame.origin.y = 200 - difference
      }
    }
  }

  func relativePositionView(relativePositionView:RelativePositionView, didEndMovingToRelativePosition position:CGPoint, velocity:CGPoint) {
    UIView.animateWithDuration(0.2) {
      self.applyDisplayViews() { index, displayView in
        displayView.frame = CGRect(x: 20 * index + 20 * index + 20, y: 200, width: 20, height: 20)
      }
    }
  }

  func relativePositionView(relativePositionView:RelativePositionView, didMoveToRelativePosition position:CGPoint, velocity:CGPoint) {
    applyDisplayViews() { _, displayView in
      let difference = (self.view.frame.size.width - abs(displayView.frame.origin.x - self.view.frame.size.width * position.x)) / 10
      displayView.frame.origin.y = 200 - difference
    }
  }
  
  func nextButtonPressed(button:UIButton) {
    self.navigationController?.pushViewController(Example5ViewController(), animated: true)
  }
}

