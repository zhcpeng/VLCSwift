//
//  FileListController.swift
//  VLCSwift
//
//  Created by ZhangChunpeng on 16/8/12.
//  Copyright © 2016年 zhcpeng. All rights reserved.
//

import UIKit

class FileListController: UITableViewController {
    
    // MARK: - Property
	fileprivate lazy var itemList: [String] = []
    fileprivate lazy var fileFullPathList: [String] = []
    fileprivate lazy var fileManager : FileManager = FileManager.default
   

    // MARK: - LifeCycle
	override func viewDidLoad() {
		super.viewDidLoad()

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
		self.updateFileList()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    
    fileprivate func updateFileList() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        do {
            itemList = try fileManager.contentsOfDirectory(atPath: path)
            fileFullPathList.removeAll()
            for fileName in itemList {
                fileFullPathList.append((path + "/" + fileName))
            }
            self.tableView.reloadData()
        } catch {
            
        }
    }
    

	// MARK: - Table view data source
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemList.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
		cell.textLabel?.text = itemList[indexPath.row]

		return cell
	}

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = VLCPlayerViewController.sharePlayer
        vc.path = fileFullPathList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
