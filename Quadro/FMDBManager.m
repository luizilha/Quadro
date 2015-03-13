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
        NSString *dataName = @"quadro.sqlite";
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSString *docDir = [docPath objectAtIndex:0];
        NSString *localdb = [docDir stringByAppendingPathComponent:dataName];
        BOOL suceess;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        suceess = [fileManager fileExistsAtPath:localdb];
        
        NSURL *filePath = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        filePath = [filePath URLByAppendingPathComponent:dataName];
        
        NSString *path = [filePath absoluteString];
        self.database = [FMDatabase databaseWithPath:path];
        
        if (![self.database open]) {
            NSLog(@"NAO ABRIU!!");
        }
        [_database executeUpdate:@"CREATE TABLE IF NOT EXISTS materia(idMateria integer primary key, nome text not null);"];
        
        if ([_database hadError]) {
            NSLog(@"ERROR: %@", [_database lastErrorMessage]);
        }
       
    }
    return self;
}

- (int)open
{
    if (![self.database open]) {
        NSLog(@"BANCO NAO PODE ABRIR!!");
        return 0;
    }
    return 1;
}

- (int)close
{
    return [self.database close];
}



@end
