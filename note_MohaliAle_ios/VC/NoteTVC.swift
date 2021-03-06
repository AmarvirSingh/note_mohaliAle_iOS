//
//  NoteTVC.swift
//  note_MohaliAle_ios
//
//  Created by simranPreet KAur on 02/02/21.
//  Copyright © 2021 Amarvir Mac. All rights reserved.
//

import UIKit
import CoreData

class NoteTVC: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var TrashBTN: UIBarButtonItem!
    @IBOutlet weak var moveBTN: UIBarButtonItem!
   
    
  var editEnabled: Bool = false
  

    // CREATE notes
    var notes = [Note]()
    var selectedCategory: Category?
    {
        didSet {
            loadNotes()
        }
    }
    
    // create context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let searchController = UISearchController(searchResultsController: nil)

    
    override func viewDidLoad() {
        super.viewDidLoad()

//        showSearchBar()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self./Users/user191496/Documents/NoteFolderApp-Demo/NoteFolder App Demo/Base.lproj/LaunchScreen.storyboardnavigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }

    
    // define the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TV_cell", for: indexPath)
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.noteTitle
        cell.textLabel?.textColor = .lightGray
        cell.detailTextLabel?.text = note.noteMessage
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .darkGray
        cell.selectedBackgroundView = backgroundView
        
    

        return cell
    }
    
    //MARK: loading notes function
    func loadNotes(predicate: NSPredicate? = nil) {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        let CategoryPredicate = NSPredicate(format: "parentCategory.catName = %@", selectedCategory!.catName!)
        //request.sortDescriptors = [NSSortDescriptor(key: "noteTitle", ascending: true)]
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [CategoryPredicate, additionalPredicate])
        } else {
            request.predicate = CategoryPredicate
        }
        
        do {
            notes = try context.fetch(request)
        } catch {
            print("Error loading notes \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
    
    //Mark: -deletion of notes
    /// deleting the  notes from context

    /// - Parameter note: note defined in Core Data
    func deleteNote(note: Note) {
        context.delete(note)
    }

    
    
    func updateNote(with title: String, with message: String){
        notes = [] //note array empty makes easiest to rewrite notes
        let newNote = Note(context: context)
        newNote.noteTitle = title
        newNote.noteMessage = message
        newNote.parentCategory =  selectedCategory
        
        saveNotes()
        
        loadNotes()
        
        
    }
    
    
    func updateNote(title: String, message: String, img: Data, address: String, lat: Double, long: Double ){ //Error retified in this line
        notes = [] //note array empty makes easiest to rewrite notes
        let newNote = Note(context: context)
        newNote.noteTitle = title
        newNote.noteImage = img
        newNote.noteLocAddress = address
        newNote.noteLat = lat
        newNote.noteLong = long
        
        newNote.parentCategory = selectedCategory
        
        saveNotes()
        
        loadNotes()
        
    }
    
    /*
    /// update note in core data
    /// - Parameter title: note's title
    func updateNote(with title: String) {
        notes = [] //note array empty makes easiest to rewrite notes
        let newNote = Note(context: context)
        newNote.noteTitle = title
        newNote.parentCategory = selectedCategory
        saveNotes()
        loadNotes()
    }
    */
    // Saving the notes into core data
    func saveNotes() {
        do {
            try context.save()
        } catch {
            print("Error saving the notes \(error.localizedDescription)")
        }
    }
    
    //Trash Button Functionality
    @IBAction func trashBTNPress(_ sender: UIBarButtonItem) {
        if let indexPaths = tableView.indexPathsForSelectedRows {
            let rows = (indexPaths.map {$0.row}).sorted(by: >)
            
            let _ = rows.map {deleteNote(note: notes[$0])}
            let _ = rows.map {notes.remove(at: $0)}
            
            tableView.reloadData()
            saveNotes()
        }
    }
    
    
    ///when edit button is pressed below functionaly will be implemented
    /// - Parameter Sender : Bar button
    @IBAction func editBTNPress(_ sender: UIBarButtonItem) {
        editEnabled = !editEnabled
       
        TrashBTN.isEnabled = true
        moveBTN.isEnabled = true
        
        tableView.setEditing(editEnabled, animated: true)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        /**/
        if let destination = segue.destination as? NotesVC {
            destination.noteTVCInstance = self
            
            if let cell = sender as? UITableViewCell {
                if let index = tableView.indexPath(for: cell)?.row {
                    destination.selectedNotes = notes[index]
                }
            }

       
        }
   
    //MARK: - showing  search bar function
    func showSearchBar() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Note"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.searchTextField.textColor = .lightGray
    }



}
    


}
