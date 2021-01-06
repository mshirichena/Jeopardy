//
//  SelectedClueViewController.swift
//  Jeopardy
//
//  Created by Christian Shirichena on 1/2/21.
//

import UIKit

class SelectedClueViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var okButton: UIButton!
    // Sending note to secon storyboard, I have declare an instance of JeopardyClues object in 2nd VC
    var clue: ClueAPI?
    // to enable save button delegation
    var delegate: ClueCreationDelegate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        okButton.alpha = 0
        // instantiates use of two textfields on second storyboard
        questionTextField.text = clue?.question
        contentTextView.text = clue?.answer
    }
    //MARK:- Delegate calls
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 1) {
            self.okButton.alpha = 1
        }
    }
    
    func textViewDidEndEditing(_ sender: UITextView) {
        UIView.animate(withDuration: 1) {
            self.okButton.alpha = 0
        }
    }
    
    //MARK:- Target Actions
    // save button for saving clues on TV
    @IBAction func textFieldDone(_ sender: UITextField) {
    }
    
    
    @IBAction func okButtonPressed(_ sender: UIButton) {
        if contentTextView.isFirstResponder {
            contentTextView.resignFirstResponder()
        }
    }
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if let question = questionTextField.text, let content = contentTextView.text {
        let clues = CDclue.createOrUpdate(question: question, content: content)
            print("Update my: \(clues)")   //*** Bug #2
        delegate?.clueReturned(clue: clue, sender: self)
    }
    dismiss(animated: true, completion: nil)
}
}


