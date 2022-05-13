# CASA0015-Mine-AndroidAPP
Android APP to track family and exchange urgent communication

## Background
Family members want to be in close contact throughout the day especially when they stay in different corners of the world.
In spite of there being multiple apps for chatting or sharing one's day to day activities, it is not targeted for a single family.
It is often difficult to extract action items from a casual chat and important notes often get missed among the constant notifications of forwarded messages and casual chats.
There are so many platforms to leave messages for a family members which makes it even more easy to miss important messages.

The APP identifies and supports two of the most common reasons for contacting a family member.
Where are you?
Remember to do this!

### Storyboard
![image](https://user-images.githubusercontent.com/91799774/167427055-541701b8-6360-48ee-b71c-d1c1a0805537.png)

## Outline
The proposed app has the following features:
1. Maintains a list of the family members.
2. Remembers login information for each user.
3. Consists of 2 sections: Trackers and To-do list
4. The tracker section remembers and displays the last known location of all family member in a quick glance. When a user enters the tracker page, their current location is updated.
5. The To-do list maintains a list to do items logged by family members consisting of the intended participant, date of logging and message. Once to-do list item is completed, the same can be deleted from the list with a single tap.

## Wireframe
![image](https://user-images.githubusercontent.com/91799774/167428711-aeb675af-e17e-4749-9a3d-648a04e2fa0e.png)

## Design
![image](https://user-images.githubusercontent.com/91799774/167440009-32975829-d12b-4889-8aa2-150e19c5a012.png)

## Screenshots
Login workflow:

![image](https://user-images.githubusercontent.com/91799774/167434793-2b982b79-f1fc-4005-859a-047b3181f994.png)

Tracker workflow:

![image](https://user-images.githubusercontent.com/91799774/167436423-dccfe41f-af67-4eef-9359-f9c7d0b3a83d.png)


Notes workflow:


![image](https://user-images.githubusercontent.com/91799774/167446067-6aec374d-c576-42a7-82f4-8a29e18ea656.png)


## Challenges and Future improvement
1. The login module remembers the login state through local storage. But the module is incomplete and allows login irrespective of the password or username. 
 By integrating Firebase utility, the app can actually support multiple users.
2. Due to shortage of time, the app does not support the 'Add family' functionality yet. In future, a separate workflow needs to be added to Add new family/Add new member to your family.
3. Due to the process of testing from a single phone, the location of all family members is shown as the same location. To test separate locations, I used the login functionality to login as multiple users at different locations. After firebase is integrated, it will be possible to record locations for multiple users.
4. To demonstrate the utility of tracker application, two dummy ids[John and Tina] are provided in code if the person list is empty. This is just for demo.
5. Images cutouts have been used to show different profiles on trackers and note page. In future, user would be able to customise the marker with their own picture.
6. It is important to think about the ethical implications of sharing someone's location even though they are a family member and android app asks for location permissions. In future, the app could be enhanced with more options to stop and start sharing based on user's choice to make the app more secure.

## References and links:
1. https://codesource.io/build-a-simple-login-page-and-dashboard-with-flutter/
		
2. https://instaflutter.com/flutter-tutorials/persistent-storage-flutter/#:~:text=The%20management%20and%20handling%20of%20such%20a%20state,was%20before%20the%20application%20has%20been%20shut%20off.
			
3. https://github.com/heremaps/here-sdk-examples/tree/master/examples/latest/explore/flutter/hello_map_app
		
4. https://github.com/flutter/samples/tree/master/place_tracker
		
5. https://betterprogramming.pub/flutter-how-to-save-objects-in-sharedpreferences-b7880d0ee2e4
		
6. https://stackoverflow.com/questions/41436639/does-shared-preferences-get-shared-across-user


## Build instructions
1. Download the android project from the below github link
    https://github.com/AbhipsaKar/CASA0015-Mine-AndroidAPP
2. Rename project to mine_project.
3. Set your HERE SDK credentials to
    https://github.com/AbhipsaKar/CASA0015-Mine-AndroidAPP/blob/main/MineProject/android/app/src/main/AndroidManifest.xml
4. Unzip the HERE SDK plugin for flutter and copy inside plugins folder in your project. Name the folder 'here_sdk': mine_project/plugins/here_sdk.
5. Install the below dependencies for this project:
    shared_preferences: ^2.0.5
    provider: ^6.0.2
    geolocator: ^8.2.0
6. Start an emulator or simulator and execute flutter run from the app's directory - or run the app from within your IDE.
