#import "OsdnUtilHash.h"
#import <CommonCrypto/CommonDigest.h>

@implementation OsdnUtilHash

/**
 * Convert string to md5 hash
 *
 * @param NSString s
 * @return NSString
 */
+(NSString *)md5: (NSString *)s
{
	const char *cStr = [s UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(cStr, strlen(cStr), result);
	NSString *returnStr = [[NSString alloc] initWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
						   result[0], result[1], result[2], result[3], result[4],
						   result[5], result[6], result[7],
						   result[8], result[9], result[10], result[11], result[12],
						   result[13], result[14], result[15]
						   ];
	return [returnStr autorelease];
}

@end
