//
//  ViewController.m
//  Assessment4
//
//  Created by Vik Denic on 8/11/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "ViewController.h"
#import "DogsViewController.h"
#import "Owner.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property UIAlertView *addAlert;
@property UIAlertView *colorAlert;
@property NSArray *owners;
@property NSNumber *jsonOwnersLoaded;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Dog Owners";
    self.owners = [NSArray array];

    [self loadDogOwners];
    [self checkForDefaultLoad];
    [self loadDefaultColor];
}

#pragma mark - UITableView Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.owners.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"myCell"];
    Owner *owner = [self.owners objectAtIndex:indexPath.row];
    cell.textLabel.text = owner.name;
    return cell;
}

#pragma mark - UIAlertView Methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //TODO: SAVE USER'S DEFAULT COLOR PREFERENCE USING THE CONDITIONAL BELOW
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *defaultColor = [NSData data];


    if (buttonIndex == 0)
    {
        self.navigationController.navigationBar.tintColor = [UIColor purpleColor];
       defaultColor = [NSKeyedArchiver archivedDataWithRootObject:[UIColor purpleColor]];
    }
    else if (buttonIndex == 1)
    {
        self.navigationController.navigationBar.tintColor = [UIColor blueColor];
        defaultColor = [NSKeyedArchiver archivedDataWithRootObject:[UIColor blueColor]];
    }
    else if (buttonIndex == 2)
    {
        self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
        defaultColor = [NSKeyedArchiver archivedDataWithRootObject:[UIColor orangeColor]];
    }
    else if (buttonIndex == 3)
    {
        self.navigationController.navigationBar.tintColor = [UIColor greenColor];
        defaultColor = [NSKeyedArchiver archivedDataWithRootObject:[UIColor greenColor]];
    }

    [userDefaults setObject:defaultColor forKey:@"DefaultColor"];
}

//METHOD FOR PRESENTING USER'S COLOR PREFERENCE
- (IBAction)onColorButtonTapped:(UIBarButtonItem *)sender
{
    self.colorAlert = [[UIAlertView alloc] initWithTitle:@"Choose a default color!"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Purple", @"Blue", @"Orange", @"Green", nil];
    self.colorAlert.tag = 1;
    [self.colorAlert show];
}

-(void)loadDefaultColor
{
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"DefaultColor"];

    if (colorData != nil) {
        UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        self.navigationController.navigationBar.tintColor = color;
    }
}

-(void)getDogOwners
{
    NSURL *url = [NSURL URLWithString:@"http://s3.amazonaws.com/mobile-makers-assets/app/public/ckeditor_assets/attachments/25/owners.json"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];

        for (NSArray *owner in json) {
            NSManagedObject *newOwner = [NSEntityDescription insertNewObjectForEntityForName:@"Owner" inManagedObjectContext:self.managedObjectContext];

            [newOwner setValue:owner forKey:@"name"];
            [self.managedObjectContext save:nil];

            NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Owner"];
            self.owners = [self.managedObjectContext executeFetchRequest:request error:nil];
            [self.myTableView reloadData];
        }

        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSNumber *defaultsLoaded = @1;
        [userDefaults setObject:defaultsLoaded forKey:@"DefaultsLoaded"];
        [userDefaults synchronize];
    }];

}

-(void)loadDogOwners
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Owner"];
    NSSortDescriptor *byOwnerName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];

    request.sortDescriptors = [NSArray arrayWithObjects:byOwnerName, nil];

    self.owners = [self.managedObjectContext executeFetchRequest:request error:nil];
    [self.myTableView reloadData];
}

- (void)checkForDefaultLoad
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.jsonOwnersLoaded = [userDefaults objectForKey:@"DefaultsLoaded"];

    if (!(self.jsonOwnersLoaded.integerValue == 1))
    {
        [self getDogOwners];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)cell
{
    DogsViewController *viewController = [segue destinationViewController];
    viewController.owner = [self.owners objectAtIndex:[self.myTableView indexPathForSelectedRow].row];
}

@end
