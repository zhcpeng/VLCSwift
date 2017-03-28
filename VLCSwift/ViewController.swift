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

	fileprivate lazy var goNextButton: UIButton = {
		let button = UIButton.init(type: .custom)
//		button.setTitle("GoNext!", forState: .Normal)
//		button.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
		button.reactive.controlEvents(.touchUpInside).observeValues({ [weak self](_) in
			let vc = FileListController()
			self?.navigationController?.pushViewController(vc, animated: true)
		})
		return button
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

		self.view.addSubview(goNextButton)
		goNextButton.snp.makeConstraints { (make) in
			make.left.bottom.right.equalTo(self.view)
			make.height.equalTo(50)
		}

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
//            self.loginWithTouchID()
            self.navigationController?.pushViewController(FileListController(), animated: true)
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
		if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error)
		{
			context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success: Bool, evalPolicyError: NSError?) -> () in
				DispatchQueue.main.async(execute: {
//                    () in // 放到主线程执行，这里特别重要
					if success {
						// 调用成功后你想做的事情
                        let vc = FileListController()
                        self.navigationController?.pushViewController(vc, animated: true)
					} else {
						// If authentication failed then show a message to the console with a short description.
						// In case that the error is a user fallback, then show the password alert view.
						print(evalPolicyError?.localizedDescription ?? "0")
					}
				})
			} as! (Bool, Error?) -> ())
		}
	}

}

