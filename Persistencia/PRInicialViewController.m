//
//  PRInicialViewController.m
//  Persistencia
//
//  Created by Acácio Veit Schneider on 24/02/14.
//  Copyright (c) 2014 Acácio Veit Schneider. All rights reserved.
//

#import "PRInicialViewController.h"
#import "PRNovaTarefaViewController.h"
#import "PRAppDelegate.h"
#import "Tarefa.h"
#import "Categoria.h"

@interface PRInicialViewController ()

@property (strong, nonatomic) NSMutableArray *tarefas;
@property (strong, nonatomic) NSIndexPath *indexPathTarefaExcluir;
@property (strong, nonatomic) NSMutableArray *resultadoBusca;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableTarefas;

@property BOOL pesquisando;

@end

@implementation PRInicialViewController

- (void)viewDidLoad {
  
  [super viewDidLoad];
  self.tabBarController.navigationItem.hidesBackButton = YES;
  
  UIBarButtonItem *btnNovaTarefa = [[UIBarButtonItem alloc] initWithTitle:@"+Tarefa" style:UIBarButtonItemStylePlain target:self action:@selector(goToNovaTarefa:)];
  self.tabBarController.navigationItem.rightBarButtonItem = btnNovaTarefa;
  self.tabBarController.title = @"Tarefas";
}

-(void) goToNovaTarefa:(UIBarButtonItem *)sender {
  
  [self performSegueWithIdentifier:@"goToNovaTarefa" sender:sender];
}

-(void) carregaCor {
  [self.navigationController.navigationBar setTintColor: (UIColor *)[(PRAppDelegate *)[[UIApplication sharedApplication] delegate] globalTint]];
}

//AO CLICAR NO BOTAO DE EXCLUIR TAREFA
- (IBAction)clickApagar:(UIButton *)sender {
  
  UIAlertView *alertViewExclusao = [[UIAlertView alloc]
                                    initWithTitle:@"Excluir tarefa"
                                    message:@"Tem certeza que desejas excluir esta tarefa?"
                                    delegate:self
                                    cancelButtonTitle:@"Sim, remover"
                                    otherButtonTitles: @"Não", nil];
  
  [alertViewExclusao show];
  alertViewExclusao.tag = 1500;
  
  UITableViewCell *cell = (UITableViewCell *) [[[sender superview] superview] superview];
  self.indexPathTarefaExcluir = [self.tableTarefas indexPathForCell:cell];
}

//AO ALTERAR TEXTO DA SEARCH BAR
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  
  if (searchText.length > 0) {
    
    self.pesquisando = YES;
    [self pesquisar];
  } else {
    
    self.pesquisando = NO;
    [self.tableTarefas reloadData];
  }
}

//AO CLICAR NO BOTAO DE CANCELAR A PESQUISA
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
  
  self.pesquisando = NO;
  
  [self.searchBar setText:@""];
  [self.searchBar resignFirstResponder];
  [self.tableTarefas reloadData];
}

//PESQUISA TAREFAS ATRAVEZ DA SEARCH BAR
- (void) pesquisar {
  
  [self.resultadoBusca removeAllObjects];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"nome CONTAINS [cd] %@", self.searchBar.text];
  self.resultadoBusca = [[self.tarefas filteredArrayUsingPredicate:predicate] mutableCopy];
  
  [self.tableTarefas reloadData];
}

//VERIFICA QUAL BOTÃO DO ALERT VIEW QUE FOI CLICADO
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  
  if (alertView.tag == 1500) {
    
    if (buttonIndex == 0) {
      [self excluirTarefa];
    } else {
      self.indexPathTarefaExcluir = nil;
    }
  }
}

