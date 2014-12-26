#import <UIKit/UIKit.h>

typedef enum  
{
	CustomCellBackgroundViewPositionTop, 
	CustomCellBackgroundViewPositionMiddle, 
	CustomCellBackgroundViewPositionBottom,
	CustomCellBackgroundViewPositionSingle
} CustomCellBackgroundViewPosition;

@interface OSDNUITableCellView : UIView {
	
	CustomCellBackgroundViewPosition position;
	UIColor *fillColor;
	UIColor *borderColor;
	float roundSize;
}

@property(nonatomic) CustomCellBackgroundViewPosition position;
@property(nonatomic,retain) UIColor *borderColor, *fillColor;

-(void)setPositionCredentialsRow:(NSInteger)row count:(NSInteger)count;
- (id)initWithRountRect:(float)_roundSize;

@end
