//
//  PRAppDelegate.h
//  Persistencia
//
//  Created by Acácio Veit Schneider on 24/02/14.
//  Copyright (c) 2014 Acácio Veit Schneider. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) UIColor *globalTint;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
