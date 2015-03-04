//
//  DPDownload.h
//  Owncloud iOs Client
//
// Simple download class based in complex download class of the core app.
// Valid for a document provider in order to download one file at time
//
//  Created by Gonzalo Gonzalez on 10/12/14.
//


/**
 *    @author Gonzalo Gonzalez
 *
 *    Copyright (C) 2015 ownCloud, Inc.
 *
 *    This code is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU Affero General Public License, version 3,
 *    as published by the Free Software Foundation.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *    GNU Affero General Public License for more details.
 *
 *    You should have received a copy of the GNU Affero General Public
 License, version 3,
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#import <Foundation/Foundation.h>
#import "FileDto.h"
#import "UserDto.h"
#import "FFCircularProgressView.h"

typedef NS_ENUM(NSInteger, downloadStateEnum) {
    downloadNotStarted = 0,
    downloadCheckingEtag = 1,
    downloadWorking = 2,
    downloadComplete = 3,
    downloadFailed = 4,
};


@protocol DPDownloadDelegate

@optional
- (void)downloadCompleted:(FileDto*)fileDto;
- (void)downloadFailed:(NSString*)string andFile:(FileDto*)fileDto;
- (void)downloadCancelled:(FileDto*)fileDto;
@end


@interface DPDownload : NSObject

@property (nonatomic) NSInteger state;
@property(nonatomic,weak) __weak id<DPDownloadDelegate> delegate;


- (void) downloadFile:(FileDto *)file locatedInFolder:(NSString*)localFolder ofUser:(UserDto *)user withProgressView:(FFCircularProgressView *)progressView;
- (void) cancelDownload;

@end
