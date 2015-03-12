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
        self.fileName = @"dbQuadro.db";
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
        NSString *docDir = [docPath objectAtIndex:0];
        self.database = [FMDatabase databaseWithPath:[docDir stringByAppendingPathComponent:self.fileName]];
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
