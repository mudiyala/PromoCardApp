//
//  PromotionDetailViewController.m
//  PromoCard
//
//  Created by Krishna Mudiyala on 22/02/16.
//  Copyright (c) 2016 Krishna Mudiyala. All rights reserved.
//

#import "PromotionDetailViewController.h"
#import "ThemeManager.h"
#import "PromotionPath.h"
#import "AutoLayoutUtility.h"

@interface PromotionDetailViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *promoImageView;

@property (strong, nonatomic) IBOutlet UILabel *promoSummary;

@property (strong, nonatomic) IBOutlet UILabel *promoFooter;

@property(strong, nonatomic) IBOutlet UIButton *promoButton;

@property(strong, nonatomic) IBOutlet UIButton *promoFooterButton;

@end

@implementation PromotionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
    self.title = self.promotionEntity.title;
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[self.promotionEntity.footer dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    
    self.promoFooter.attributedText = attrStr;
    self.promoFooter.textAlignment = NSTextAlignmentRight;
    self.promoSummary.text = self.promotionEntity.summary;
    self.promoSummary.textColor = [UIColor whiteColor];
    self.promoImageView.image = [UIImage imageNamed:@"placeholderImage"];
    self.promoImageView.contentMode = UIViewContentModeCenter;
    [self.promoButton setTitle:self.promotionEntity.promotionPath.title forState:UIControlStateNormal];
    [self.promoButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),^{
        [self loadImage];
    });
}

-(void)loadImage{
    
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.promotionEntity.imageName]];
        
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        
        UIImage* image = [[UIImage alloc] initWithData:imageData];
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.promoImageView.contentMode = UIViewContentModeScaleAspectFill;
                
                self.promoImageView.image = image;
                
            });
        }
    
}

-(void)initView{
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.promoImageView = [[UIImageView alloc] init];
    self.promoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.promoImageView];
    
    self.promoFooter = [[UILabel alloc] init];
    self.promoFooter.backgroundColor = [UIColor clearColor];
    self.promoFooter.font = [ThemeManager footerTextFont];
    self.promoFooter.numberOfLines = 0;
    self.promoFooter.lineBreakMode = NSLineBreakByWordWrapping;
    self.promoFooter.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.promoFooter];
    
    self.promoSummary = [[UILabel alloc] init];
    self.promoSummary.textColor = [UIColor darkGrayColor];
    self.promoSummary.backgroundColor = [UIColor clearColor];
    self.promoSummary.font = [ThemeManager summaryTextFont];
    self.promoSummary.numberOfLines = 0;
    self.promoSummary.textAlignment = NSTextAlignmentCenter;
    self.promoSummary.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.promoSummary];
    
    
    self.promoButton = [[UIButton alloc] init];
    self.promoButton.translatesAutoresizingMaskIntoConstraints =NO;
    [self.promoButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 20.0, 0.0, 0.0)];
    [self.promoButton setTitle:self.promotionEntity.promotionPath.title forState:UIControlStateNormal];
    [self.promoButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.promoButton.titleLabel setFont:[ThemeManager buttonTextFont]];
    [self.promoButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:self.promoButton];
    
    
    self.promoFooterButton = [[UIButton alloc] init];
    self.promoFooterButton.translatesAutoresizingMaskIntoConstraints =NO;
    [self.promoFooterButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 20.0, 0.0, 0.0)];
    [self.promoFooterButton setTitle:@"" forState:UIControlStateNormal];
    [self.promoFooterButton addTarget:self action:@selector(buttonFooterClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.promoFooterButton];
    
    NSDictionary *viewsDictionary = @ {
        @"promoImageView":self.promoImageView,
        @"promoFooter": self.promoFooter,
        @"promoSummary":self.promoSummary,
        @"promoButton": self.promoButton,
        @"promoFooterButton":self.promoFooterButton
    };
    
    CONSTRAIN_VIEWS(self.view, @"V:|-(5)-[promoImageView]-(5)-|", viewsDictionary);
    
    CONSTRAIN_VIEWS(self.view, @"H:|-(15)-[promoImageView]-|", viewsDictionary);
    
   CENTER_VIEW_V(self.view, self.promoSummary);
   
    CONSTRAIN_VIEWS(self.view, @"V:[promoSummary]-[promoButton]", viewsDictionary);
    CONSTRAIN_VIEWS(self.view, @"H:|-[promoSummary]-|", viewsDictionary);
    CONSTRAIN_VIEWS(self.view, @"H:|-[promoButton]-|", viewsDictionary);
    
    CONSTRAIN_VIEWS(self.view, @"H:|-[promoFooter]-|", viewsDictionary);
    CONSTRAIN_VIEWS(self.view, @"H:|-[promoFooterButton]-|", viewsDictionary);
    
    
    CONSTRAIN_VIEWS(self.view, @"V:[promoFooter(>=20)]-(30)-|", viewsDictionary);
    CONSTRAIN_VIEWS(self.view, @"V:[promoFooterButton]-(30)-|", viewsDictionary);
}

-(void)buttonFooterClicked:(UIButton*)sender{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.promotionEntity.promotionPath.path]];
    
}

-(void)buttonClicked:(UIButton*)sender{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.promotionEntity.promotionPath.path]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(NSString *) stringByStrippingHTML:(NSString*)str {
    NSRange r;
    while ((r = [str rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        str = [str stringByReplacingCharactersInRange:r withString:@""];
    return str;
}
@end

