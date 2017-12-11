//
//  AppConstants.swift
//  SwiftSamples
//
//  Created by Nitin Kumar on 13/06/17.
//  Copyright © 2017 Nitin Kumar. All rights reserved.
//

import Foundation
import UIKit


struct AppStore {
    
    static let appID                       = "313719"
}

//MARK - Constant
struct APP_CONST {
    
    static let build_name                       = "Glimpse"
    static let kOK                              = "OK"
    static let kCANCEL                          = "CANCEL"
    static let kCAMERA                          = "Camera"
    static let kGALARY                          = "Galary"
    static let kLOGOUT_CONFIRMATION             = "Are you sure you want to logout?"
    static let kLOGOUT                          = "LOGOUT"
    static let kREMOVE                          = "REMOVE"
    
    static let kLOGIN                           = "LOGIN"
    static let kNETWORK_ISSUE                   = "The Internet connection appears to be offline."
   static let kFREATURE_NOT_IMPLIMENT           = "This feature is not implemented yet."
   static let kLOGIN_CONFIRM                    = "You’ve successfully logged in!"
   static let kDEVICE_NOT_SUPPORT               = "Your Device is not compatible with this features."
    static let kMAKE_ADMIN                      = "MAKE ADMIN"
    static let kEXIT                            = "EXIT"
}

struct APP_VALIDATION {
    
     static let kMSG_EMPTY_FIELDS                       = "Fields can't be blank!"
     static let kMSG_VALID_MAIL                         = "Please enter a valid Email ID!"
     static let kMSG_NAME_LENGTH                        = "Full Name would be minimum 2 characters."
     static let kMSG_ADDRESS_LENGTH                     = "Address would be minimum 2 characters.";
    static let kMSG_PHONE_NUMBER                            = "Phone number would be 10 digits."
    
     static let kMSG_MAIL_MISSMATCH                     = "E-mail address and confirm E-mail address is missmatch."
    
     static let kMSG_PWD_LANGHT                         = "Password would be minimum 8 characters."
    
     static let kMSG_CONFIRM_PWD                        = "Password and confirm password is missmatch!"
    
     static let kMSG_COUNTRY_SELECT                        = "Please select a country first!"
    
     static let kMSG_STATE_SELECT                      = "Please select a State first!"
    
     static let kMSG_CITY_SELECT                        = "Please select a City first!"
    static let kMSG_SUBJECT_LENGTH                     = "Subject would be minimum 2 characters.";
    
    static let kMSG_TEACHER_NAME_LENGTH                     = "Teacher name would be minimum 2 characters.";
}

//MARK - StoryBoard identificatin constant
struct SB_ID {
    
    static let SBI_WELCOME_VC                           = "GlimpseViewController"
    static let SBI_PAGE_VC                              = "PageViewController"
    static let SBI_PAGECONTENT_VC                       = "PageContentViewController"
    static let SBI_LOGIN_VC                             = "LoginViewController"
    static let SBI_REGISTER_VC                          = "RegisterViewController"
    static let SBI_FORGOT_PWD_VC                        = "ForgotPasswordViewController"
    static let SBI_DASHBOARD_VC                         = "DashboardViewController"
    static let SBI_GENDER_PICKING_VC                    = "GenderViewController"
    static let SBI_SEEKING_GENDER_PICKING_VC            = "SeekingViewController"
    static let SBI_FULLNAME_PICKING_VC                  = "FullNameViewController"
    static let SBI_UPDATE_PROFILE_PIC_VC                = "UpdateProfilePicViewController"
    static let SBI_BODY_TYPE_VC                         = "BodyTypeViewController"
    static let SBI_HAVE_CHILDRENS_VC                    = "HaveChildrenViewController"
    static let SBI_HIGHEST_EDUCATION_VC                 = "HightestEducationViewController"
    
