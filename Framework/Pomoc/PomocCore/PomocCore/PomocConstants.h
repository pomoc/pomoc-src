//
//  PomocConstants.h
//  PomocCore
//
//  Created by soedar on 12/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#ifndef PomocCore_PomocConstants_h
#define PomocCore_PomocConstants_h

//#define LOCAL_SERVER

#ifdef LOCAL_SERVER
#define POMOC_URL   @"172.28.177.128"
#define POMOC_PORT  3217

#else
#define POMOC_URL   @"api.pomoc.im"
#define POMOC_PORT  3217
#endif

#endif
