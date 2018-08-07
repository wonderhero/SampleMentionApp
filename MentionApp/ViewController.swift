//
//  ViewController.swift
//  MentionApp
//
//  Created by Tam Pit Yaw on 7/8/18.
//

import UIKit
import SZMentionsSwift

class ViewController: UIViewController {
    @IBOutlet weak var textInput: UITextView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var tagUserTableView: UITableView!
    
    fileprivate var tagUserDataManager: TagUserDataManager?
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupViews()
    }

    func setupViews() {
        popupView.isHidden = true
        
        //Setup input text view
        textInput.isScrollEnabled = false
        textInput.textContainerInset = UIEdgeInsets(top: 11, left: 15, bottom: 11, right: 47)
        textInput.layer.cornerRadius = 20
        textInput.layer.borderWidth = 1
        textInput.layer.borderColor = UIColor.lightGray.cgColor
        textInput.text = "Type Message"
        textInput.textColor = .lightGray
        
        //Setup mention listener and assign it to tag user table view and input text view
        struct Attribute: AttributeContainer {
            var name: String
            var value: NSObject
        }
        
        let mentionTextAttributes: [AttributeContainer] = [
            Attribute(name: NSAttributedStringKey.foregroundColor.rawValue, value: UIColor.blue),
            Attribute(name: NSAttributedStringKey.font.rawValue, value: UIFont.preferredFont(forTextStyle: .body))
        ]
        let defaultTextAttributes: [AttributeContainer] = [
            Attribute(name: NSAttributedStringKey.foregroundColor.rawValue, value: UIColor.darkText),
            Attribute(name: NSAttributedStringKey.font.rawValue, value: UIFont.preferredFont(forTextStyle: .body))
        ]
        
        let mentionsListener = MentionListener(mentionTextView: textInput, delegate: self, mentionTextAttributes: mentionTextAttributes, defaultTextAttributes: defaultTextAttributes, spaceAfterMention: true, searchSpaces: true, hideMentions: {
            self.popupView.isHidden = true
        }, didHandleMentionOnReturn: { () -> Bool in
            return false
        }) { (mentionsString, trigger) in
            self.tagUserDataManager!.filter(filterString: mentionsString)
            if self.tagUserDataManager!.getTotalTagUsers() > 0 {
                self.popupView.isHidden = false
            } else {
                self.popupView.isHidden = true
            }
        }
        
        tagUserDataManager = TagUserDataManager(textView: textInput, tagUserTableView: tagUserTableView, mentionListener: mentionsListener)
        tagUserTableView.delegate = tagUserDataManager
        tagUserTableView.dataSource = tagUserDataManager
    }

}

extension ViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("TextView begin editing")
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = .darkText
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("TextView end editing")
        if textView.text.isEmpty {
            textInput.text = "Type Message"
            textInput.textColor = .lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print("TextView did change")
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        print("TextView change text in")
        return true
    }
}

