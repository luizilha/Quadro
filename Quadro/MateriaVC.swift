//
//  MateriaVC.swift
//  Quadro
//
//  Created by Luiz Ilha on 5/12/15.
//  Copyright (c) 2015 LUIZ ILHA M MACIEL. All rights reserved.
//

import UIKit

class MateriaVC: GAITrackedViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate {
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var btnAdicionar: UIButton!
    var assuntos: NSMutableArray!
    var posicaoMateria: NSInteger!
    var posicaoAlterar: NSIndexPath!
    
    override func viewDidLoad() {
        self.table.tableFooterView = UIView(frame: CGRect.zeroRect)
        self.btnAdicionar.titleLabel?.font = UIFont(name: "OpenSans-Semibold", size: 17)
        
        // TERMOS DE USO
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var aceito: Bool = defaults.boolForKey("aceito")
        if !aceito {
            self.termos()
        }        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.screenName = NSLocalizedString("Materia", comment: "")
    }
    
    func termos() {
        let cancel: String! = NSLocalizedString("RECUSAR", comment: "")
        
        let alert = UIAlertView()
        alert.title = NSLocalizedString("TERMOS_T", comment: "")
        alert.message = NSLocalizedString("TERMOS", comment: "")
        alert.delegate = self
        alert.addButtonWithTitle(NSLocalizedString("ACEITAR", comment: ""))
        alert.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let title = alertView.buttonTitleAtIndex(buttonIndex)
        let nomeMateria: String! = alertView.textFieldAtIndex(0)?.text
        if title == NSLocalizedString("SALVAR",comment: "") {
            if count(nomeMateria) != 0 {
                let materia = Materia(materia: nomeMateria)
                var existe = false
                for m in TodasMateriasSingleton.sharedInstance().listaDeMaterias! {
                    if m.nome == nomeMateria {
                        existe = true
                    }
                }
                if !existe {
                    materia.savedb()
                    TodasMateriasSingleton.sharedInstance().listaDeMaterias!.addObject(materia)
                    self.table.reloadData()
                }
            }
        } else if title == "Alterar" {
            if count(nomeMateria) != 0 {
                var materia = TodasMateriasSingleton.sharedInstance().listaDeMaterias![self.posicaoAlterar.row] as! Materia
                var existe = false
                for m in TodasMateriasSingleton.sharedInstance().listaDeMaterias! {
                    if m.nome == nomeMateria {
                        existe = true
                    }
                }
                if !existe {
                    materia.alteradb(nomeMateria)
                    materia.nome = nomeMateria
                    self.table.reloadData()
                }
            }
        } else if title == NSLocalizedString("ACEITAR", comment: "") {
            var aceito = true
            var defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(aceito, forKey: "aceito")
            defaults.synchronize()
        } else if title == NSLocalizedString("RECUSAR", comment: "") {
            exit(0)
        }
    }
    
    @IBAction func adicionarMateria(sender: UIButton) {
        let alerta = UIAlertView(title: NSLocalizedString("MSG_ADD_MATERIA" ,comment: ""), message: NSLocalizedString("MSG_EX_ADD_MATERIA" ,comment: ""), delegate: self, cancelButtonTitle: "title")

//        alerta.addButtonWithTitle(NSLocalizedString("SALVAR" ,comment: ""))
        alerta.alertViewStyle = UIAlertViewStyle.PlainTextInput
        alerta.show()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("materiaCell") as! UITableViewCell
        var materia = TodasMateriasSingleton.sharedInstance().listaDeMaterias![indexPath.row] as! Materia
        cell.textLabel?.font = UIFont(name: "OpenSans-Semibold", size: 17)
        cell.textLabel?.text = materia.nome
        cell.textLabel?.textColor = UIColor(red: 0.0, green: 250.0/255, blue: 180.0/255, alpha: 1.0)
        // long press
        var longPressGesture = UILongPressGestureRecognizer(target: self, action: Selector("longPress:"))
        cell.addGestureRecognizer(longPressGesture)
        longPressGesture.minimumPressDuration = 1
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TodasMateriasSingleton.sharedInstance().listaDeMaterias!.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.posicaoMateria = indexPath.row;
        self.performSegueWithIdentifier("segueAssunto", sender: self)
        self.table.reloadData()
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            //remover do mutable array
            var materia = TodasMateriasSingleton.sharedInstance().listaDeMaterias!.objectAtIndex(indexPath.row) as! Materia
            materia.deletedb()
            TodasMateriasSingleton.sharedInstance().listaDeMaterias!.removeObjectAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
    func longPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.Began {
            var cell = gesture.view as! UITableViewCell
            var indexPath: NSIndexPath = self.table.indexPathForCell(cell)!
            var materia = TodasMateriasSingleton.sharedInstance().listaDeMaterias!.objectAtIndex(indexPath.row) as! Materia
            var titulo = "Deseja renomear a materia \(materia.nome.capitalizedString)?"
            var alert = UIAlertView()
            alert.title = titulo
            alert.message = ""
            alert.delegate = self
            alert.addButtonWithTitle("Alterar")
            alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
            self.posicaoAlterar = indexPath
            alert.show()
        }
    }
    
    // Para apagar uma materia
    override func setEditing(editing: Bool, animated: Bool) {
        self.table.setEditing(editing, animated: animated)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueAssunto" {
            var navController = segue.destinationViewController as! UINavigationController
            var assunto = navController.viewControllers[0] as! AssuntoViewController
            assunto.posicaoMateria = self.posicaoMateria
        }
        
    }
    
}