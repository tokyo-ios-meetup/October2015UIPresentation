//
//  RelativePositionView.swift
//  eventacular
//
//  Created by Matt on 7/20/15.
//  Copyright (c) 2015 Eventacular. All rights reserved.
//

import UIKit

@objc protocol RelativePositionViewDelegate {
  func relativePositionView(relativePositionView:RelativePositionView, didBeginMovingToRelativePosition position:CGPoint, velocity:CGPoint)
  func relativePositionView(relativePositionView:RelativePositionView, didEndMovingToRelativePosition position:CGPoint, velocity:CGPoint)
  func relativePositionView(relativePositionView:RelativePositionView, didMoveToRelativePosition position:CGPoint, velocity:CGPoint)
}

class RelativePositionView : UIView {
  @IBOutlet var delegate : RelativePositionViewDelegate?

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    setupView()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  func setupView() {
    let panGesture = UIPanGestureRecognizer(target: self, action: Selector("panGestureRecognized:"))
    self.addGestureRecognizer(panGesture)
  }

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

  private func relativePositionForPoint(point:CGPoint, rect:CGRect) -> CGPoint {
    return CGPoint(
      x: min(0.999999999, max(point.x / rect.size.width, 0.000000001)),
      y: min(0.999999999, max(point.y / rect.size.height, 0.0000000001))
    )
  }
}
