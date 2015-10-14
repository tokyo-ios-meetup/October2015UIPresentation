//
//  ViewController.swift
//  October2015
//
//  Created by Matt on 10/14/15.
//  Copyright © 2015 Matthew Gillingham. All rights reserved.
//

import UIKit

class Example0ViewController: UIViewController, RelativePositionViewDelegate {
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
  lazy var xLabel: UILabel = {
    let view = UILabel(frame: CGRect(
      x: CGRectGetMidX(self.view.bounds) - 50,
      y: 100, width: 100, height: 44)
    )
    return view
  }()
  lazy var yLabel: UILabel = {
    let view = UILabel(frame: CGRect(
      x: CGRectGetMidX(self.view.bounds) - 50,
      y: self.xLabel.frame.origin.y + 44, width: 100, height: 44)
    )
    return view
  }()

  private func updateLabels(x:CGFloat, y:CGFloat) {
    xLabel.text = "\(x)"
    yLabel.text = "\(y)"
  }

  override func loadView() {
    super.loadView()
    view.backgroundColor = UIColor.whiteColor()
    self.view.addSubview(relativePositionView)
    self.view.addSubview(nextButton)
    self.view.addSubview(xLabel)
    self.view.addSubview(yLabel)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  func relativePositionView(relativePositionView:RelativePositionView, didBeginMovingToRelativePosition position:CGPoint, velocity:CGPoint) {
    updateLabels(position.x, y: position.y)
  }

  func relativePositionView(relativePositionView:RelativePositionView, didEndMovingToRelativePosition position:CGPoint, velocity:CGPoint) {
    updateLabels(position.x, y: position.y)
  }

  func relativePositionView(relativePositionView:RelativePositionView, didMoveToRelativePosition position:CGPoint, velocity:CGPoint) {
    updateLabels(position.x, y: position.y)
  }

  func nextButtonPressed(button:UIButton) {
    self.navigationController?.pushViewController(Example1ViewController(), animated: true)
  }
}
