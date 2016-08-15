//
//  ViewController.swift
//  VLCSwift
//
//  Created by ZhangChunpeng on 16/7/29.
//  Copyright © 2016年 zhcpeng. All rights reserved.
//

import UIKit

import LocalAuthentication

class ViewController: UIViewController {

	private lazy var goNextButton: UIButton = {
		let button = UIButton.init(type: .Custom)
//		button.setTitle("GoNext!", forState: .Normal)
//		button.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
		button.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (_) in
			let vc = FileListController()
			self.navigationController?.pushViewController(vc, animated: true)
		})
		return button
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

		self.view.addSubview(goNextButton)
		goNextButton.snp_makeConstraints { (make) in
			make.left.bottom.right.equalTo(self.view)
			make.height.equalTo(50)
		}

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            self.loginWithTouchID()
        })
        
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func loginWithTouchID() {
		// Get the local authentication context.
		let context = LAContext()
		// Declare a NSError variable.
		var error: NSError?
		// Set the reason string that will appear on the authentication alert.
		let reasonString = "请输入指纹"
		// Check if the device can evaluate the policy.
		if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error)
		{
			context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success: Bool, evalPolicyError: NSError?) -> Void in
				dispatch_async(dispatch_get_main_queue(), { () in // 放到主线程执行，这里特别重要
					if success {
						// 调用成功后你想做的事情
                        let vc = FileListController()
                        self.navigationController?.pushViewController(vc, animated: true)
					} else {
						// If authentication failed then show a message to the console with a short description.
						// In case that the error is a user fallback, then show the password alert view.
						print(evalPolicyError?.localizedDescription)
					}
				})
			})
		}
	}

}

