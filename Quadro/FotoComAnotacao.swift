//
//  FotoComAnotacao.swift
//  Quadro
//
//  Created by Luiz Ilha on 6/2/15.
//  Copyright (c) 2015 LUIZ ILHA M MACIEL. All rights reserved.
//

import Foundation

class FotoComAnotacao: NSObject {
    var foto: UIImage!
    var caminhoDaFoto: String!
    var anotacao: String!

    init(foto: UIImage, comentario: String) {
        
    }
    
    class func todasFotosdb(assunto: Assunto, idMateria: Int) {
        
    }
    
    class func removeImagemDisco(caminhoDaFoto: String) {
        
    }
    
    class func todasFotosdb(idAssunto: Int) -> NSMutableArray {
        var listafotos = NSMutableArray()
        
//
//        if ([[Managerdb sharedManager] opendb]) {
//            FMResultSet *rs = [[[Managerdb sharedManager] database] executeQuery:@"select * from fotoComAnotacao where idAssunto = ?",[NSString stringWithFormat:@"%d", idAssunto]];
//            while ([rs next]) {
//                FotoComAnotacao *foto = [[FotoComAnotacao alloc] initFotoComentada:nil comComentario:[rs stringForColumn:@"anotacao"]];
//                foto.caminhoDaFoto = [rs stringForColumn:@"caminhoDaFoto"];
//                foto.foto = [foto loadImage];
//                [listafotos addObject:foto];
//            }
//            [rs close];
//            [[Managerdb sharedManager] closedb];
//        }
//        return listafotos;
        return listafotos
    }
    
    func saveFotodb(assunto: Assunto, idMateria: Int) {
        
    }
    
    func deletedb() {
        
    }
    
    func mudaAnotacaodb() {
        
    }
    
    func saveImage(image: UIImage) -> Bool {
        return true
    }
    
    func loadImage() -> UIImage {
        var image = UIImage()
        return image
    }
    
    func nomeDaFotoAssunto(assunto: Assunto, posicao: Int, idMateria: Int) {
        
    }
    
}