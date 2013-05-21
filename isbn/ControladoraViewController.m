//
//  ControladoraViewController.m
//  isbn
//
//  Created by moviles on 3/9/13.
//  Copyright (c) 2013 moviles. All rights reserved.
//

#import "ControladoraViewController.h"

@interface ControladoraViewController ()

@end

@implementation ControladoraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.txtISBN.text = @"843760494X";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBuscar:(id)sender {
    [self buscaISBN];
}

- (IBAction)searchISBN:(id)sender {
    [self buscaISBN];
}

-(void)buscaISBN{
    
    NSFetchRequest *req = NSFetchRequest.new;
    NSEntityDescription *libro = [NSEntityDescription entityForName:@"Libro" inManagedObjectContext:self.moc];
    req.entity = libro;
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"isbn = %@", self.txtISBN.text];
    req.predicate = filter;
    NSArray *res = [self.moc executeFetchRequest:req error:nil];
    if (res.count != 0){
        id obj = res[0];
        self.txtTitulo.text = [obj valueForKey:@"titulo"];
        self.txtSubtitulo.text = [obj valueForKey:@"subtitulo"];
        return;
    }
    
    @try{
        NSString *isbn= self.txtISBN.text;
        NSLog(@"%@", isbn);
        
        NSString *dir = [NSString stringWithFormat:@"http://openlibrary.org/api/books?bibkeys=ISBN:%@&jscmd=data&format=json", isbn];
        NSLog(@"%@",dir);
        
        NSURL *url = [NSURL URLWithString:dir];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSDictionary *dico1 = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSString *isbnStr = [NSString stringWithFormat:@"ISBN:%@", isbn];
        NSString *title = dico1[isbnStr][@"title"];
        NSString *subtitle = dico1[isbnStr][@"subtitle"];
        
        
        NSLog(@"%@", dico1);
        NSLog(@"%@", title);
        NSLog(@"%@", subtitle);
        
        self.txtTitulo.text = title;
        self.txtSubtitulo.text = subtitle;
        
        
        NSDictionary *authors = dico1[isbnStr][@"authors"];
        
        NSLog(@"%d", authors.count);
        NSMutableString *strAuthors = [NSMutableString string];
        
        for(int i =0; i< authors.count; i++){
            [strAuthors appendString:[NSString stringWithFormat:@"%@", dico1[isbnStr][@"authors"][i][@"name"]]];
            NSLog(@"%@", dico1[isbnStr][@"authors"][i][@"name"]);
        }
        
        self.txtAutores.text = strAuthors;
        
        
        NSManagedObject *libro1 = [NSEntityDescription insertNewObjectForEntityForName:@"Libro" inManagedObjectContext:self.moc];
        [libro1 setValue:self.txtISBN.text forKey:@"isbn"];
        [libro1 setValue:self.txtTitulo.text forKey:@"titulo"];
        [libro1 setValue:self.txtSubtitulo.text forKey:@"subtitulo"];
        [self.moc save:nil];
    }
    @catch (NSException *exception) {
        UIAlertView *av = [[UIAlertView alloc]
                           initWithTitle:@"Sin Conexíon" message:@"Por favor conectate a la red" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [av show];
    }
    
}
@end
