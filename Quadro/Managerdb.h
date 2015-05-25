//
//  FMDBManager.h
//  Quadro
//
//  Created by Luiz Ilha on 3/12/15.
//  Copyright (c) 2015 LUIZ ILHA M MACIEL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface Managerdb : NSObject
@property (readonly, nonatomic) FMDatabase *database;

+ (id) sharedManager;
- (BOOL)opendb;
- (BOOL)closedb;

@end