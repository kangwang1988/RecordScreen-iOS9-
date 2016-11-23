# RecordScreen-iOS9+

![Icon](https://raw.githubusercontent.com/kangwang1988/RecordScreen-iOS9-/master/recordscreen.gif)

## Overview

RecordScreen-iOS9+ is a project which implements screen recording in iOS9 and above.
## Feature
	a.A video recording your screen in your app with ReplayKit.
	b.Red dots indicating user action.
	c.A log file for user action locating in the /path-to-your-app's-document-directory/nkrecordscreen/log.txt.
### How to Use
It starts when your application becomes active and saves the videos timely.If you want to do it yourself,call like below:

	StartRecording:[[NKRecordManager sharedInstance] startRecording];
	StopRecording:[[NKRecordManager sharedInstance] stopRecording];
	
### Installation
####Using CocoaPods:
	Just add this line to your Podfile:
	pod 'RecordScreen-iOS9-', '~> 0.1.0'
####Manually:
    Simply add those files .h and .m files to your project.
    
### Flaws
	Apple's ReplayKit seems to hide some content when recording, like the statusbar, UIActionSheet,etc. I guess it might due to their consideration to user's privacy.
	On the other side, I did some kind of method swizzle in order to save the video automatically, that is to say, it might be rejected by the review team for use of private api.You can disable it by remove those method-swizzle-related category codes if needed.	
#### License
RecordScreen-iOS9+ is released under the MIT license. See LICENSE for details.
