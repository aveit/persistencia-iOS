//
//  PRConfiguracoesViewController.m
//  Persistencia
//
//  Created by Acácio Veit Schneider on 25/02/14.
//  Copyright (c) 2014 Acácio Veit Schneider. All rights reserved.
//

#import "PRConfiguracoesViewController.h"
#import "InfColorPicker.h"
#import "PRAppDelegate.h"

@interface PRConfiguracoesViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnCor;
@property (strong, nonatomic) NSArray *fontes;
@property (weak, nonatomic) IBOutlet UITextField *txtTamanho;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerFonte;
@property (weak, nonatomic) IBOutlet UIButton *btnSalvar;

@end

@implementation PRConfiguracoesViewController

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  self.fontes = [[NSArray alloc] initWithArray: [UIFont familyNames]];
  [self lerConfiguracoes];
  
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(dismissKeyboard)];
  
  [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
  [self.txtTamanho resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated {
  
  [super viewWillAppear:animated];
  [self carregarCor];
}

-(void) carregarCor {
  
  [self.btnSalvar setTitleColor: (UIColor *)[(PRAppDelegate *)[[UIApplication sharedApplication] delegate] globalTint]
                       forState: UIControlStateNormal];
  
  [self.tabBarController.tabBar setTintColor: (UIColor *)[(PRAppDelegate *)[[UIApplication sharedApplication] delegate] globalTint]];
  [self.txtTamanho setTintColor: (UIColor *)[(PRAppDelegate *)[[UIApplication sharedApplication] delegate] globalTint]];
}

- (IBAction)clickSalvar:(UIButton *)sender {
  
  UIColor *color = [self.btnCor backgroundColor];
  NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
  
  NSInteger row = [self.pickerFonte selectedRowInComponent:0];
  
  [[NSUserDefaults standardUserDefaults] setObject: [self.fontes objectAtIndex:row] forKey:@"fonte"];
  [[NSUserDefaults standardUserDefaults] setObject: self.txtTamanho.text forKey: @"tamanhofonte"];
  [[NSUserDefaults standardUserDefaults] setObject: colorData forKey: @"cor"];
  
  PRAppDelegate *delegate = (PRAppDelegate *)[[UIApplication sharedApplication] delegate];
  delegate.globalTint = color;
  
  [self carregarCor];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  [[[UIAlertView alloc] initWithTitle:@"Salvo com sucesso"
                              message:@"Configurações salvas com sucesso"
                             delegate:self
                    cancelButtonTitle:nil
                    otherButtonTitles:@"OK", nil] show];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark picker
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
  
  return [self.fontes objectAtIndex:row];
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  
  return self.fontes.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

//Lê as configurações do NSUserDefaults e 'adapta' os elementos da tela
-(void) lerConfiguracoes {
  
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  UIColor *color = [(PRAppDelegate *)[[UIApplication sharedApplication] delegate] globalTint];
  [self.btnCor setBackgroundColor: color];
  
  if ([userDefaults objectForKey:@"fonte"] != nil) {
    
    //Busca a fonte do NSUserDefaults
    NSString *fontName = [[NSUserDefaults standardUserDefaults] objectForKey:@"fonte"];
    [self.pickerFonte selectRow:[self.fontes indexOfObject:fontName] inComponent:0 animated:YES];
  }
  
  if ([userDefaults objectForKey:@"tamanhofonte"] == nil) {
    self.txtTamanho.text = [NSString stringWithFormat: @"%d", 15];
  } else {
    self.txtTamanho.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"tamanhofonte"];
  }
}

- (IBAction)clickCor:(UIButton *)sender {
  
  InfColorPickerController *picker = [InfColorPickerController colorPickerViewController];
  picker.sourceColor = self.btnCor.backgroundColor;
  picker.delegate = self;
  [picker presentModallyOverViewController: self];
}

- (void) colorPickerControllerDidFinish: (InfColorPickerController*) picker {
  
  [self.btnCor setBackgroundColor: picker.resultColor];
  [self dismissViewControllerAnimated:YES completion: nil];
}

@end
