# Quinbay
The Quinbay is a sample application. The project covers dynamic tableview cell height, MVVM and clean Architecture and Prefetching Table Data From server or infinite scroll view.

* [Things to learn](#things-to-learn)
* [Technologies](#technologies)
* [Application GIF](#application-gif)


## Things to learn
* [MVVM and Clean Architecture](#mvvm-and-clean-architecture)
* [Dynamic cell height](#dynamic-cell-height)
* [JSON Decoder with Models](#json-decoder)
* [Prefetch table data from server](#prefetch-data)
* [Infinite scrollview](#infinte-scrollview)
* [Canceling Previous Search Call when new call added in Queue.](#canceling-previous-search)

### MVVM and Clean Architecture

The project's architecture uses MVVM architecture. Here "ViewController" is responsible for updating the API and passing the user touch request to View models.
![Screenshot 2022-01-11 at 12 01 41 PM](https://user-images.githubusercontent.com/16226329/148893474-7bf883df-9a2b-4d93-bcfd-3bb9e082ddbd.png)

The view model is initiated with SearchAPIHandler Protocol. Here SOLID Principle's Open Close principle is used. Any class can make SearchAPI Handler provided some protocol rules.

![Screenshot 2022-01-11 at 12 08 22 PM](https://user-images.githubusercontent.com/16226329/148893508-c3ede005-b2d7-4579-b68d-db85d1e145cd.png)
![Screenshot 2022-01-11 at 12 10 04 PM](https://user-images.githubusercontent.com/16226329/148893715-3bb47823-35f2-4079-a601-4a9ca42d610e.png)


### Dynamic cell height

The tableview cell uses dynamic cell height. The technique to use dynamic cell height is to add constrains from top to bottom and make the table view height dynamic. Other important things is to give don't give height to labels as it can expand and make its number of lines 0 or custom as per requirement.

![Screenshot 2022-01-11 at 12 02 04 PM](https://user-images.githubusercontent.com/16226329/148893884-2a8ddbbb-15ab-449a-96dc-9951e801667c.png)

### JSON Decoder with Models

JSON received from server is mapped to model classes using Codable Protocol and JSONDecoder class.

![Screenshot 2022-01-11 at 12 02 28 PM](https://user-images.githubusercontent.com/16226329/148893923-39bd8ea1-acb9-45a0-8956-245c893f8c73.png)

### Prefetch table data from server

When user reaches the bottom of the page, in "prefetchRowsAt" function, we inform view model to fetch more products with "page" incremented.

![Screenshot 2022-01-11 at 12 13 13 PM](https://user-images.githubusercontent.com/16226329/148894032-49a08b95-6145-4235-ac6a-1f8691ed3389.png)
![Screenshot 2022-01-11 at 12 14 24 PM](https://user-images.githubusercontent.com/16226329/148894184-b7201e1d-3e9d-426d-9b46-509b179e7097.png)

### Infinite scrollview

See the attached GIF. As soon as user reaches bottom of the page, view model fetches data and append to current product list and show.

### Canceling Previous Search Call when new call added in Queue.

In the current session, all the tasks are fetched and mached to given search string. If matches and the next request occured, the last all tasks are cancelled.

![Screenshot 2022-01-11 at 12 15 23 PM](https://user-images.githubusercontent.com/16226329/148894297-cbc90dc0-845f-445e-842f-f27dd6f2ab05.png)

When task is cancelled, callback is received with -999 error code. Here return and don't do anything.

![Screenshot 2022-01-11 at 12 16 26 PM](https://user-images.githubusercontent.com/16226329/148894416-08fcc28c-35b1-4112-a2ec-012278048ae9.png)

    
## Technologies
Project is created with:
* Xcode : 13.1
* IOS version: 15

## Application GIF
![ezgif com-gif-maker](https://user-images.githubusercontent.com/16226329/148892640-9266b91b-c226-46e5-91f2-ab0a3d4767b6.gif)
