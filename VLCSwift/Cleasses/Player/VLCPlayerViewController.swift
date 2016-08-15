//
//  VLCPlayerViewController.swift
//  VLCSwift
//
//  Created by ZhangChunpeng on 16/8/12.
//  Copyright © 2016年 zhcpeng. All rights reserved.
//

import UIKit

class VLCPlayerViewController: UIViewController {
	// MARK: - Property
	var path: String = ""

	private lazy var backBubtton: UIButton = {
		let button = UIButton.init(type: .Custom)
//		button.setTitle("返回", forState: .Normal)
//		button.titleLabel?.font = UIFont.systemFontOfSize(14)
        button.setImage(UIImage.init(named: "vlc_back"), forState: .Normal)
		button.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (_) in
			self.navigationController?.popViewControllerAnimated(true)
		})
		return button
	}()

	private lazy var player: VLCMediaPlayer = {
		let player = VLCMediaPlayer()
		player.drawable = self.playerView
		return player
	}()
    
    private lazy var playerView : UIView = UIView()
    
    private var isPlaying : Bool = true

	// MARK: - LifeCycle
	static let sharePlayer: VLCPlayerViewController = {
		return VLCPlayerViewController()
	}()

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
        
        self.view.addSubview(playerView)
        playerView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }

        self.view.addSubview(backBubtton)
        backBubtton.snp_makeConstraints { (make) in
            make.top.left.equalTo(self.view).offset(30)
            make.left.equalTo(self.view).offset(15)
        }
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(control))
        self.playerView.addGestureRecognizer(tap)
    
    }

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		self.navigationController?.navigationBarHidden = true

		if !path.isEmpty {
			let media = VLCMedia.init(path: path)
			player.media = media
			player.play()
		}
	}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)

		self.navigationController?.navigationBarHidden = false
        self.player.stop()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    
    func control()  {
        if isPlaying {
            self.player.pause()
        } else {
            self.player.play()
        }
        
        self.backBubtton.hidden = false
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            self.backBubtton.hidden = true
        })
    }

}
