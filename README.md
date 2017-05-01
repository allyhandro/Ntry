Final Project - 'Ntry
=====
#### Members and Responsibilities
* Ally Han (awh264) - web application deployment / database integration
* Curtis Mann (cmm 893) - QR code integration
* Caroline Lai (cl2852) - iOS UXD

## DevNotes
Accesses to the database from the iOS application are done through HTTP requests through an API. The base request URL is

`https://ntry.herokuapp.com/api`

will follow this general naming scheme:
disclaimer: these routes will change as functionality increases for security reasons, this is the current naming scheme as of 5/1/17

| HTTP Method   | Route           | Description  |
| ------- |:----------------------------:| ---------------------------:|
| GET     | /items/_find                          | get all items               |
| GET     | /items/590687a0f5a5ee65/_findOne      | get one item for ObjectID   |
| PUT     | /items/590687a0f5a5ee65/_move         | update item for ObjectID    |


I suggest using this library to wrap the HTTP requests in swift 3:
https://github.com/Alamofire/Alamofire

#### Usage with Alamofire (probably)
Any GET request:
```
Alamofire.request('https://ntry/herokuapp.com/api/items/<item_id>/_find').responseData { response in
  if let JSON = response.result.value{
    print("JSON: \(JSON)")
  }
}
```

for PUT requests:
* header Content-Type must be set to application/x-www-form-urlencoded
* new location text should be sent over the request body with a tag of 'location':
```
// from https://github.com/Alamofire/Alamofire#http-methods //
let url = URL(string: "https://ntry/herokuapp.com/api/items/")!
var urlRequest = URLRequest(url: url)
urlRequest.httpMethod = "PUT"

let parameters = ["location": "new location"]

do {
    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
} catch {
    // No-op
}

urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

Alamofire.request(urlRequest)
```



## Project Description Overview
With the capabilities of smart phones increasing year by year, specialized hardware systems like barcode scanners are gradually phasing out of use. 'Ntry is an art handling storage logistics web application with an accompanying iOS application that automates the most tedious parts of inventory without using unitasker hardware.

'Ntry utilizes mobile QR code readers to simplify inventory and client interaction of Art Handling and Storage companies. Our application is based off of the real experiences of an Art Handler so that all functionality and interaction is specifically geared toward more efficient automation of Art Handling. Users of this application will benefit from increased automation for only the cost of a printer and a smartphone (assuming they don't already have one).

#### The Web
Through the web application, users can search for a specific client to retrieve their list of stored items and their estimated monthly storage fee (calculated from the square footage used by their respective art pieces stored). Users can also register a new client and search for pieces by name. When recieving new inventory items, the web app will generate a printable set of QR codes corresponding to the item information provided and the location of the item provided. These QR codes will be labeled with human readable titles and location names. Because there is no set schema for location names, the system can be flexibly molded to the user's storage naming scheme.

#### The App
This portion of the project will be completed in conjunction with the NYU iOS development course and will involve two other students. Essentially I am combining the two final projects for the iOS and AIT courses. The iOS App will facilitate easier access to client and item information via QR Scanner.

## Data Model
The application will store Users, Clients, Items, and Locations

An Example User:
```
{
    username: "joesArtShack",
    hash: // password hash
    clients: [Client]
}
```

An Example Client:
```
{
    name: "The Great and Famous Museum of Cultural Artifacts",
    phone: "212-332-5912",
    email: "youveHeardOfUs@famousMuseum.com"},
    rent: $2,000.00,
    items: [Item]
}
```

An Example Item:
```
{
    client: // reference to Client object,
    title: "Saturn Devouring His Son",
    description: "painting about Cronus painted in 1819",
    dimensions: 143 x 81 cm,
    type: "painting",
    status: "in",
    packing: "crate",
    artist: "Francisco Goya",
    image: // Bit image store through GridFS
    location: shelf 46-1-A,
    history: [
      {status: "in", date: "2/14/2017"},
      {status: "out", date: "6/15/2016"},
      {status: "in", date: "1/27/2016"}
    ]

}
```

An Example Location:
```
{
    id: 001 // numerically generated id to be stored in QR code
    name: "shelf 46-1-A"
    item: // reference to item currently stored default none
}
```

