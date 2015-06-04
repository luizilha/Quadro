//
//  FotoComAnotacao.swift
//  Quadro
//
//  Created by Luiz Ilha on 6/2/15.
//  Copyright (c) 2015 LUIZ ILHA M MACIEL. All rights reserved.
//

import Foundation
import UIKit

class FotoComAnotacao: NSObject {
    var foto: UIImage!
    var caminhoDaFoto: String!
    var anotacao: String!

    init(foto: UIImage, comentario: String) {
        super.init()
        self.foto = foto
        self.anotacao = comentario
    }
    
    init(comentario: String, caminhoDaFoto: String) {
        super.init()
        self.anotacao = comentario
        self.caminhoDaFoto = caminhoDaFoto
    }
    
    class func removeImagemDisco(caminhoDaFoto: String) {
        let fileManager = NSFileManager.defaultManager()
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray!
        let documentsDirectory = paths.objectAtIndex(0) as! String
        let path = documentsDirectory.stringByAppendingPathComponent(caminhoDaFoto)
        let success = fileManager.removeItemAtPath(path, error: nil)
        if success {
            print ("removeu FOTO")
        }
    }
    
    class func todasFotosdb(idAssunto: Int) -> NSMutableArray {
        var listafotos = NSMutableArray()
        if Managerdb.sharedManager().opendb() {
            var rs = Managerdb.sharedManager().database!.executeQuery("select * from fotoComAnotacao where idAssunto = ?", withArgumentsInArray: [idAssunto])
            while rs.next() {
                var imagem: UIImage!
                var foto = FotoComAnotacao(comentario: rs.stringForColumn("anotacao"), caminhoDaFoto: rs.stringForColumn("caminhoDaFoto"))
                foto.foto = foto.loadImage()
                listafotos.addObject(foto)
            }
            rs.close()
            Managerdb.sharedManager().closedb()
        }
        return listafotos
    }
    
    func saveFotodb(assunto: Assunto, idMateria: Int) {
        if Managerdb.sharedManager().opendb() {
            let rs = Managerdb.sharedManager().database!.executeQuery("select * from assunto where idMateria = ? and nome = ?", withArgumentsInArray: [idMateria, assunto.nome])
            if rs.next() {
                let idAssunto = Int(rs.intForColumn("idAssunto"))
                Managerdb.sharedManager().database!.executeUpdate("insert into fotoComAnotacao(caminhoDaFoto, anotacao, idAssunto) values(?,?,?)", withArgumentsInArray: [self.caminhoDaFoto, self.anotacao, idAssunto])
            }
            rs.close()
            Managerdb.sharedManager().closedb()
        }
    }
    
    func deletedb() {
        
    }
    
    func mudaAnotacaodb() {
        if Managerdb.sharedManager().opendb() {
            if Managerdb.sharedManager().database!.executeUpdate("update fotoComAnotacao set anotacao = ? where caminhoDaFoto = ?", withArgumentsInArray: [self.anotacao, self.caminhoDaFoto]) {
                print("mudo anotacao")
            }
        }
        Managerdb.sharedManager().closedb()
    }
    
    func saveImage(image: UIImage?) -> Bool {
        if image != nil {
            let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray!
            let documentsDirectory = paths.objectAtIndex(0) as! String
            let path = documentsDirectory.stringByAppendingPathComponent(caminhoDaFoto)
            let fileManager = NSFileManager.defaultManager()
            if fileManager.fileExistsAtPath(path) {
                print ("NAO SALVO - IMG!!")
                return false
            }
            let data = UIImageJPEGRepresentation(image, 1)
            data.writeToFile(path, atomically: true)
            print("SALVO - IMG!!")
            return true;
        }
        return false;
    }
    
    func loadImage() -> UIImage {
        var image = UIImage()
        return image
    }
    
    func nomeDaFotoAssunto(assunto: Assunto, posicao: Int, idMateria: Int) {
        if Managerdb.sharedManager().opendb() {
            let rs = Managerdb.sharedManager().database!.executeQuery("select * from assunto where nome=? and idMateria=?", withArgumentsInArray: [assunto.nome, idMateria])
            if rs.next() {
                self.caminhoDaFoto = String(rs.intForColumn("idMateria")) + String(rs.intForColumn("idAssunto")) + String(posicao)
            }
            rs.close()
            Managerdb.sharedManager().closedb()
        }
    }
    
}