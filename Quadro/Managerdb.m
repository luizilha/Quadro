//
//  FMDBManager.m
//  Quadro
//
//  Created by Luiz Ilha on 3/12/15.
//  Copyright (c) 2015 LUIZ ILHA M MACIEL. All rights reserved.
//

#import "Managerdb.h"

@interface Managerdb ()

@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) FMDatabase *database;

@end

@implementation Managerdb


+ (id)sharedManager
{
    static Managerdb *sharedMyManager = nil;
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
    if (self)
    {
        NSString *dataName = @"quadro.sqlite";
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSString *docDir = [docPath objectAtIndex:0];
        NSString *localdb = [docDir stringByAppendingPathComponent:dataName];
        BOOL suceess;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        suceess = [fileManager fileExistsAtPath:localdb];
        NSURL *filePath = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        filePath = [filePath URLByAppendingPathComponent:dataName];
        
        _fileName = [filePath absoluteString];
    }
    return self;
}

- (BOOL)opendb
{
    self.database = [FMDatabase databaseWithPath:_fileName];
   // [self.database beginTransaction];
    return [self.database open];
    
}

- (BOOL)closedb
{
   // [self.database commit];
    return [self.database close];
}
@end
