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

	fileprivate lazy var backBubtton: UIButton = {
		let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "vlc_back"), for: UIControlState())
		button.reactive.controlEvents(.touchUpInside).observeValues({ [weak self](_) in
			_ = self?.navigationController?.popViewController(animated: true)
		})
		return button
	}()

	fileprivate lazy var player: VLCMediaPlayer = {
		let player = VLCMediaPlayer()
		player.drawable = self.playerView
		return player
	}()
    
    fileprivate lazy var playerView : UIView = UIView()
    
    fileprivate var isPlaying : Bool = true

	// MARK: - LifeCycle
	static let sharePlayer: VLCPlayerViewController = {
		return VLCPlayerViewController()
	}()

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
        
        self.view.addSubview(playerView)
        playerView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }

        self.view.addSubview(backBubtton)
        backBubtton.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.view).offset(30)
            make.left.equalTo(self.view).offset(15)
        }
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(control))
        self.playerView.addGestureRecognizer(tap)
    
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		self.navigationController?.isNavigationBarHidden = true

		if !path.isEmpty {
			let media = VLCMedia.init(path: path)
			player.media = media
			player.play()
		}
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		self.navigationController?.isNavigationBarHidden = false
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
        
        self.backBubtton.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            self.backBubtton.isHidden = true
        })
    }

}
