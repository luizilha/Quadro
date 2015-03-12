//
//  FMDBManager.m
//  Quadro
//
//  Created by Luiz Ilha on 3/12/15.
//  Copyright (c) 2015 LUIZ ILHA M MACIEL. All rights reserved.
//

#import "FMDBManager.h"

@interface FMDBManager ()

@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) FMDatabase *database;

@end

@implementation FMDBManager


+ (id)sharedManager
{
    static FMDBManager *sharedMyManager = nil;
    @synchronized(self) {
        if (sharedMyManager == nil) {
            sharedMyManager = [[self alloc] init];
        }
    }
    return sharedMyManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (int)open
{
    return [self.database open];
}

- (int)close
{
    return [self database];
}



@end
