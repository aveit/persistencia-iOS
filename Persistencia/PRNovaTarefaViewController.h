//
//  PRNovaTarefaViewController.h
//  Persistencia
//
//  Created by Acácio Veit Schneider on 24/02/14.
//  Copyright (c) 2014 Acácio Veit Schneider. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tarefa.h"

@interface PRNovaTarefaViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) Tarefa *tarefa;

@end
