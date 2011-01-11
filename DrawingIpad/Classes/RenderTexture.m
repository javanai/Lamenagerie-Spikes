#import "RenderTexture.h"

@implementation RenderTexture
-(id) init
{
	if( (self = [super init]) ) {
		CGSize s = [[CCDirector sharedDirector] winSize];
		
		CCMenuItemImage *item1 = [CCMenuItemImage itemFromNormalImage:@"addcalque.jpeg" selectedImage:@"addcalque.jpeg" target:self selector:@selector(addCalqueCallBack:)];
		CCMenuItemImage *item2 = [CCMenuItemImage itemFromNormalImage:@"b1.jpeg" selectedImage:@"b1.jpeg" target:self selector:@selector(restartCallback:)];
		CCMenuItemImage *item3 = [CCMenuItemImage itemFromNormalImage:@"r1.png" selectedImage:@"r1.png" target:self selector:@selector(showAllCallback:)];
		CCMenu *menu = [CCMenu menuWithItems: item1, item2, item3, nil];
		
		menu.position = CGPointZero;
		item1.position = ccp( s.width/2 - 100,30);
		item1.scaleX=1;
		item1.scaleY=1;
		item2.position = ccp( s.width/2, 30);
		item2.scaleX=.5;
		item2.scaleY=.5;
		item3.position = ccp( s.width/2 + 100,30);
		item3.scaleX=.5;
		item3.scaleY=.5;
		[self addChild: menu z:1];	
		calqueArray= [[NSMutableArray alloc] init];
        
		target = [[CCRenderTexture renderTextureWithWidth:s.width height:s.height] retain];
		[target setPosition:ccp(s.width/2, s.height/2)];
		
		[self addChild:target z:1];
		
		brush = [[CCSprite spriteWithFile:@"fire.png"] retain];
		[brush setOpacity:20];

		self.isTouchEnabled = YES;
	}
	return self;
}


-(void) restartCallback: (id) sender
{
	CCScene *s = [CCScene node];
	[s addChild: [RenderTexture node]];
	[[CCDirector sharedDirector] replaceScene: s];
	
}

-(void) addCalqueCallBack: (id) sender
{
	CGSize s = [[CCDirector sharedDirector] winSize];
	target.visible=NO;
	[calqueArray addObject:target];
	target = [[CCRenderTexture renderTextureWithWidth:s.width height:s.height] retain];
	[target setPosition:ccp(s.width/2, s.height/2)];
	[self addChild:target z:1];
}

BOOL calqueVisible=NO;
-(void) showAllCallback: (id) sender
{
	calqueVisible=!calqueVisible;
	int i;
	for (i=0; i<[calqueArray count]; i++) {
		CCRenderTexture *calque=[calqueArray objectAtIndex:i];
		calque.visible=calqueVisible;
	}
}

-(void) saveImage:(id)sender
{
	static int counter=0;
	NSString *str = [NSString stringWithFormat:@"image-%d.png", counter];
	[target saveBuffer:str format:kCCImageFormatPNG];
	counter++;
}

-(void) dealloc
{
	[brush release];
	[target release];
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
	[super dealloc];	
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	CGPoint start = [touch locationInView: [touch view]];	
	start = [[CCDirector sharedDirector] convertToGL: start];
	[target begin];	
	
	for (int i = 0; i < 3; i++)
	{
		[brush setPosition:ccp(start.x, start.y)];
		[brush setRotation:rand()%360];
		float r = ((float)(rand()%2)/2.f) + 0.25f;
		[brush setScale:r];
	[brush visit];
	}
	[target end];
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint start = [touch locationInView: [touch view]];	
	start = [[CCDirector sharedDirector] convertToGL: start];
	CGPoint end = [touch previousLocationInView:[touch view]];
	end = [[CCDirector sharedDirector] convertToGL:end];
	
	[target begin];
	
	float distance = ccpDistance(start, end);
	if (distance > 1)
	{
		int d = (int)distance;
		for (int i = 0; i < d; i++)
		{
			float difx = end.x - start.x;
			float dify = end.y - start.y;
			float delta = (float)i / distance;
			[brush setPosition:ccp(start.x + (difx * delta), start.y + (dify * delta))];
			[brush setRotation:rand()%360];
			float r = ((float)(rand()%2)/2.f) + 0.25f;
			[brush setScale:r];

			[brush visit];
		}
	}

	[target end];
}
@end

