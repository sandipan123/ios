//
//  MediaViewController.h
//  Owncloud iOs Client
//
//  Created by Gonzalo Gonzalez on 05/02/13.
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

#import <MediaPlayer/MediaPlayer.h>

@protocol MediaViewControllerDelegate

@optional
- (void)fullScreenPlayer:(BOOL)isFullScreenPlayer;
@end

@interface MediaViewController : MPMoviePlayerViewController<UIGestureRecognizerDelegate>{
    
    //UI objects
    UIView  *_bottomHUD;
    UISlider *_progressSlider;
    UIButton *_playButton;
    UILabel *_leftLabel;
	UILabel *_progressLabel;
    UIButton *_fullScreenButton;
    UIImageView *_thumbnailView;   
    //Flags
    BOOL _isPlaying;
    BOOL _isFullScreen;
    BOOL _hiddenHUD;
    BOOL _isMusic;
    
    //Timer to the player
    NSTimer *_playbackTimer;
    NSTimer *_HUDTimer;
    
    //Path of the media file
    NSString *_urlString;
    
    //GestureRecognize
    UITapGestureRecognizer *_oneTap;
    
    __weak id<MediaViewControllerDelegate> _delegate;
}

@property (nonatomic, strong) UIView *bottomHUD;
@property (nonatomic, strong) UISlider *progressSlider;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *fullScreenButton;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UIImageView *thumbnailView;
@property (nonatomic) BOOL isPlaying;
@property (nonatomic) BOOL isFullScreen;
@property (nonatomic) BOOL hiddenHUD;
@property (nonatomic) BOOL isMusic;
@property (nonatomic, strong) NSTimer *playbackTimer;
@property (nonatomic, strong) NSTimer *HUDTimer;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic,strong) UITapGestureRecognizer *oneTap;
@property(nonatomic,weak) __weak id<MediaViewControllerDelegate> delegate;


/*
 * Init the control panel
 */
- (void) initHudView;

/*
 * Remove this object of observation center.
 */
- (void) removeNotificationObservation;

/*
 * Init the time labels to begin with the data of media file
 */
- (void)initTimeLabels;

/*
 * Method that manage when the user tap the play/pause button
 */
- (void) playDidTouch: (id) sender;

/*
 * Play selected file
 */
- (void) playFile;

/*
 * Pause selected file
 */
- (void) pauseFile;

/*
 * Show a frame in the middle of the video. 
 * It is called when the video finish
 */
- (void)showImageOfVideo;

/*
 * Change the playback time in the player
 */
- (void)changePlayBackTime:(float)currentTime;


/*
 * Method that indicate that the player not in use
 */
- (void)finalizePlayer;


@end
