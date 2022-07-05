import 'package:flutter/material.dart';
import 'package:kliniku/const.dart';
import 'package:flutter_map/flutter_map.dart';
import "package:latlong2/latlong.dart";
import 'package:url_launcher/url_launcher_string.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

const latitude = -6.977216779839612;
const longitude = 107.63043522061591;

Column listModalButtonSheet() {
  return Column(
    children: [
      SizedBox(height: 20),
      ListTile(
        leading: Icon(Icons.map_rounded),
        title: Text("Bandung"),
        subtitle: Text("Jl. Telekomunikasi No.1, Citeureup, Kec. Dayeuhkolot"),
      ),
      ListTile(
        leading: Icon(Icons.call_rounded),
        title: Text("+021-8989898"),
        onTap: () => launchUrlString("tel:+021-8989898"),
      ),
      ListTile(
        leading: Icon(Icons.email_rounded),
        title: Text("kliniku@gmail.com"),
        onTap: () => launchUrlString("https://gmail.com"),
        // launchUrlString("mailto:kliniku@gmail.com?subject=HelloKliniku"),
      ),
    ],
  );
}

class _LocationPageState extends State<LocationPage> {
  @override
  Widget build(BuildContext context) {
    void _onButonPress() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: MediaQuery.of(context).size.height * 0.3,
            child: Container(
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: listModalButtonSheet(),
            ),
          );
        },
      );
    }

    return FlutterMap(
      options: MapOptions(
        center: LatLng(latitude, longitude),
        zoom: 16,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate:
              "https://api.mapbox.com/styles/v1/anantand/cl4dkq6jz000315s2r98vukpl/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYW5hbnRhbmQiLCJhIjoiY2w0N3c5cXVyMGJ5dTNkcDhqOWJoeHR5ciJ9.WgGznLo-f-ISwe9lFVsoWg",
          additionalOptions: {
            'accessToken':
                'pk.eyJ1IjoiYW5hbnRhbmQiLCJhIjoiY2w0N3c5cXVyMGJ5dTNkcDhqOWJoeHR5ciJ9.WgGznLo-f-ISwe9lFVsoWg',
            'id': 'mapbox.country-boundaries-v1'
          },
        ),
        MarkerLayerOptions(
          markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(latitude, longitude), //mark klinik telkom
              builder: (ctx) => Container(
                child: IconButton(
                  icon: Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                  onPressed: () => _onButonPress(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
