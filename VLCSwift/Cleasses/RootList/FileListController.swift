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
	private lazy var itemList: [String] = [String]()
    private lazy var fileFullPathList : [String] = [String]()
    
    private lazy var fileManager : NSFileManager = {
        return NSFileManager.defaultManager()
    }()
    
    

    // MARK: - LifeCycle
	override func viewDidLoad() {
		super.viewDidLoad()

        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
		self.updateFileList()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    
    private func updateFileList() {
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        do {
            itemList = try fileManager.contentsOfDirectoryAtPath(path)
            fileFullPathList.removeAll()
            for fileName in itemList {
                fileFullPathList.append((path + "/" + fileName))
            }
            self.tableView.reloadData()
        } catch {
            
        }
    }
    

	// MARK: - Table view data source

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemList.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
		cell.textLabel?.text = itemList[indexPath.row]

		return cell
	}

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = VLCPlayerViewController.sharePlayer
        vc.path = fileFullPathList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
