//
//  ViewController.swift
//  Jeopardy
//
//  Created by Christian Shirichena on 1/2/21.
//

import UIKit
import CoreData


//to save my new clues, I create a protocol
protocol ClueCreationDelegate {
    func clueReturned(clue: ClueAPI?, sender: UIViewController)
}

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ClueCreationDelegate {
    func clueReturned(clue: ClueAPI?, sender: UIViewController) {
        
    }
    

    @IBOutlet weak var addNewClue: UIButton!
    @IBOutlet weak var cluesTableView: UITableView!
    
    // declaring instance variable JeopardyClue
    var clues: [ClueAPI] = [ClueAPI]()
    // instance variable that allows to select new clues
    var selectedClues: ClueAPI?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readCoreData()
        loadRemoteData()
    }
    override func viewWillAppear(_ animated: Bool) {
        cluesTableView.reloadData()
    }
    // get some data from API
    func fetchJeopardyCluesData() -> String {
          let urlString = "https://jservice.io/api/random?count=5"
//        print("I have my : \(urlString)")
          return urlString
      }
    
    private func loadRemoteData(){
        // Load API data 2 clues
        guard let url = URL(string: self.fetchJeopardyCluesData()) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {return}
            guard let clues = try? JSONDecoder().decode([ClueAPI].self, from: data) else {
                print("couldn't decode")
                return
            }
//                print("Found data: \(clues)")
            self.clues = clues
            DispatchQueue.main.async {
                self.cluesTableView.reloadData()
            }
        }.resume()
//        if  let url = URL(string: "https://jservice.io/api/random?count=10") {
//            URLSession.shared.dataTask(with: url) { (data, response, error) in if let error = error {
//
//            }
//
//        }
//        let objects = [String]: [Any]()
//        objects.forEach {one in
//            if let title = one["title"] as? String, let content = one["content"] as? String {
//                CDNote.createOrUpdate(id: UUID(), title: title, content: content, createdDate: Date())
//            }
//        }
//        // add to coredata
        // display in TV
        // edit that data in second view controller
        // return updated data to this view controller
    }
    
    // Data persistence
     private func readCoreData() {
        let request: NSFetchRequest<Clue> = Clue.fetchRequest()
        print("I have my: \(request)") //******* Bug #1
        do {
            let clues = try AppDelegate.viewContext.fetch(request)
        } catch {
            print("Error getting clues")
        }
    }
    
    //MARK:- Target Actions
    @IBAction func addNewClueButtonPressed(_ sender: UIButton) {
        //every time Add New Clue button is pressed, segue to second storyboard
        performSegue(withIdentifier: "show clue", sender: self)
    }
    
    //MARK: - TableViews:- Providing numbers of Rows and Sections
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // number of rows is now the number of clues in JeopardyClue object
        return clues.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Retrieving cell objects
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CluesTableViewCell
        let clueList = self.clues[indexPath.row]
        // Configuring custom cell views
        // Changed cell views to reflect new object-JeopardyClue
        cell.cellTopLabel.text = "Hello"
        cell.cellContentLabel.text = clueList.question
        //Returning cell to tableview.
        return cell
    }
    // Tells the delegate a row is selected.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedClues = clues[indexPath.row]
        performSegue(withIdentifier: "show clue", sender: self)
    }
    //MARK:- Delegate Calls
    func clueReturned(clue: ClueAPI?, sender: Clue ) {
        // Optional Binding to unwrapp clue? so as to create index for updating same data in app
        clues.removeAll()
        //readCoreData()
        cluesTableView.reloadData()
        if let clue = clue {
            if let index = clues.firstIndex(where: { one in one.question == clue.question
            }) {
                self.clues[index] = clue
                // reloading same rows to updata data
                cluesTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .left)
            } else {
                clues.append(contentsOf: clues)
                cluesTableView.insertRows(at: [IndexPath(row: clues.count - 1, section: 0)], with: .fade)
            }
        }
    }
    
    // Once a new clue is selected I send it to the second viewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // check for correct segue first before connecting to 2nd VC
        if segue.identifier == "show clue", let destination = segue.destination as? SelectedClueViewController {
            // clue is called on 2nd viewController
            destination.clue = selectedClues
            selectedClues = nil
            // delegate enables save button(2nd storyboard) to save clues
            destination.delegate = self
        }
    }
}