- (void) excluirTarefa {
  
  if (self.indexPathTarefaExcluir != nil) {
    
    UITableViewCell *cell = [self.tableTarefas cellForRowAtIndexPath:self.indexPathTarefaExcluir];
    cell.textLabel.frame = CGRectMake(cell.textLabel.frame.origin.x, cell.textLabel.frame.origin.y, cell.frame.size.width, cell.textLabel.frame.size.height);
    cell.textLabel.text = [cell.textLabel.text stringByAppendingString:@" - Excluindo..."];
    
    Tarefa *tarefa;
    if (!self.pesquisando) {
      tarefa = (Tarefa *) [self.tarefas objectAtIndex: self.indexPathTarefaExcluir.row];
    } else {
      
      tarefa = (Tarefa *) [self.resultadoBusca objectAtIndex: self.indexPathTarefaExcluir.row];
      [self.resultadoBusca removeObject: tarefa];
    }
    
    NSManagedObjectContext *context = [(PRAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    [context deleteObject:tarefa];
    
    NSError *error;
    if ([context save:&error]) {
      
      [self.tarefas removeObject:tarefa];
      
      [self.tableTarefas beginUpdates];
      [self.tableTarefas deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.indexPathTarefaExcluir] withRowAnimation:UITableViewRowAnimationFade];
      if ((!self.pesquisando && self.tarefas.count == 0) || (self.pesquisando && self.resultadoBusca.count == 0)) {
        [self.tableTarefas insertRowsAtIndexPaths:[NSArray arrayWithObject:self.indexPathTarefaExcluir] withRowAnimation:UITableViewRowAnimationFade];
      }
      
      [self.tableTarefas endUpdates];
    } else {
      
      
      
      [UIView animateWithDuration: 1.0 animations:^{
        
        [cell.textLabel setAlpha: 0];
        [cell.textLabel setText: @"Não foi possível excluir."];
        [cell.textLabel setAlpha: 1];
        [cell.textLabel setAlpha: 0];
      } completion:^(BOOL finished) {
        
        if (finished) {
          
          [UIView animateWithDuration: 1.0 animations:^{
            
            [cell.textLabel setText: tarefa.nome];
            [cell.textLabel setAlpha: 1];
          }];
        }
      }];
    }
  }
}

-(NSMutableArray *)tarefas {
  
  if (_tarefas == nil) {
    _tarefas = [[NSMutableArray alloc] init];
  }
  return _tarefas;
}

-(void)viewWillAppear:(BOOL)animated {
  
  [super viewWillAppear:animated];
  [self buscaTarefas];
  [self carregaCor];
}

-(void)viewDidAppear:(BOOL)animated {
  
  [super viewDidAppear:animated];
  [self.tableTarefas reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
  if ([segue.identifier isEqualToString:@"goToEditarTarefa"]) {
    
    PRNovaTarefaViewController *viewController = (PRNovaTarefaViewController *) segue.destinationViewController;
    if (!self.pesquisando) {
      viewController.tarefa = (Tarefa *)[self.tarefas objectAtIndex: ((UITableViewCell *)sender).tag];
    } else {
      viewController.tarefa = (Tarefa *)[self.resultadoBusca objectAtIndex: ((UITableViewCell *)sender).tag];
    }
  }
}

//Busca as tarefas no CORE DATA
-(void) buscaTarefas {
  
  [self.tarefas removeAllObjects];
  // Buscar o Contexto
	NSManagedObjectContext *context = [(PRAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	
	// Busca os objetos
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity  = [NSEntityDescription entityForName:@"Tarefa" inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	
  NSError *error;
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
  [self.tarefas addObjectsFromArray:fetchedObjects];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell;
  
  if ((self.pesquisando && self.resultadoBusca.count == 0) || (!self.pesquisando && self.tarefas.count == 0)) {
    
    static NSString *CellIdentifier = @"Cell2";
    
    cell                = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    cell.textLabel.text = @"Nenhuma tarefa encontrada.";
  } else {
    
    Tarefa *tarefa;
    if (!self.pesquisando) {
      tarefa = [self.tarefas objectAtIndex:indexPath.row];
    } else {
      tarefa = [self.resultadoBusca objectAtIndex:indexPath.row];
    }
    
    static NSString *CellIdentifier = @"Cell";
    
    cell                      = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath:indexPath];
    cell.tag                  = indexPath.row;
    cell.textLabel.text       = tarefa.nome;
    cell.detailTextLabel.text = tarefa.categoria.nome;
    
    [cell.detailTextLabel setTextColor: [UIColor colorWithRed: (127/255.0) green: (140/255.0) blue: (141/255.0) alpha: 1]];
  }
  return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  if ((!self.pesquisando && self.tarefas.count == 0) || (self.pesquisando && self.resultadoBusca.count == 0)) {
    return 1;
  }
  
  if (!self.pesquisando) {
    return self.tarefas.count;
  }
  return self.resultadoBusca.count;
  
}



@end
