![Alt](/AdventureCalls_assets/AdventureCalls_60.png) 
#  AdventureCalls
AdventureCalls is an iOS travel companion apps for exploring the National Parks.  
# API Used
- The app lists the offical national parks data and content using the [National Park Service (NPS) API](https://www.nps.gov/subjects/developer/api-documentation.htm) .
# Features
## Parks Map View
### Parks Map Tab ( Home Tab )
The park map tab, when the user opens the app, displays a map view for the park watchlists.
<img src="/AdventureCalls_assets/ParkInfoPostingV_DoneSave.png" height="497" width="280" border="1">

#### Navigation:
- Taps an red park pin to see the park name.  Tap the park name callout to launch the **Places Collection View**.
- Taps the ![Alt](/AdventureCalls_assets/icon_addpin.png) on top navigation bar to add parks to watchlist.  The Add button launches the **Search Park View**
- Taps ![Alt](/AdventureCalls_assets/icon_listview-deselected.png) on bottom tab bar to switch to **Parks List View**

<img src="/AdventureCalls_assets/ParkMapV_Callout.png" height="497" width="280" border="1"> <img src="/AdventureCalls_assets/PlaceCollectionView.png" height="533" width="300" border="1">

## Parks List View
### Parks List Tab
The park list tab displays a table view for the park watchlists.   The list inclues park name, state and park code.

<img src="/AdventureCalls_assets/ParkListView.png" height="497" width="280" border="1">

#### Navigation:
- Selects a park row to launch the **Place Collection View**.
- Selects the ![Alt](/AdventureCalls_assets/icon_addpin.png) on top navigation bar to add parks to watchlist.  This launches the **Search Park View**
- Taps ![Alt](/AdventureCalls_assets/icon_mapview-deselected.png) on bottom tab bar to switch to **Parks Map View**
## Search Parks View
### Search Parks by park code, state code or keyword
User enters park code, state code or keyword to search for parks to add to watchlist.  If parks are found, the app launches the **Park Info Posting View**.  Otherwise, user will see an error message for parks not found or other connection errors.

<img src="/AdventureCalls_assets/SearchParkV_NotFound.png" height="497" width="280" border="1">

### Park Info Posting View
This view displays a map view of the search results.  User taps the purple park pin to see the park name.  Tap the ![Alt](/AdventureCalls_assets/icon_trash.png) in the pin callout to remove a park from posting to the watchlist.

<img src="/AdventureCalls_assets/SearchParkView.png" height="497" width="280" border="1"> <img src="/AdventureCalls_assets/ParkInfoPostingView.png" height="497" width="280" border="1"> <img src="/AdventureCalls_assets/ParkInfoPostingV_Callout.png" height="497" width="280" border="1">

#### Navigation:
- Taps **Save** on top navigation bar to add the parks to core data store, and takes user back to **Home Tab**
- Taps **Cancel** on top navigation bar to go back to previous screen

<img src="/AdventureCalls_assets/ParkInfoPostingV_Save.png" height="497" width="280" border="1"> <img src="/AdventureCalls_assets/ParkInfoPostingV_DoneSave.png" height="497" width="280" border="1"> 

## Places Collection View
### NPS Park Details
From Parks Map or Parks List, user selects a park to see the NPS Park Details.
#### The details listed for a park:
- a zoom in map view
- park description (user taps to expand or collapse the description)
- a collection of official NPS photos

<img src="/AdventureCalls_assets/ParkListV_SelectRow.png" height="497" width="280" border="1"> <img src="/AdventureCalls_assets/PlaceCollectionView.png" height="497" width="280" border="1"> <img src="/AdventureCalls_assets/PlaceCollectionV_Callout_Expand.png" height="497" width="280" border="1"> 

#### Navigation:
- Tap ![Alt](/AdventureCalls_assets/icon_home.png) on bottom tool bar to go back to **Home Tab**
- Tap ![Alt](/AdventureCalls_assets/icon_plane.png) on bottom tool bar to launch the **Visit List View**
- Tap ![Alt](/AdventureCalls_assets/icon_info.png) on bottom tool bar to launch the NPS web site on Safari for the selected park

<img src="/AdventureCalls_assets/PlaceCollectionV_Info.png" height="497" width="280" border="1">

## Visit List View
From Places Collection View, user taps ![Alt](/AdventureCalls_assets/icon_plane.png) on bottom tool bar to see the table view of visit list associated with the selected park.
#### The details listed for a visit:
- Travel date
- Visit title
- User's rating for the visit
#### Navigation:
- Selects a Visit row to launch the **Diary List View**
- Tap ![Alt](/AdventureCalls_assets/icon_addpin.png) on navigation bar to add a visit for the selected park.  This launches the **Visit Info Posting View** 
- Tap ![Alt](/AdventureCalls_assets/icon_home.png) on bottom tool bar to go back to **Home Tab**

<img src="/AdventureCalls_assets/VisitListV_SelectRow.png" height="533" width="300" border="1"> <img src="/AdventureCalls_assets/DiaryListView.png" height="533" width="300" border="1"> 

## Visit Info Posting View
#### User enters the following details for a visit:
- Visit title
- Travel date with a date picker
- Rate the visit 
#### Navigation:
- Taps **ADD VISIT** button to add the visit details to core data store.  This takes the user back to **Visit List View**
- Taps **Cancel** on top navigation bar to cancel the Add and go back to **Visit List View**

<img src="/AdventureCalls_assets/VisitInfoPostingV_DatePicker.png" height="497" width="280" border="1"> <img src="/AdventureCalls_assets/VisitInfoPostingView.png" height="497" width="280" border="1"> <img src="/AdventureCalls_assets/VisitListView.png" height="497" width="280" border="1"> 

## Diary List View
From **Visit List View**, user selects a visit row to see a list of diary titles.
User taps ![Alt](/AdventureCalls_assets/icon_addpin.png) on top navigation bar to **Add Diary**
User taps **Edit** on top navigation bar to switch the diary list into **Diary List Edit mode**
#### Diary List Edit mode
- Select a diary title and taps **Delete** to delete the diary
- Tap Done to exit the Edit mode

<img src="/AdventureCalls_assets/DiaryListV_Edit.png" height="497" width="280" border="1"> <img src="/AdventureCalls_assets/DiaryListV_Delete.png" height="497" width="280" border="1"> <img src="/AdventureCalls_assets/DiaryListV_DeleteDone.png" height="497" width="280" border="1"> 

<img src="/AdventureCalls_assets/DiaryListView.png" height="497" width="280" border="1">

#### Add Diary
- Enters a title in the popup alert box, 
- Tap **Save** to add the diary to core data store and back to the diary list
- Tap **Cancel** to cancel the Add and go back to the diary list

<img src="/AdventureCalls_assets/DiaryListV_Title.png" height="497" width="280" border="1"> <img src="/AdventureCalls_assets/DiaryListView.png" height="497" width="280" border="1"> 

#### Navigation:
- Selects a diary title row to edit diary details.  This takes the user to **Diary Detail View**
- Tap ![Alt](/AdventureCalls_assets/icon_home.png) on bottom tool bar to go back to **Home Tab**
- Tap ![Alt](/AdventureCalls_assets/icon_camera.png) on bottom tool bar to go to **Photo Album View**

<img src="/AdventureCalls_assets/DiaryListV_SelectRow.png" height="497" width="280" border="1"> <img src="/AdventureCalls_assets/DiaryDetailView.png" height="497" width="280" border="1">

## Photo Album View
From **Diary List View**, user taps ![Alt](/AdventureCalls_assets/icon_camera.png) on bottom tool bar to see the collection view of photos associated with the selected visit  
User taps photos in the collection view to toggle the photos for deletion.  Taps ![Alt](/AdventureCalls_assets/icon_trash.png) on the top navigation bar to remove the selected photos from core data store
User taps ![Alt](/AdventureCalls_assets/icon_addpin.png) on the top navigation bar to add photos in **Photo Posting View**
#### Navigation:
- Tap ![Alt](/AdventureCalls_assets/icon_home.png) on bottom tool bar to go back to **Home Tab**
- Tap ![Alt](/AdventureCalls_assets/icon_diaryview-deselected.png) button to go to **Diary List View**
## Photo Posting View
From **Photo Album View**, user taps ![Alt](/AdventureCalls_assets/icon_addpin.png) on the top navigation bar to add a photo using Image Picker.
User taps ![Alt](/AdventureCalls_assets/icon_camera.png) on bottom tool bar to take photo with the built-in camera.
User taps ![Alt](/AdventureCalls_assets/icon_images.png) on bottom tool bar to select photo from Photos.
User may enter a title for the selected photo:
- Taps **Save** on top navigation bar to add photo to core data store, and back to the **Photo Album View**
- Taps ![Alt](/AdventureCalls_assets/icon_share.png) on the top navigation bar to share photo
- Taps **Cancel** to go back to **Photo Album View**

<img src="/AdventureCalls_assets/PhotoPostingView.png" height="497" width="280" border="1"> <img src="/AdventureCalls_assets/PhotoPostingV_ImagePicker_Camera.png" height="497" width="280" border="1"> <img src="/AdventureCalls_assets/PhotoPostingV_Share.png" height="497" width="280" border="1"> 

<img src="/AdventureCalls_assets/PhotoPostingV_ImageTitle.png" height="497" width="280" border="1"> <img src="/AdventureCalls_assets/PhotoPostingV_Image.png" height="497" width="280" border="1"> <img src="/AdventureCalls_assets/PhotoPostingV_ImageTitle.png" height="497" width="280" border="1"> 

<img src="/AdventureCalls_assets/PhotoPostingV_Image.png" height="497" width="280" border="1"> <img src="/AdventureCalls_assets/PhotoAlbumView.png" height="497" width="280" border="1"> 

# Compatibility
- Xcode 9.31
- Swift 4.1
# Build and Run Project
- Download or clone the gitHub repository `https://github.com/shirleykc/course-AdventureCalls.git`
- Open **AdventureCalls.xcworkspace**











