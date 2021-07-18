# covid-vac-influx
Flutter Application to query a public available API from the Portuguese Government for covid vaccination center queues in Portugal.

This application is composed by three pages:

* A list of counties that can be filtered;
* A list of vaccination centers of a given county;
* A page with all the relevant vaccination center information and queue times;

# List of Counties

The list of Counties is fed by a local json asset called counties.json.
A listView is then constructed with a ListTile for each county in the 
json file. 

![list of counties](https://imgur.com/xmvmTLf.png)

Below is a TextField that upon being changed, it rebuilds the state,
reconstructing the ListView with all the matching counties.

![searchable counties](https://imgur.com/Ny2BFy5.png)

Clicking a county will call the Navigator to display the next page - 
the list of vaccination centers of that county.



# List of vaccination centers

This listView is fed by a remote API from the Portuguese Government that gives
us data in json format. 
The ListTile displays a trafficlight indicating the respective queue times.
Upon clicking, navigator displays the center information page for the center 
of the tile tapped.

![list of vaccination centers](https://imgur.com/rjJExaG.png)

# Center information page

This page displays all the relevant information for the selected center. 
Name, map, respective address, GPS coordinates and a link to open on an 
available browser for directions from your location to the center selected.

![Vaccination Center information page](https://imgur.com/MhpiWnz.png)

# Packages Used 
  cupertino_icons: ^1.0.2
  http: ^0.13.3
  logger: ^1.0.0
  flutter_map: ^0.13.1
  flutter_html: ^2.1.0
  url_launcher: ^6.0.9
  geolocator: ^7.3.0

