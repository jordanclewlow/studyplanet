//
//  ViewController.swift
//  moduletableproject
//
//  Created by Jordan on 23/12/2020.
//

import UIKit

class ModuleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var moduleMessageLabel: UILabel!
    
    var name : String!
    var course : String!
    var modules = [String]()
    
    //@IBAction func toAvailability(_ sender: UIButton) {
     //   self.performSegue(withIdentifier: "availabilitySegue", sender: self)
    //}
    
    @IBOutlet weak var moduleTitleLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "add module", message:nil, preferredStyle: .alert)
        alert.addTextField {(moduleTF) in
            moduleTF.placeholder = "COMP101"
        }
        
        let action = UIAlertAction(title: "add", style: .default) { (_) in
            guard let module = alert.textFields?.first?.text else {return}
            print(module)
            self.add(module)
        }
        alert.addAction(action)
        present(alert, animated:true)
    }
    
    func add(_ module: String) {
        let index = 0
        modules.insert(module, at: index)
        let indexPath = IndexPath(row: index, section: 0)
        
        tableView.insertRows(at: [indexPath], with: .top
        )
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let module = modules[indexPath.row]
        //cell.textLabel?.text = module
        //return cell
       let customCell = tableView.dequeueReusableCell(withIdentifier: ModuleTableViewCell.identifier, for: indexPath) as! ModuleTableViewCell
            
        customCell.configure(with: module)
            
        return customCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return}
        modules.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }


    @IBOutlet var moduleTable: UITableView!
    
    
  /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "plannerSegue" {
            let vc = segue.destination as! PlannerViewController
            vc.name = name
            vc.course = course
            vc.modules = modules
        }
    }*/
    
    override func viewDidLoad() {
        print("test")
        super.viewDidLoad()
        moduleTable.register(ModuleTableViewCell.nib(), forCellReuseIdentifier: ModuleTableViewCell.identifier)
        
        moduleTable.delegate = self
        moduleTable.dataSource = self
        
        moduleTitleLabel.text = "Thanks !"
       moduleMessageLabel.text = "All we need now is to know your modules you do in your " /*+ course + " course and how confident you are in them."
        // Do any additional setup after loading the view.*/
    }


}

