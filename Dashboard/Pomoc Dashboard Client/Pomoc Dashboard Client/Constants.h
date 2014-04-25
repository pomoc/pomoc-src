//
//  constants.h
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 25/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

//LOGIN VIEW CONTROLLER
#define TEXT_FIELD_BORDER_WIDTH 2.0f
#define FIELDS_NOT_FILLED @"Sorry, please ensure that both fields are fillled in"
#define WRONG_LOGIN @"Sorry, wrong login credentials"
#define NO_INTERNET @"Sorry, but you have no internet connect currently"
#define LOGIN_KEYBOARD_UP_OFF_SET 200.0f
#define LOGIN_KEYBOARD_UP_TIME 0.2f

//SETTING VIEW CONTROLLER
#define SWITCH_CORNER_RADIUS 16.0

//HOME VIEW CONTROLLER
#define HOME_NAV_TITLE @"Home"
#define LINE_CHAT_WIDTH @"4.0"
#define LINE_COLOR [UIColor greenColor]
#define DATA_POINTS 25
#define CHART_WIDTH 450
#define CHART_HEIGHT 350

//CHART VIEW CONTROLLER
#define CHART_NAV_TITLE @"Charts"
#define CHART_REUSE_CELL @"chartlets"
#define CHART_ARRAY @"Agents"
#define NO_OF_CELL @"10"

//CHART OTHER COMPONENETS
#define CHART_DOT_RADIUS 9.0
#define LENGTH_SMALL 0.15
#define LENGTH_BIG 0.25

//GROUPCHAT VIEW CONTROLLER
#define GROUP_CHAT_BORDER_WIDTH 0.5
#define GROUP_CHAT_NAV_TITLE @"Group Chat"
#define AGENT_ONLINE_TABLE_TITLE @"Agents Online"
#define AGENT_MESSAGE_REUSABLE_CELL @"cell"
#define AGENT_LIST_FONT_STYLE @"Marker Felt"
#define AGENT_LIST_FONT_SIZE 17
#define AGENT_LIST_THUMBNAIL @"worker-512.png"
#define AGENT_LIST_THUMBNAIL_SIZE 25
#define GROUP_CHAT_TABLEVIEW 1
#define AGENT_LIST_TABLEVIEW 2

//ANNOTATE VIEW CONTROLLER
#define NUM_COLORS 20
#define BUTTON_SIZE 51
#define BUTTON_SIDE_OFFSET 0
#define DONE_BUTTON_TITLE @"Done"

//ANNOTATION PALETTE
#define PALETTE_ALPHA 0.40f
#define PALETTE_BORDER_WIDTH 0.0f
#define PALETTE_BORDER_WIDTH_TAPPED 2.0f
#define PALETTE_TAPPED_ALPHA 1

//ANNOTATION VIEW
#define CAPACITY 100
#define FF 0.2
#define LOWER 0.01
#define UPPER 1.0

//CHAT VIEW CONTROLLER
#define CHAT_NAV_TITLE @"Messages"
#define CHAT_CELL_NAME 1
#define CHAT_LIST_TABLEVIEW 1
#define CHAT_MESSAGE_TABLEVIEW 2
#define CHAT_MESSAGE_CELL_NAME 1
#define CHAT_MESSAGE_TEXT 2
#define CHAT_MESSAGE_PICTURE 2
#define CHAT_MESSAGE_DATE 3
#define UNHANDLED_CHAT 0
#define HANDLING_CHAT 1
#define OTHER_CHAT 2
#define KEYBOARD_UP_OFFSET 350
#define CHAT_NAV_ORIGINAL_FRAME 280
#define HANDLE_CHAT_BTN @"Handle"
#define UNHANDLE_CHAT_BTN @"Unhandle"

#define CHAT_NAV_FONT @"Avenir"
#define CHAT_NAV_FONT_SIZE 14
#define UNHANDLE_CHAT_SECTION @"Unhandled chats"
#define HANDLING_CHAT_SECTION @"Chats you are handling"
#define HANDLING_CHAT_SECTION_COLOR @"#42C9B3"
#define OTHER_CHAT_SECTION @"Other chats"
#define OTHER_CHAT_SECTION_COLOR @"#42C9B3"
#define SECTION_HEIGHT 20
#define SECTION_CONTENT_HIGHT 65

#define CHAT_MESSAGE_PICTURE_HEIGHT 170
#define CHAT_MESSAGE_TEXT_FONT @"Avenir"
#define CHAT_MESSAGE_TEXT_FONT_SIZE 15
#define CHAT_TITLE_REUSE_CELL @"ChatTitleCell"
#define CHAT_MESSAGE_UNREAD_COLOR @"#D3E4F0"
#define CHAT_PICTURE_REUSE_CELL @"ChatPictureCell"
#define CHAT_MESSAGE_REUSE_CELL @"ChatMessageCell"
#define CHAT_STATUS_REUSE_CELL @"StatusMessageCell"

#define INVITED_TITLE @"Chat Referred"
#define INVITED_CONTENT @"You've been referred to a new chat conversation!"

//UPLOAD VIEW CONTROLLER
#define UPLOAD_ACTION_SHEET_TITLE @"Upload image from?"
#define UPLOAD_ACTION_SHEET_CAM @"Camera"
#define UPLOAD_ACTION_SHEET_PICT @"Photos Lirary"
#define UPLOAD_CANCEL @"Cancel"

//REFERTABLE VIEW CONTROLLER
#define REFER_REUSE_CELL @"cell"
#define MESSAGE_WHEN_NO_AGENT @"No available agents to invite"

//NOTES VIEW CONTROLLER
#define NOTE_REUSE_CELL @"cell"

//CHAT + PAST VIEW CONTROLLER
#define CHAT_CELL_STARTED 2
#define CHAT_CELL_AGENT_NO 3

//PM Constant
#define USER_USERID                 @"userId"
#define USER_NAME                   @"name"
#define USER_TYPE                   @"type"

#define USER_TYPE_AGENT             @"agent"
#define USER_TYPE_PUBLIC            @"public"