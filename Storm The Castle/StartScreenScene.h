#import "cocos2d.h"

@interface StartScreenLayer : CCLayerColor {
    CCLabelTTF *_label;
}
@property (nonatomic, retain) CCLabelTTF *label;
@end

@interface StartScreenScene : CCScene {
    StartScreenLayer *_layer;
}
@property (nonatomic, retain) StartScreenLayer *layer;
@end