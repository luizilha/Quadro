//
//  Materia.swift
//  Quadro
//
//  Created by Luiz Ilha on 6/1/15.
//  Copyright (c) 2015 LUIZ ILHA M MACIEL. All rights reserved.
//

import Foundation

class Materia: NSObject {
    var idMateria = 0
    var nome: String!

    
    init(materia: String) {
        nome = materia
    }
    
    class func listadb() -> NSMutableArray {
        var nova = NSMutableArray()
        if Managerdb.sharedManager().opendb() {
            var rs = Managerdb.sharedManager().database!.executeQuery("select * from materia", withArgumentsInArray: nil)
            while rs.next() {
                var materia = Materia(materia: rs.stringForColumn("nome"))
                materia.idMateria = Int(rs.intForColumn("idMateria"))
                nova.addObject(materia)
            }
            rs.close()
            Managerdb.sharedManager().closedb()
        }
        return nova
    }

    class func posicaodb(materia: Materia) -> Int {
        var posicao = 0
        if Managerdb.sharedManager().opendb() {
            var rs = Managerdb.sharedManager().database!.executeQuery("select * from materia where nome=?", withArgumentsInArray: [materia.nome])
            if rs.next() {
                posicao =  Int(rs.intForColumn("idMateria"))
                rs.close()
                Managerdb.sharedManager().closedb()
            }
        }
        return posicao
    }
    
    func savedb() {
        if Managerdb.sharedManager().opendb() {
            Managerdb.sharedManager().database!.beginTransaction()
            Managerdb.sharedManager().database!.executeUpdate("insert into materia(nome) values(?)", withArgumentsInArray: [self.nome])
            Managerdb.sharedManager().database!.commit()
            Managerdb.sharedManager().closedb()
        }
    }

    func alteradb(novo: String) {
        if Managerdb.sharedManager().opendb() {
            Managerdb.sharedManager().database!.executeUpdate("update materia set nome=? where nome=?", withArgumentsInArray: [novo, self.nome])
            Managerdb.sharedManager().closedb()
        }
    }

    func deletedb() {
        if Managerdb.sharedManager().opendb() {
            Managerdb.sharedManager().database!.beginTransaction()
            // FALTA IMPLEMENTAR ARQUIVO NO DROPBOX
        }
    }

}