//
//  PRNovaTarefaViewController.m
//  Persistencia
//
//  Created by Acácio Veit Schneider on 24/02/14.
//  Copyright (c) 2014 Acácio Veit Schneider. All rights reserved.
//

#import "PRNovaTarefaViewController.h"
#import "Categoria.h"
#import "Tarefa.h"
#import "PRAppDelegate.h"
#import "PRLocalizacaoViewController.h"

@interface PRNovaTarefaViewController () {
  
  CGRect frameTxtNome;
  CGRect frameTxtDescricao;
  CGRect framePickerCategoria;
  CGRect frameLblNome;
  CGRect frameLblDescricao;
  CGRect frameLblCategoria;
}

@property (strong, nonatomic) NSMutableArray *categorias;

@property (weak, nonatomic) IBOutlet UITextField *txtNome;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerCategoria;
@property (weak, nonatomic) IBOutlet UIButton *btnSalvar;
@property (weak, nonatomic) IBOutlet UIButton *btnDefinirLocalizcao;
@property (weak, nonatomic) IBOutlet UITextView *txtDescricao;
@property (weak, nonatomic) IBOutlet UILabel *lblCategoria;
@property (weak, nonatomic) IBOutlet UILabel *lblNome;
@property (weak, nonatomic) IBOutlet UILabel *lblDescricao;

@end

@implementation PRNovaTarefaViewController

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  [self buscaCategorias];
  
  if (self.tarefa != nil) {
    
    self.title             = @"Editando tarefa";
    self.txtNome.text      = self.tarefa.nome;
    self.txtDescricao.text = self.tarefa.descricao;
    
    NSPredicate *predicate  = [NSPredicate predicateWithFormat:@"self == %@", self.tarefa.categoria.nome];
    NSString *nomeCategoria = [[self.categorias filteredArrayUsingPredicate:predicate] firstObject];
    [self.pickerCategoria selectRow:[self.categorias indexOfObject:nomeCategoria] inComponent:0 animated:YES];
  } else {
    [self.txtNome becomeFirstResponder];
  }
  
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(dismissKeyboard)];
  
  [self.view addGestureRecognizer:tap];
}

-(void)viewWillAppear:(BOOL)animated {
  
  [super viewWillAppear:animated];
  [self carregaCor];
}

//Carrega a global tint nos elementos da tela
-(void) carregaCor {
  
  [self.btnSalvar setTitleColor: (UIColor *)[(PRAppDelegate *)[[UIApplication sharedApplication] delegate] globalTint]
                       forState: UIControlStateNormal];
  
  [self.navigationController.navigationBar setTintColor:(UIColor *)[(PRAppDelegate *)[[UIApplication sharedApplication] delegate] globalTint]];
  [self.txtNome setTintColor:(UIColor *)[(PRAppDelegate *)[[UIApplication sharedApplication] delegate] globalTint]];
  [self.txtDescricao setTintColor:(UIColor *)[(PRAppDelegate *)[[UIApplication sharedApplication] delegate] globalTint]];
  [self.btnDefinirLocalizcao setTitleColor: (UIColor *)[(PRAppDelegate *)[[UIApplication sharedApplication] delegate] globalTint]
                                  forState: UIControlStateNormal];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
  
  if ([textView isEqual: self.txtDescricao]) {
    
    [self.btnDefinirLocalizcao setAlpha:0];
    
    frameTxtDescricao    = self.txtDescricao.frame;
    frameLblCategoria    = self.lblCategoria.frame;
    framePickerCategoria = self.pickerCategoria.frame;
    frameTxtNome         = self.txtNome.frame;
    frameLblNome         = self.lblNome.frame;
    frameLblDescricao    = self.lblDescricao.frame;
    
    [UIView animateWithDuration: 0.8 animations:^{
      
      CGRect _frameLblDescricao = CGRectMake(0, self.lblNome.frame.origin.y - 30, self.view.frame.size.width, self.lblDescricao.frame.size.height);
      CGRect _frameTxtDescricao = CGRectMake(0, self.txtNome.frame.origin.y + 10, self.view.frame.size.width, textView.frame.size.height + 75);
      
      self.lblNome.frame         = CGRectMake(self.view.frame.origin.x - 5, self.view.frame.origin.y - 5, self.lblNome.frame.size.width, self.lblNome.frame.size.height);
      self.txtNome.frame         = CGRectMake(self.view.frame.origin.x - 5, self.view.frame.origin.y - 5, self.txtNome.frame.size.width, self.txtNome.frame.size.height);
      self.lblCategoria.frame    = CGRectMake(self.view.frame.origin.x - 5, self.view.frame.origin.y - 5, self.lblCategoria.frame.size.width, self.lblCategoria.frame.size.height);
      self.pickerCategoria.frame = CGRectMake(self.view.frame.origin.x - 5, self.view.frame.origin.y - 5, self.pickerCategoria.frame.size.width, self.pickerCategoria.frame.size.height);
      self.lblDescricao.frame    = _frameLblDescricao;
      self.txtDescricao.frame    = _frameTxtDescricao;
      
      [self.lblDescricao setTextAlignment: NSTextAlignmentCenter];
      [self.lblNome setAlpha:0];
      [self.txtNome setAlpha:0];
      [self.lblCategoria setAlpha:0];
      [self.pickerCategoria setAlpha:0];
    }];
  }
  return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
  
  if ([textView isEqual: self.txtDescricao]) {
    
    [self.btnDefinirLocalizcao setAlpha:1];
    
    [UIView animateWithDuration: 0.45 animations:^{
      
      self.txtDescricao.frame    = frameTxtDescricao;
      self.txtNome.frame         = frameTxtNome;
      self.lblCategoria.frame    = frameLblCategoria;
      self.pickerCategoria.frame = framePickerCategoria;
      self.lblNome.frame         = frameLblNome;
      self.lblDescricao.frame    = frameLblDescricao;
      
      [self.lblNome setAlpha:1];
      [self.txtNome setAlpha:1];
      [self.lblDescricao setTextAlignment: NSTextAlignmentNatural];
      [self.lblCategoria setAlpha:1];
      [self.pickerCategoria setAlpha:1];
    }];
  }
  return YES;
}

