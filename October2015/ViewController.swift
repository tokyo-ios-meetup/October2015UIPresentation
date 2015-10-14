//
//  ViewController.swift
//  October2015
//
//  Created by Matt on 10/14/15.
//  Copyright © 2015 Matthew Gillingham. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet var nextButton : UIButton?

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  @IBAction func nextButtonPressed(button:UIButton) {
    self.navigationController?.pushViewController(Example0ViewController(), animated: true)
  }
}

