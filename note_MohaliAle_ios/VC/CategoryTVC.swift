//
//  CategoryTVC.swift
//  note_MohaliAle_ios
//
//  Created by Amarvir Mac on 02/02/21.
//  Copyright © 2021 Amarvir Mac. All rights reserved.
//

import UIKit
import  CoreData
class CategoryTVC: UITableViewController {

    
    var category = [Category]()
   
   // context
   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
// oh scan ho jaan do mei shee kr k ayay
        
        loadCategory()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK:  ADD category button IB action
    @IBAction func addCategory(_ sender: UIBarButtonItem)
    {
        var textField = UITextField()
        let alert = UIAlertController(title: "ADD NEW CATEGORY ", message: "give name ", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "ADD", style: .default)
        {(action) in
            
            let categoryNames = self.category.map{$0.catName}
            guard !categoryNames.contains(textField.text) else {self.showAlert(); return}
            let newCategory = Category(context: self.context)
            newCategory.catName = textField.text!
            self.category.append(newCategory)
            self.saveCategory()
        }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            // chnge the color of cancel button
            cancelAction.setValue(UIColor.orange, forKey: "titleTextColor")
            
            alert.addAction(addAction)
            alert.addAction(cancelAction)
        alert.addTextField
        {(field) in
            textField = field
            textField.placeholder = "category name"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func showAlert()
    {
        let alert = UIAlertController(title: "NAME TAKEN ", message: "CHOOSE ANOTHER NAME", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .cancel, handler: nil )
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    // MARK: save category
    
    func saveCategory()
    {
        do
        {
            try context.save()
            tableView.reloadData()
        }
        catch{
            print(error )
        }
        
        
    }
    
    //  MARK: Load category func
    func loadCategory()
    {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do{
            category = try context.fetch(request)
        }
        catch
        {
            print("error loading folders \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return category.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "category_cell", for: indexPath)

        cell.textLabel?.text = category[indexPath.row].catName
        cell.textLabel?.textColor = .cyan
        cell.detailTextLabel?.textColor = .lightGray
        cell.detailTextLabel?.text = "\(category[indexPath.row].notes?.count ?? 0)"
        cell.imageView?.image = UIImage(systemName: "folder")
        cell.selectionStyle = .none

    

        return cell
    }


    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            deleteCategory(category: category[indexPath.row]) // deleting from core data file
            saveCategory() // saving the context
            category.remove(at: indexPath.row) // removing from the array
        
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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

    
    //MARK: Delete category
    func deleteCategory(category: Category)
    {
        context.delete(category)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let destination = segue.destination as! NoteTVC
        if let indexPath = tableView.indexPathForSelectedRow{
            destination.selectedCategory = category[indexPath.row]
    }
    

}
}
