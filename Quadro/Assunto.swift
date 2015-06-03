//
//  Assunto.swift
//  Quadro
//
//  Created by Luiz Ilha on 6/2/15.
//  Copyright (c) 2015 LUIZ ILHA M MACIEL. All rights reserved.
//

import Foundation

class Assunto: NSObject {
    var listaFotosComAnotacao: NSMutableArray!
    var dataPublicacao: NSDate!
    var nome: String!
    
    init(dataPublicacao: NSDate, nomeAssunto: String) {
        self.dataPublicacao = dataPublicacao
        self.nome = nomeAssunto
        if self.listaFotosComAnotacao == nil {
            self.listaFotosComAnotacao = NSMutableArray()
        }
    }
    
    class func listadb(idMateria: Int) -> NSMutableArray {
        var assuntos = NSMutableArray()
        var query = idMateria == 0 ? "select * from assunto" : "select * from assunto where idMateria=?"
        if Managerdb.sharedManager().opendb() {
            var rs = Managerdb.sharedManager().database!.executeQuery(query, withArgumentsInArray: [idMateria])
            while rs.next() {
                var assunto = Assunto(dataPublicacao: rs.dateForColumn("dataPublicacao"), nomeAssunto: rs.stringForColumn("nome"))
                assuntos.addObject(assunto)
            }
            Managerdb.sharedManager().closedb()
        }
        return assuntos
    }
    
    class func posicaodb(assunto: Assunto) -> Int {
        var posicao = 0
        if Managerdb.sharedManager().opendb() {
            var rs = Managerdb.sharedManager().database!.executeQuery("select * from assunto where nome=?", withArgumentsInArray: [assunto.nome])
            if rs.next() {
                posicao = Int(rs.intForColumn("idAssunto"))
                rs.close()
                Managerdb.sharedManager().closedb()
            }
        }
        return posicao
    }

    func savedb(idMateria: Int) {
        if Managerdb.sharedManager().opendb() {
            if Managerdb.sharedManager()!.database!.executeUpdate("insert into assunto(nome, dataPublicacao, idMateria) values(?,?,?)", withArgumentsInArray: [self.nome, self.dataPublicacao, idMateria]) {
                print("SALVO assunto!")
            }
            Managerdb.sharedManager().closedb()
        }
    }
    
    func deletedb(posicaoMateria: Int) {
        
    }
    
    func alterardb(novo: String, idMateria: Int) {
        if Managerdb.sharedManager().opendb() {
            Managerdb.sharedManager().database!.executeUpdate("update assunto set nome=? where nome=? and idMateria=?", withArgumentsInArray: [novo, self.nome, idMateria])
            Managerdb.sharedManager().closedb()
        }
    }

}