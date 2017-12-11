//
//  ServerConstants.swift
//  SwiftSamples
//
//  Created by Nitin Kumar on 15/06/17.
//  Copyright © 2017 Nitin Kumar. All rights reserved.
//

import Foundation
import UIKit


//MARK - Base Url
struct SERVER {
    static let kBASE_URL                        = "http://demo.evirtualservices.com/Glimpse/site/webservices"
    
    static let kSERVER_CONN = "Server connecction faild! Please try later."
}

//MARK - Url Methods
struct APIMETHOD {
    
    static let kAPI_LOGIN                        = "login"
    static let kAPI_REGISTRATION                 = "registration"
    static let kAPI_LOGOUT                       = "logout"
    static let kAPI_FORGOT_PWD                   = "forgatpassword"
    static let kAPI_EDIT_PROFILE                 = "editprofile"
    static let kAPI_CHANGE_PROFILE_PIC           = "changeProfilePic"
    static let kAPI_CHANGE_PWD                   = "changePassword"
    static let kAPI_PROFILE_DETAILS              = "profileDetails"
    static let kAPI_QUICK_SEARCH                 = "quickSearch"
    static let kAPI_UPLOAD_GALLERY_IMAGE         = "uploadImageInGallery"
    static let kAPI_GET_GALLARY                  = "getGallary"
    static let kAPI_DELETE_GALLERY_IMAGE         = "deletegallery"
    static let kAPI_UPLOAD_GALLERY_VIDEO         = "uploadVideoInGallery"
    static let kAPI_DELETE_GALLERY_VIDEO         = "deleteVideoGallary"
    static let kAPI_GET_VIDEO_GALLARY            = "getVideoGallary"
    static let kAPI_LIKE_COMMENT_PROFILE         = "ProfilelikesAndComments"
    static let kAPI_GET_LIKE_COMMENTS            = "getProfilelikesAndComments"
    static let kAPI_MAKE_FAVOURITE               = "makeFavourite"
    static let kAPI_MY_FAVOURITE_LIST            = "myFavouriteList"
    static let kAPI_GET_OPTIONS_BY_QUESTION      = "getOptionByQuestion"
    static let kAPI_UPDATE_ADVANCE_OPTION        = "updateProfileAdvanceOption"
    static let kAPI_ADD_IN_CALENDAR              = "addInCalendar"
    static let kAPI_GET_CALENDAR                 = "getCalendar"
    static let kAPI_NEAR_BY_USERS                = "nearByUsers"
    // GET USER FOR CHAT
    
    static let kAPI_GET_ALL_USERS                = "quicboxUsers"
    static let kAPI_CREATE_POST                  = "createPost"
    static let kAPI_GET_POST                     = "getPost"
    static let kAPI_COMMENT_ON_POST              = "commentOnPost"
    static let kAPI_LIKE_ON_POST                 = "commentOnPost"
    static let kAPI_GET_POST_LIKE_USERS          = "getPostLikeUsers"
    static let kAPI_GET_NOTIFICATIONS            = "notificationList"
    static let kAPI_GET_POST_DETAILS             = "getPostDetails"

}

//MARK - Keywords
struct USER {
    
    static let kUSERID                           = "userId"
    static let kUSER_ID                          = "user_id"
    static let kUSER_EMAIL                       = "emailId"
    static let kUSER_PWD                         = "password"
    static let kUSER_FIRST_NAME                  = "firstName"
    static let kUSER_MOBILE                      = "mobile"
    static let kUSER_ADDRESS                     = "address"
    static let kUSER_ZIPCODE                     = "zipcode"
    static let kUSER_IMG                         = "image"
    static let kUSER_FIREBASE_ID                 = "firebaseId"
    static let kUSER_OLD_PWD                     = "oldPassword"
    static let kUSER_NEW_PWD                     = "newPassword"
    static let kUSER_PROFILE_IMAGE               = "profile_image"
    static let kUSER_IMAGE                       = "image"
    static let kUSER_DOB                         = "dob"
    static let kUSER_GENDER                      = "gender"
    static let kUSER_SEEKING                     = "seeking"

    static let kOTHER_USERID                     = "profileId"
    static let kQUESTION                         = "question"
    static let kLATITUDE                         = "latitude"
    static let kLONGITUDE                        = "longitude"


    
}

//MARK: - GROUP STUCTURE

struct GRP {
    
    // GRP NAME
    static let kGRP_NAME                        = "groupName"
    
    static let kGRP_DESC                        = "description"
    
    static let kGRP_MEMBER_ID                   = "mamberId"
    
     static let kGRP_ID                         = "groupId"
    
    static let kGRP_IMG                         = "groupImage"
    
}

struct PARAMETER {
    
    // Country
     static let kPARA_COUNTRY_ID               = "countryId"
    static let kPARA_STATE_ID                  = "stateId"
    static let kPARA_CITY_ID                   = "cityId"
    
    
    
    
  
}

//SCHOOL
struct SCHOOL {
    
   static let kSCHOOL                          =   "school"
   static let kCOUNTRY                         =   "country"
   static let kSTATE                           =   "state"
   static let kCITY                            =   "city"
    
    
    
    static let kSCHOOL_ID                          =   "school_id"
    static let kCOUNTRY_ID                         =   "country_id"
    static let kSTATE_ID                           =   "state_id"
    static let kCITY_ID                            =   "city_id"
    
}

struct CLASS {
    
    static let kTEACHER                        =   "teacher"
    static let kTYPE                           =   "type"
    static let kPERIODS                        =   "period"
    static let kSUBJECT                        =   "subject"
    
     static let kCLASS                          =   "class"
}

//MARK - Extra
struct DEVICE {
    
    static let kDEVICE                        = "device"
    static let kDEVICE_NAME                   = "ios"
    static let kDEVICE_TOKEN                  = "deviceToken"
}


struct ACTION {
    
    static let kAPI_ACTION                     = "action"
}


struct EXTRA {
    
     static let kAPI_STATUS                    = "status"
     static let kAPI_STATUS_SUCCESS            = "Success"
     static let kAPI_MSG                       = "msg"
     static let kAPI_RESPONSE                  = "response"
     static let kAPI_LOGIN_DATA                = "loginInfo"
    static let kAPI_OPTIONS                = "options"
    static let kAPI_PAGE_NO                    = "page"
    
}


struct QUICKBLOX
{
    static let QUICKBLOX_ID                        = "quickbloxID"
}
