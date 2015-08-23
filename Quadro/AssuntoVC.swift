//
//  AssuntoVC.swift
//  Quadro
//
//  Created by Luiz Ilha on 8/22/15.
//  Copyright (c) 2015 LUIZ ILHA M MACIEL. All rights reserved.
//

import UIKit


class AssuntoVC: GAITrackedViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationBarDelegate, UIAlertViewDelegate {
    var posicaoMateria = 0
    var todosAssuntos:Array<Assunto>!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var btnGaveta: UIBarButtonItem!
    @IBAction func camera(sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        print(self.posicaoMateria)
        self.todosAssuntos = Assunto.listadb(self.posicaoMateria)
        // termos de uso
        let defaults = NSUserDefaults.standardUserDefaults()
        var aceito = defaults.boolForKey("aceito")
        if !aceito {
            self.termos()
        }
        self.table.tableFooterView = UIView(frame: CGRectZero)
        // btn do menu gaveta
        self.btnGaveta.target = self.revealViewController()
        self.btnGaveta.action = Selector("revealToggle:")
        self.automaticallyAdjustsScrollViewInsets = false

    }
    
    func termos() {
        
    }
    /*
    self.table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
*/
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("assuntoCell", forIndexPath: indexPath) as! AssuntoCell
        cell.textLabel?.text = "PORRA"
        cell.assunto.text = "CARAI"
        return cell;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    
}