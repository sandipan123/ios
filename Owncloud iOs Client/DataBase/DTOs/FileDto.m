//
//  FileDto.m
//  Owncloud iOs Client
//
//  Created by Javier Gonzalez on 8/6/12.
//

/**
 *    @author Javier Gonzalez
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

#import "FileDto.h"
#import "OCFileDto.h"

@implementation FileDto


///-----------------------------------
/// @name Init with OCFileDto
///-----------------------------------

/**
 * This method catch the data of OCFileDto in order to create
 * a FileDto object
 *
 * @param ocFileDto -> OCFileDto
 *
 * @return FileDto
 *
 */
- (id)initWithOCFileDto:(OCFileDto*)ocFileDto{
 
    self = [super init];
    if (self) {
        // Custom initialization
        _filePath = ocFileDto.filePath;
        _fileName = ocFileDto.fileName;
        _isDirectory = ocFileDto.isDirectory;
        _size = ocFileDto.size;
        _date = ocFileDto.date;
        _etag = ocFileDto.etag;
        _permissions = ocFileDto.permissions;
        _taskIdentifier = -1;
        _sharedFileSource = 0;
        _providingFileId = 0;
        
    }
    return self;
}

@end
