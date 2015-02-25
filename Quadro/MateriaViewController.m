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

@interface MateriaViewController ()

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic) NSMutableArray *assuntos;
@property (nonatomic) NSInteger posicaoMateria;

@end
// sar
@implementation MateriaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.table reloadData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *nomeMateria = [alertView textFieldAtIndex:0].text;
        Materia *materia = [[Materia alloc] initMateria:nomeMateria];
        [[[TodasMateriasSingleton sharedInstance] listaDeMaterias] insertObject:materia atIndex:0];
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.table insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (IBAction)adicionaMateria:(id)sender {
    UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Digite nome da materia" message:@"Ex: calculo" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Salvar", nil];
    alerta.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alerta show];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identificador = @"materiaCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identificador];
    Materia *materia = [[[TodasMateriasSingleton sharedInstance] listaDeMaterias] objectAtIndex:indexPath.row];
    cell.textLabel.text = materia.nome;
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.textColor = [UIColor whiteColor];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier  isEqual: @"segueAssunto"]) {
        AssuntoViewController *view = [segue destinationViewController];
        view.posicaoMateria = self.posicaoMateria;
    }
}


@end