/*
 * Copyright © 2014 GENBAND. All Rights Reserved.
 *
 * GENBAND CONFIDENTIAL. All information, copyrights, trade secrets
 * and other intellectual property rights, contained herein are the property
 * of GENBAND. This document is strictly confidential and must not be
 * copied, accessed, disclosed or used in any manner, in whole or in part,
 * without GENBAND's express written authorization.
 *
 */

#import <Foundation/Foundation.h>
#import "CPLogType.h"
#import "CPAdditionalInfoConstants.h"

@protocol CPLoggingDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Utility class for LogManager.
 *
 * - Since: 1.0.0
 **/

@interface CPLogManager : NSObject

/**
 * This method creates (if not already) a LogManager instance and returns it
 * @return id LogManager
 *
 * - Since: 1.0.0
 **/
+ (CPLogManager *)getInstance;

/**
 * Log method that calls the LoggingInterface implementation defined in Configuration
 * @param logLevel LogLevel which is used for checking logLevel
 * @param logContext NSString which includes package and class name
 * @param methodName SEL
 * @param logMessage NSString which includes log message
 *
 * - Since: 1.0.0
 **/
-(void)log:(CPLogLevel)logLevel withLogContext:(NSString *)logContext withMethodName:(SEL) methodName withMessage:(NSString*)logMessage;

/**
 * Log method that calls the LoggingInterface implementation defined in Configuration
 * @param logContext NSString which includes package and class name
 * @param methodName SEL
 *
 * - Since: 1.0.0
 **/
-(void) logMethodStarted:(NSString *) logContext withMethodName:(SEL) methodName;

/**
 * Log method that calls the LoggingInterface implementation defined in Configuration
 * @param logContext NSString which includes package and class name
 * @param methodName SEL
 *
 * - Since: 1.0.0
 **/
-(void) logMethodFinished:(NSString *) logContext withMethodName:(SEL)methodName;

/**
 * Sets log level of Mobile SDK
 *
 * @see CPLogLevel
 *
 * - Since: 1.0.0
 */
@property (nonatomic) CPLogLevel logLevel;

/**
 * LoggingDelegate reference used by LogManager.
 *
 * - Since: 1.0.0
 */
@property (nonatomic, strong, nullable) id<CPLoggingDelegate> delegate;

NS_ASSUME_NONNULL_END

@end
