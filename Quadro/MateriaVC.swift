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
    var posicaoAlterar: NSIndexPath!
    var todasMaterias: NSMutableArray!
    var posicaoMateria = 0
    
    
    override func viewDidLoad() {
        todasMaterias = TodasMateriasSingleton.sharedInstance().listaDeMaterias
        var materia = Materia(materia: "Todos Assuntos")
        todasMaterias.insertObject(materia, atIndex: 0)
        
        self.table.tableFooterView = UIView(frame: CGRect.zeroRect)
        self.btnAdicionar.titleLabel?.font = UIFont(name: "OpenSans-Semibold", size: 17)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.screenName = NSLocalizedString("Materia", comment: "")
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
        }
    }
    
    @IBAction func adicionarMateria(sender: UIButton) {
        let alerta = UIAlertView(title: NSLocalizedString("MSG_ADD_MATERIA" ,comment: ""), message: NSLocalizedString("MSG_EX_ADD_MATERIA" ,comment: ""), delegate: self, cancelButtonTitle: NSLocalizedString("CANCELAR" ,comment: ""), otherButtonTitles: NSLocalizedString("SALVAR" ,comment: ""))
        alerta.alertViewStyle = UIAlertViewStyle.PlainTextInput
        alerta.show()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("materiaCell") as! UITableViewCell
        var materia = TodasMateriasSingleton.sharedInstance().listaDeMaterias![indexPath.row] as! Materia
        cell.textLabel?.font = UIFont(name: "OpenSans-Semibold", size: 17)
        cell.textLabel?.text = materia.nome
        cell.textLabel?.textColor = UIColor(red: 0.0, green: 250.0/255, blue: 180.0/255, alpha: 1.0)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todasMaterias.count
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var materia = TodasMateriasSingleton.sharedInstance().listaDeMaterias![indexPath.row] as! Materia
        self.posicaoMateria =  Int(Materia.posicaodb(materia))
        self.performSegueWithIdentifier("segueAssunto", sender: self)
        self.table.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueAssunto" {
            var navController = segue.destinationViewController as! UINavigationController
            var assunto = navController.viewControllers[0] as! AssuntoViewController
            assunto.posicaoMateria = Int32(self.posicaoMateria)
        }
    }
    
}