//
//  MateriaPorDataSingleton.h
//  Quadro
//
//  Created by Luiz Ilha on 2/3/15.
//  Copyright (c) 2015 Ilha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodasMateriasSingleton : NSObject

@property (nonatomic) NSMutableArray *listaDeMaterias;

+ (id)sharedInstance;
-(void)loadData;
-(void)saveData;

@end
