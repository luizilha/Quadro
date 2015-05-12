//
//  ViewController.m
//  Quadro
//
//  Created by LUIZ ILHA M MACIEL on 2/11/15.
//  Copyright (c) 2015 LUIZ ILHA M MACIEL. All rights reserved.
//

#import "MateriaViewController.h"
#import "TodasMateriasSingleton.h"
#import "Materia.h"
#import "AssuntoViewController.h"
#import "FotoComAnotacao.h"
#import "SWRevealViewController.h"
#import <GoogleMobileAds/GADBannerView.h>

#define MY_BANNER_ID @"ca-app-pub-3184510264135408/7952980376"

@interface MateriaViewController ()

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic) NSMutableArray *assuntos;
@property (nonatomic) NSInteger posicaoMateria;
@property (nonatomic) NSIndexPath *posicaoAlterar; // posicao para alterar
@property (nonatomic) GADBannerView *bannerView_;
@property (weak, nonatomic) IBOutlet UIButton *btnAdicionar;

@end
// sar
@implementation MateriaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
//    CGPoint point = CGPointMake(0, self.view.frame.size.height * 0.9);
//    self.bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:point];
//    self.bannerView_.backgroundColor = [UIColor whiteColor];
//    self.bannerView_.adUnitID = MY_BANNER_ID;
    
    self.bannerView_.rootViewController = self;

//    [self.view addSubview:self.bannerView_];
//    GADRequest * request = [GADRequest request];
//    [self.bannerView_ loadRequest:request];
    self.table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.btnAdicionar.titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:17];

    
    // TERMOS DE USO
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL aceito = [defaults boolForKey:@"aceito"];
    if (!aceito) {
        [self termos];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = NSLocalizedString(@"Materia", nil);
    [self.table reloadData];

}

-(void) termos {
    NSString *msg = NSLocalizedString(@"TERMOS", nil);
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"TERMOS_T", nil) message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"RECUSAR", nil) otherButtonTitles:NSLocalizedString(@"ACEITAR", nil), nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    NSString *nomeMateria = [alertView textFieldAtIndex:0].text;
    
    if ([title isEqualToString:NSLocalizedString(@"SALVAR", nil)]) {
        if ([nomeMateria length] != 0) {
            Materia *materia = [[Materia alloc] initMateria:nomeMateria];
            BOOL existe = NO;
            for (Materia *m in [[TodasMateriasSingleton sharedInstance] listaDeMaterias]) {
                if ([m.nome isEqualToString:nomeMateria]) {
                    existe = YES;
                }
            }
            if (!existe) {
                [materia savedb];
                [[[TodasMateriasSingleton sharedInstance] listaDeMaterias] addObject:materia];
                [self.table reloadData];
            }
        }
    } else if([title isEqualToString:@"Alterar"]) {
        if ([nomeMateria length] != 0) {
            Materia *materia = [[[TodasMateriasSingleton sharedInstance] listaDeMaterias] objectAtIndex:self.posicaoAlterar.row];
            BOOL existe = NO;
            for (Materia *m in [[TodasMateriasSingleton sharedInstance] listaDeMaterias]) {
                if ([m.nome isEqualToString:nomeMateria]) {
                    existe = YES;
                }
            }
            if (!existe) {
                [materia alteradb:nomeMateria];
                materia.nome = nomeMateria;
                [self.table reloadData];
            }
        }
    } else if([title isEqualToString:NSLocalizedString(@"ACEITAR", nil)]) {
        BOOL aceito = YES;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:aceito forKey:@"aceito"];
        [defaults synchronize];
    } else if([title isEqualToString:NSLocalizedString(@"RECUSAR", nil)]) {
        exit(0);
    }
}

- (IBAction)adicionaMateria:(id)sender {
    UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"MSG_ADD_MATERIA", nil) message:NSLocalizedString(@"MSG_EX_ADD_MATERIA", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"CANCELAR", nil) otherButtonTitles:NSLocalizedString(@"SALVAR", nil), nil];
    alerta.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alerta show];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identificador = @"materiaCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"materiaCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identificador];
    }
    
    
    Materia *materia = [[[TodasMateriasSingleton sharedInstance] listaDeMaterias] objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:17];
    cell.textLabel.text = materia.nome;
    cell.textLabel.textColor = [UIColor colorWithRed:0.0 green:250.0/255 blue:180.0/255  alpha:1.0];
    /// long press
    UILongPressGestureRecognizer *longPressGesture =
    [[UILongPressGestureRecognizer alloc]
     initWithTarget:self action:@selector(longPress:)];
    [cell addGestureRecognizer:longPressGesture];
    longPressGesture.minimumPressDuration = 1.0f;

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[TodasMateriasSingleton sharedInstance] listaDeMaterias] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.posicaoMateria = indexPath.row;
    [self performSegueWithIdentifier:@"segueAssunto" sender:self];
}


/* Pra apagar uma materia */
- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self.table setEditing:editing animated:animated];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remover do mutable array
        Materia *materia = [[[TodasMateriasSingleton sharedInstance] listaDeMaterias] objectAtIndex:indexPath.row];
        [materia deletedb];
        [[[TodasMateriasSingleton sharedInstance] listaDeMaterias] removeObjectAtIndex:indexPath.row];
        
        [tableView reloadData];
    }
}

/* ALTERAR NOME */
- (void)longPress:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        UITableViewCell *cell = (UITableViewCell *)[gesture view];
        NSIndexPath *indexPath = [self.table indexPathForCell:cell];
        // NSString *s = [NSString stringWithFormat: @"row=%1d",indexPath.row];
        
        Materia *materia = [[[TodasMateriasSingleton sharedInstance] listaDeMaterias] objectAtIndex:indexPath.row];
        
        NSString *titulo = [[NSString alloc]initWithFormat:@"Deseja renomear a materia %@?",materia.nome.capitalizedString];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titulo message:nil delegate:self  cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Alterar", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        self.posicaoAlterar = indexPath;
        
        [alert show];

    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueAssunto"]) {
        UINavigationController *navController = (UINavigationController *) segue.destinationViewController;
        AssuntoViewController *assunto =  navController.viewControllers[0];
        assunto.posicaoMateria = self.posicaoMateria;
        
    }
}

@end