## Link to Commented First Draft Schema
[First Schema Draft](https://github.com/nyu-csci-ua-0480-008-spring-2017/awh264-final-project/blob/master/db.js)

## Wireframe Examples for iOS application
#### Tentative Main Screens
![Current](https://cloud.githubusercontent.com/assets/15023185/24872234/b3c62f42-1dea-11e7-985b-717a413d6e41.png)

## Wireframe Examples for Web Application
#### Index
![Index](https://cloud.githubusercontent.com/assets/15023185/24531691/b61d1e1e-1588-11e7-926b-1d33e87c8653.png)

#### New User
![new user](https://cloud.githubusercontent.com/assets/15023185/24531695/ba89b0d4-1588-11e7-9b15-8e98f92b72f1.png)

#### User Login
![user login](https://cloud.githubusercontent.com/assets/15023185/24531696/bbf8f7f4-1588-11e7-855a-7fa1a773379b.png)

#### User Inforamtion
![user information](https://cloud.githubusercontent.com/assets/15023185/24531706/cca5e396-1588-11e7-9be7-10b5551e9f85.png)

#### User Portal
![user portal](https://cloud.githubusercontent.com/assets/15023185/24574354/4446da8c-165f-11e7-88dd-db7537b6f5df.png)

#### Register Client
![register client](https://cloud.githubusercontent.com/assets/15023185/24574254/97f5b6c8-165d-11e7-8687-5d7dbe216166.png)

#### Register Item to Client
![register item to client](https://cloud.githubusercontent.com/assets/15023185/24574255/9d5b9b00-165d-11e7-9116-59becf96c229.png)

#### Register Location
![register new location](https://cloud.githubusercontent.com/assets/15023185/24531703/c6b444dc-1588-11e7-9c07-16118202f637.png)

#### Get Labels
![get labels](https://cloud.githubusercontent.com/assets/15023185/24531712/d3666e1c-1588-11e7-828e-bec5880e6ead.png)

#### Find Result: clients
![get clients](https://cloud.githubusercontent.com/assets/15023185/24574256/a0815c70-165d-11e7-87d8-63efa18472d9.png)

#### View Client Information
![view contact](https://cloud.githubusercontent.com/assets/15023185/24574258/a43fe07a-165d-11e7-9fc5-dd5dea63d401.png)

#### Inventory Manager
![manager](https://cloud.githubusercontent.com/assets/15023185/24531701/c335cfc4-1588-11e7-86cb-571d50f70466.png)



## Site Map
![site map](https://cloud.githubusercontent.com/assets/15023185/24574344/346f7e48-165f-11e7-92e6-6d7859d912cf.jpg)

## User Stories for Web Application Portion

1. as a non-registered user, I can register a new account with the site
2. as a user I can login, logout, and retrieve my password if I forgot it
3. as a user I can register a new client account
  * when I register a new client I can bulk register the items the client will be giving us
  * after all items are registered I can print out item QR code labels
  * if I am storing the items in a storage position that has already been labeled, I will get a print out with only item QR codes with human readable titles
  * if I am storing the items in a new storage position, I will get a print out with item AND location QR codes that are labeled with human readable titles / location names
4. as a user I can view client information
  * I will recieve client contact and rent information as well as a list of their items.
  * From the list of items provided I can edit the state of the item.
5. as a user I can search for specific art pieces by name accross all clients
  * resulting items from this search can be edited to update the state of the item
6. as a user I can bulk register new locations when I get a new shelf in my warehouse and get QR codes to label each available position.


## User Stories for iOS Portion
1. as a user, I can scan an item's QR code to get the item's description, including the location
2. as a user, I can scan a location to get the item that should be stored there
3. as a user, I can place an item in a location and record where it is by scanning the item, then scanning the new location


## Research Topics (10 points)
* (2 points) CSS preprocesser Sass
  * Sass is the "most mature, stable, and powerful professional grade CSS extension language in the world". My current goal is to become a Full Stack Web Developer, and as I have run into this library in passing in interviews, I'm curious to see how it works.
* (5 points) User authentication and password retrieval
  * Passport - authentication middleware for Node.js
  * upon first look, it looks relatively easy to use and is well documented
  * I will need to look up javascript --> email for password retrieval
* (5 points) QR Code generator / iOS integration
  * QRCode.js - a javascript library for making QR codes.
  * seems to be a pretty simple library for creating QR codes
  * compatible in most browsers
  * more thought needs to go into what the actual content will be, but basic functionality is all handled in QRCode.js


## Application Features to be implemented
* user authentication
* QR reader support
* iOS <--> web application communication
* iOS --> db automated communication
* item search
* register items
* register location
* register client
* generate QR codes
* print QR codes

## Potential Future Features
* categorical sorting of items (ex. sort by Artist / Type / Packing)
* AirPrint iOS support to print from mobile
* add batch of items from csv format
* new user tutorial view for iOS and web application
* user type and permissions - ie manager versus employee

- change 'process page' to 'learn more'


## References Used
* https://davidshimjs.github.io/qrcodejs/
  * qr code generating library
* http://sass-lang.com/
  * css preprocessor used to style site
* http://www.iosinsight.com/backend-rest-api-nodejs/
  * used to connect mobile app to database via REST api



