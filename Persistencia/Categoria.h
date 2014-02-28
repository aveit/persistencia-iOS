//
//  Categoria.h
//  Persistencia
//
//  Created by Acácio Veit Schneider on 27/02/14.
//  Copyright (c) 2014 Acácio Veit Schneider. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tarefa;

@interface Categoria : NSManagedObject

@property (nonatomic, retain) NSString * nome;
@property (nonatomic, retain) NSSet *tarefas;
@end

@interface Categoria (CoreDataGeneratedAccessors)

- (void)addTarefasObject:(Tarefa *)value;
- (void)removeTarefasObject:(Tarefa *)value;
- (void)addTarefas:(NSSet *)values;
- (void)removeTarefas:(NSSet *)values;

@end
