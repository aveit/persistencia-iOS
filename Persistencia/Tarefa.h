//
//  Tarefa.h
//  Persistencia
//
//  Created by Acácio Veit Schneider on 27/02/14.
//  Copyright (c) 2014 Acácio Veit Schneider. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Categoria;

@interface Tarefa : NSManagedObject

@property (nonatomic, retain) NSDate * dataInsercao;
@property (nonatomic, retain) NSString * descricao;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * nome;
@property (nonatomic, retain) Categoria *categoria;

@end
