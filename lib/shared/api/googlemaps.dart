import 'package:flutter_dotenv/flutter_dotenv.dart';

// Google Map API Key
String placeKey = dotenv.env['GOOGLEMAPKEY'] as String;

String googleMapKey = dotenv.env['GOOGLEMAPPLACEKEY'] as String;
// Google Maps API
const googleMapsUrl = 'maps.googleapis.com';

const googlePlaceIdApi =
    'https://maps.googleapis.com/maps/api/place/findplacefromtext/json';
const googlePlaceApi =
    'https://maps.googleapis.com/maps/api/place/details/json';
const googlePlaceAutoCompleteApi = '/maps/api/place/autocomplete/json';

const datapoints =
    'https://devmap.zen.com.my/wp-json/mobile_app/googlemaps/datapoints';
