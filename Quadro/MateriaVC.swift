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
    var todasMaterias: Array<Materia>!
    var posicaoMateria = 0
    
    
    override func viewDidLoad() {
        todasMaterias = Array<Materia>()
        
        for m in Materia.listadb() {
            todasMaterias.append(m as! Materia)
        }
        
        var materia = Materia(materia: "Todos Assuntos")
        todasMaterias.insert(materia, atIndex: 0)
        
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
                for m in self.todasMaterias {
                    if m.nome == nomeMateria {
                        existe = true
                    }
                }
                if !existe {
                    materia.savedb()
                    self.todasMaterias.append(materia)
                    self.table.reloadData()
                }
            }
        } else if title == "Alterar" {
            if count(nomeMateria) != 0 {
                var materia = self.todasMaterias![self.posicaoAlterar.row]
                var existe = false
                for m in self.todasMaterias! {
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
        var materia = self.todasMaterias[indexPath.row]
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
            var materia = self.todasMaterias[indexPath.row]
            materia.deletedb()
            self.todasMaterias.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var materia = self.todasMaterias![indexPath.row]
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