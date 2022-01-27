//
//  StartViewController.swift
//  Demo0805
//
//  Created by 林思甯 on 2021/8/6.
//

import UIKit

class StartViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    
    
    let category = ["Any Category","General Knowledge","Entertainment: Books","Entertainment: Films","Entertainment: Music","Entertainment: Musicals & Theatres","Entertainment: Television","Entertainment: Video Games","Entertainment: Board Games","Science & Nature","Science : Computers","Science: Mathematics","Mythology","Sports","Geography","History","Politics","Art","Celebrities","Animals","Vehicles","Entertainment: Comics","Science: Gadgets","Entertainment: Japanese Anime & Manga","Entertainment: Cartoon & Animations"]
    let difficulty = ["Any Difficulty","Easy","Medium","Hard"]
    
    let categoryPickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    let difficultyPickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoryText: UITextField!
    @IBOutlet weak var difficultyText: UITextField!
    @IBOutlet weak var startButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        startButton.layer.cornerRadius = 10
        
        nameTextField.delegate = self
        categoryText.delegate = self
        categoryText.inputView = categoryPickerView
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        
        difficultyText.delegate = self
        difficultyText.inputView = difficultyPickerView
        difficultyPickerView.delegate = self
        difficultyPickerView.dataSource = self
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDone))
        toolbar.items = [flexibleSpace,doneButton]
        toolbar.sizeToFit()
        categoryText.inputAccessoryView = toolbar
        difficultyText.inputAccessoryView = toolbar
    }
    
    @objc private func didTapDone() {
        nameTextField.resignFirstResponder()
        categoryText.resignFirstResponder()
        difficultyText.resignFirstResponder()
    }
    
    // UIPickerView 有幾列可以選擇
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // UIPickerView 各列有多少行資料
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryPickerView {
            return category.count
        } else if pickerView == difficultyPickerView {
            return difficulty.count
        }
        return 0
    }
    // UIPickerView 每個選項顯示的資料
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == categoryPickerView {
            return category[row]
        } else if pickerView == difficultyPickerView{
            return difficulty[row]
        }
        return nil
        
    }
    // UIPickerView 改變選擇後執行的動作
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryPickerView {
            categoryText.text = category[row]
            
        } else if pickerView == difficultyPickerView{
            difficultyText.text = difficulty[row]
        }
        
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "WARNING", message: "This value cannot be empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBSegueAction func passData(_ coder: NSCoder) -> QuestionsViewController? {
        
        let controller = QuestionsViewController(coder: coder)
        let category = categoryText.text
        let difficulty = difficultyText.text
        let name = nameTextField.text

        controller?.category = passCategory(passCategory: category!)
        controller?.difficulty = passDifficulty(passDifficulty: difficulty!)
        controller?.playerName = passPlayerName(name: name!)
        
        return controller
    }
    
    @IBAction func confirmData(_ sender: Any) {
        
        if categoryText.text == "" || difficultyText.text == "" || nameTextField.text == "" {
            showAlert()
        }
        self.performSegue(withIdentifier: "passData", sender: self)
    }
    
    
    
}