#pragma mark cliques
//Ao clicar no botao de salvar localizacao
- (IBAction)clickDefinirLocalizacao:(UIButton *)sender {
  
  if (self.tarefa == nil) {
    
    // Buscar o Contexto
    NSManagedObjectContext *context = [(PRAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    self.tarefa = (Tarefa *)[NSEntityDescription insertNewObjectForEntityForName:@"Tarefa"
                                                          inManagedObjectContext:context];
  }
  
  [self performSegueWithIdentifier:@"goToLocalizacao" sender: sender];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
  if ([segue.identifier isEqualToString:@"goToLocalizacao"]) {
    
    PRLocalizacaoViewController *viewController = (PRLocalizacaoViewController *)segue.destinationViewController;
    viewController.tarefa = self.tarefa;
  }
}

//Ao clicar no botao de salvar
- (IBAction)clickSalvar:(id)sender {
  
  if (self.txtNome.text.length == 0 || self.txtDescricao.text.length == 0) {
    
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"Campo não preenchido"
                                                   message:@"Por favor, preencha todos os campos"
                                                  delegate:self
                                         cancelButtonTitle:nil
                                         otherButtonTitles:@"OK", nil];
    [view show];
    return;
  }
  [self dismissKeyboard];
  
  NSError *error;
  
  // Buscar o Contexto
	NSManagedObjectContext *context = [(PRAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  
  // Categoria
	// Busca os objetos
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity  = [NSEntityDescription entityForName:@"Categoria" inManagedObjectContext:context];
  NSInteger row                = [self.pickerCategoria selectedRowInComponent:0];
  NSPredicate *predicate       = [NSPredicate predicateWithFormat: @"nome == %@", [self.categorias objectAtIndex:row]];
  
  [fetchRequest setPredicate: predicate];
	[fetchRequest setEntity:entity];
	
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
  Categoria *categoria;
	if (fetchedObjects.count > 0) {
    categoria = (Categoria *)[fetchedObjects firstObject];
  } else {
    
    categoria = (Categoria *)[NSEntityDescription insertNewObjectForEntityForName:@"Categoria"
                                                           inManagedObjectContext:context];
  }
  
	categoria.nome = [self.categorias objectAtIndex:row];
  
  // Tarefa
  Tarefa *tarefa;
  if (self.tarefa == nil) {
    tarefa = (Tarefa *)[NSEntityDescription insertNewObjectForEntityForName:@"Tarefa"
                                                     inManagedObjectContext:context];
  } else {
    tarefa = self.tarefa;
  }
  
	tarefa.nome      = self.txtNome.text;
  tarefa.descricao = self.txtDescricao.text;
  tarefa.categoria = categoria;
  
  // Salva o Contexto
	if (![context save:&error]) {
		NSLog(@"Erro ao salvar: %@", [error localizedDescription]);
	} else {
		NSLog(@"Salvo com sucesso!");
	}
  
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark end cliques

//Retira o 'foco' dos campos de texto
-(void)dismissKeyboard {
  
  [self.txtNome resignFirstResponder];
  [self.txtDescricao resignFirstResponder];
}

//Busca as categorias 'cadastradas' no arquivo plist
-(void) buscaCategorias {
  
  // Property List (plist) de categorias
	NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Categorias" ofType:@"plist"];
	[self.categorias addObjectsFromArray:[[NSArray alloc] initWithContentsOfFile:plistPath]];
}

-(NSMutableArray *)categorias {
  
  if (_categorias == nil) {
    _categorias = [[NSMutableArray alloc] init];
  }
  return _categorias;
}

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return self.categorias.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
  
  return [self.categorias objectAtIndex:row];
}

@end
