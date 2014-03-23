# Dashboard Client

## External Projects used 
    Facebook navigation - https://github.com/gotosleep/JASidePanels

## Brief files details  

	LoginViewController - first access point for logging in 

    MainViewController - Creates all the required elements (using JASidePanel)
    
    SideNavigationViewController - (the side navigation) 

    HomeViewController - controller for home view

    ChatViewController - controller for chat view 

        ContactInfoViewController - controller for info about user in chat screen
        PastChatViewController - controller for info about past user

## For Chun Mun or the integrator 

    I've added a folder PomocSupport which includes:

    -FakePomocSupport.h -- includes delegate possibility that we need
    Delegates: 

        newChat: (PomocChat *)chat
        newChatMessage: (PomocChat *)chat
        chatListOnLoad: (NSArray *)chatlist <--- a list of Pomoc chat 

    -PomocChat.h - object that JSON serialization (its drafty, needa discuss on the property of it or maybe even more objects)
