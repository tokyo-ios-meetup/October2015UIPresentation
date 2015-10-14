//
//  ViewController.swift
//  October2015
//
//  Created by Matt on 10/14/15.
//  Copyright © 2015 Matthew Gillingham. All rights reserved.
//

import UIKit

class Example2ViewController: UIViewController, RelativePositionViewDelegate {
  lazy var relativePositionView : RelativePositionView = {
    let view = RelativePositionView(frame:
      CGRectOffset(
        CGRectInset(self.view.bounds, 20, self.view.bounds.height / 3),
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
  lazy var displayView : UIView = {
    let view = UIView(frame:CGRect(x: 20, y: 100, width: 100, height: 100))
    view.backgroundColor = UIColor.blueColor()
    return view
  }()

  override func loadView() {
    super.loadView()
    view.backgroundColor = UIColor.whiteColor()
    self.view.addSubview(relativePositionView)
    self.view.addSubview(nextButton)
    self.view.addSubview(displayView)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  func relativePositionView(relativePositionView:RelativePositionView, didBeginMovingToRelativePosition position:CGPoint, velocity:CGPoint) {
  }

  func relativePositionView(relativePositionView:RelativePositionView, didEndMovingToRelativePosition position:CGPoint, velocity:CGPoint) {
  }

  func relativePositionView(relativePositionView:RelativePositionView, didMoveToRelativePosition position:CGPoint, velocity:CGPoint) {
    displayView.frame.origin.x = (self.view.bounds.width * position.x - displayView.bounds.size.width * position.x)
    displayView.alpha = position.x
  }
  
  func nextButtonPressed(button:UIButton) {
    self.navigationController?.pushViewController(Example3ViewController(), animated: true)
  }
}

