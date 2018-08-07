//
//  TagUserDataManager.swift
//  MentionApp
//
//  Created by Tam Pit Yaw on 7/8/18.
//

import UIKit
import SZMentionsSwift

class TagUser: CreateMention {
    var accountId: String = ""
    var name: String = ""
    var range: NSRange = NSMakeRange(0, 0)
    
    init(accountId: String, name: String) {
        self.accountId = accountId
        self.name = name
    }
    
    static func getTagUsers() -> [TagUser] {
        let tagUsers: [TagUser] = [
            TagUser(accountId: "1", name: "Kate Kathy"),
            TagUser(accountId: "2", name: "Tom Jackson"),
            TagUser(accountId: "3", name: "Jerry Harrison")
        ]
        return tagUsers
    }
}

class TagUserDataManager: NSObject, UITableViewDataSource, UITableViewDelegate {
    fileprivate var mentionListener: MentionListener?
    fileprivate var tagUsers: [TagUser] = TagUser.getTagUsers()
    fileprivate var filteredTagUsers: [TagUser] = []
    fileprivate var textView: UITextView?
    fileprivate var tableView: UITableView?
    fileprivate var filterString: String = ""
    
    init(textView: UITextView, tagUserTableView: UITableView, mentionListener: MentionListener?) {
        self.textView = textView
        self.tableView = tagUserTableView
        self.mentionListener = mentionListener
        self.tableView!.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
    }
    
    func filter(filterString: String) {
        self.filterString = filterString
        if !filterString.isEmpty {
            filteredTagUsers = tagUsers.filter() {
                if let type = ($0 as TagUser).name as String? {
                    return type.lowercased().contains(filterString.lowercased())
                } else {
                    return false
                }
            }
        } else {
            filteredTagUsers = tagUsers
        }
        tableView?.reloadData()
    }
    
    func getTotalTagUsers() -> Int {
        return filteredTagUsers.count
    }
    
    func getMentionListener() -> MentionListener? {
        return mentionListener
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTagUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tagUserCell = tableView.dequeueReusableCell(withIdentifier: "tagUserCell", for: indexPath)
        tagUserCell.textLabel?.text = filteredTagUsers[indexPath.row].name
        return tagUserCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1 {
            mentionListener?.addMention(filteredTagUsers[indexPath.row])
            //Force change text view
            mentionListener?.textViewDidChange(textView!)
        }
    }
}