     static let SBI_YOUR_ETHENICITY_VC                  = "YourEthenicityViewController"
     static let SBI_YOUR_HEIGHT_VC                      = "YourHeightViewController"
     static let SBI_YOUR_RELIGION_VC                    = "YourReligionViewController"
     static let SBI_YOU_SMOKE_VC                        = "DoYouSmokeViewController"
     static let SBI_WELCOME_GLIMPSE_VC                   = "WelcomeToGlimpseViewController"
    
     static let SBI_USER_PROFILE_VC                     = "UserProfileTableViewController"
     static let SBI_VIDEO_CALL_VC                        = "VideoCallViewController"
    

}

//MARK- COLOR CODE

struct COLOR_CODE {
    
    static let NAVCOLOR_PURPULE                = "#2A57A0"
    static let COLOR_TXTBORDER                 = "#DCDCDC"
    static let COLOR_LINE                      = "#BBBBBB"
    static let COLOR_TEXTFIELD_BG              = "#E4E4E4"
    static let COLOR_REGISTER_BUTTON           = "#FF3B55"
    static let COLOR_TEXTFILED_PLACEHOLDER     = "#D4D2D5"
    static let COLOR_IMAGEVIEW_BORDER          = "#4C4B56"
    static let COLOR_EVEN_CELL                 = "#FFFFFF"
    static let COLOR_ODD_CELL                  = "#F5F5F5"
    static let COLOR_TEXTFIELD_SEARCH          = "#FF3B55"
    static let COLOR_INDICATOR                 = "#FA5667"
    static let COLOR_LOGIN_BG                  = "#9D4399"
    static let COLOR_LOGIN_BUTTON              = "#00C1D0"
    static let COLOR_HOME_HEADER               = "#2D3E58"
    static let COLOR_FULNAME_PLACEHOLDER       = "#2DC1D0"
    static let COLOR_FULNAME_TEXTFIELD_BORDER  = "#EAEAEA"
    
    // RAM COLORS
    static let NAVCOLOR                        = "#2B57A0"
    static let DASHBOARD_BG_COLOR              = "#9D4399"
    static let DASHBOARD_MESSAGE_VIEW          = "#2D5DAB"
    static let DASHBOARD_DATE_VIEW             = "#29B4C2"
    static let DASHBOARD_VIDEO_CHAT_VIEW       = "#2DC2D1"
    static let DASHBOARD_TEMP_VIEW             = "#2FC895"
    static let DASHBOARD_UPPER_HEADER          = "#2D3E58"
    static let COLOR_APPICON                   = "#9D4399"
    static let COLOR_BOTTOM_SHADOW             = "#2D3D57"
    
    
    // CLANEDAR
    
   
    
    static let COLOR_HRS                       = "#F4797C"
  
}

// MARK - Image name
struct IMG_NAME {
    
    static let radio_select                      = "fill_radio.png"
    static let radio_unselect                    = "blank_radio.png"
    
    
}


struct FONT {
    
     static let kFONT_REGULAR                = "HelveticaNeue"
     static let kFONT_BOLD                   = "HelveticaNeue-Bold"
     static let kFONT_MEDIUM                 = "HelveticaNeue-Medium"
     static let kFONT_BOLD_TLALIC            = "HelveticaNeue-BoldItalic"
     static let kFONT_CONDENSED_BLACK        = "HelveticaNeue-CondensedBlack"
     static let kFONT_MEDIUM_ITALIC          = "HelveticaNeue-MediumItalic"
     static let kFONT_ULTRA_LIGHT            = "HelveticaNeue-UltraLight"
     static let kFONT_LIGHT                  = "HelveticaNeue-Light"
    
   

    
    
}


struct INSTRUCTION {
    
    static let kINSTRUCTION_CLS_SCHOOL                = "classListIntruction"
}

enum AssetIdentifier: String
{
    case chart                  = "pie-chart"
    case Menu                   = "menu"
    case Radio                  = "fill_radio"
    case add                    = "add"
    case background             = "bg6"
    
}

struct Platform {
    static let isSimulator: Bool = {
        #if arch(i386) || arch(x86_64)
            return true
        #endif
        return false
    }()
}

