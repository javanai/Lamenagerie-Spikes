#import "Cocos2d.h"

@class Sprite;



@interface RenderTexture : CCLayer
{
	CCRenderTexture* target;
	CCSprite* brush;
	NSMutableArray *calqueArray;
	
}
@end





