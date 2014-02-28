//
//  PRViewController.m
//  Persistencia
//
//  Created by Acácio Veit Schneider on 24/02/14.
//  Copyright (c) 2014 Acácio Veit Schneider. All rights reserved.
//

#import "PRViewController.h"
#import "KeychainItemWrapper.h"
#import "PRAppDelegate.h"

@interface PRViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtUsuario;
@property (weak, nonatomic) IBOutlet UITextField *txtSenha;
@property (weak, nonatomic) IBOutlet UIButton *btnEntrar;

@end

@implementation PRViewController

- (void)viewDidLoad {
  
  [super viewDidLoad];
  [self.txtUsuario becomeFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated {
  
  [super viewWillAppear:animated];
  [self carregarCor];
}

- (void) carregarCor {
  
  [self.btnEntrar setTitleColor: (UIColor *)[(PRAppDelegate *)[[UIApplication sharedApplication] delegate] globalTint]
                       forState:UIControlStateNormal];
  [self.txtSenha setTintColor: (UIColor *)[(PRAppDelegate *)[[UIApplication sharedApplication] delegate] globalTint]];
  [self.txtUsuario setTintColor: (UIColor *)[(PRAppDelegate *)[[UIApplication sharedApplication] delegate] globalTint]];
}

- (IBAction)clickEntrar:(id)sender {
  
  NSString *textoUsuario = [self.txtUsuario.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  if ([textoUsuario isEqualToString: @""]) {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Campo não preenchido"
                                                        message:@"Por favor, preencha o campo do usuário"
                                                       delegate: self
                                              cancelButtonTitle: nil
                                              otherButtonTitles:@"OK", nil];
    [alertView show];
    [self.txtUsuario becomeFirstResponder];
    return;
  }
  
  NSString *textoSenha = [self.txtSenha.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  if ([textoSenha isEqualToString: @""]) {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Campo não preenchido"
                                                        message:@"Por favor, preencha o campo da senha."
                                                       delegate: self
                                              cancelButtonTitle: nil
                                              otherButtonTitles:@"OK", nil];
    [alertView show];
    [self.txtSenha becomeFirstResponder];
    return;
  }
  
  if ([self validarLogin]) {
    
    [self performSegueWithIdentifier:@"goToInicial" sender: sender];
    return;
  }
  
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Dados incorretos"
                                                      message:@"Os dados não conferem com o seu cadastro, por favor, revise-os."
                                                     delegate: self
                                            cancelButtonTitle: nil
                                            otherButtonTitles:@"OK", nil];
  [alertView show];
}

-(BOOL) validarLogin {
  
  // Keychain
	KeychainItemWrapper *keychainPassword = [[KeychainItemWrapper alloc] initWithIdentifier:@"Password" accessGroup:nil];
	
  NSString *usuarioKeyChain = [keychainPassword objectForKey:(__bridge id)kSecAttrAccount];
  NSString *senhaKeyChain   = [keychainPassword objectForKey:(__bridge id)kSecValueData];
	
  if ([senhaKeyChain isEqualToString: @""] && [usuarioKeyChain isEqualToString:@""]) {
    
    [keychainPassword setObject: self.txtUsuario.text forKey:(__bridge id)kSecAttrAccount];
    [keychainPassword setObject: self.txtSenha.text forKey:(__bridge id)kSecValueData];
    return YES;
  } else {
    
    if ([senhaKeyChain isEqualToString: self.txtSenha.text] && [usuarioKeyChain isEqualToString: self.txtUsuario.text]) {
      return YES;
    }
    return NO;
  }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
  
  if ([textField isEqual:self.txtUsuario]) {
    
    [self.txtSenha becomeFirstResponder];
    return YES;
  }
  
  if ([textField isEqual:self.txtSenha]) {
    
    [textField resignFirstResponder];
    [self clickEntrar:textField];
    return YES;
  }
  return YES;
}

@end
