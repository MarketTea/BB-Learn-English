import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

bool _light = true;
bool _theme = false;

class _SettingState extends State<Setting> {
  String _userAvatarUrl = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              margin: const EdgeInsets.all(8.0),
              color: Color(0xFF689EB8),
              child: ListTile(
                onTap: () {
                  // open edit profile
                },
                title: Text(
                  'Market Tea',
                  style: TextStyle(color: Colors.white),
                ),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://i.pinimg.com/564x/49/fb/60/49fb60486d4c91217404bbe54e0f3695.jpg"),
                ),
                trailing: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Card(
              margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 8.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.lock_outline,
                        color: Colors.deepPurpleAccent),
                    title: Text('Change PassWord'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {},
                  ),
                  _buildDivider(),
                  ListTile(
                    leading:
                    Icon(Icons.language, color: Colors.deepPurpleAccent),
                    title: Text('Change Language'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {},
                  ),
                  _buildDivider(),
                  ListTile(
                    leading: Icon(Icons.location_on_outlined,
                        color: Colors.deepPurpleAccent),
                    title: Text('Change Location'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {},
                  )
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Notification Setting',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF689EB8)),
            ),
            SwitchListTile(
                activeColor: Color(0xFF689EB8),
                contentPadding: const EdgeInsets.all(0),
                value: _light,
                title: Text(
                  'Received notification',
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400),
                ),
                onChanged: (state) {
                  setState(() {
                    setState(() {
                      _light = state;
                    });
                  });
                }),
            SwitchListTile(
                activeColor: Color(0xFF689EB8),
                contentPadding: const EdgeInsets.all(0),
                value: _light,
                title: Text('Transcript tracking',
                    style:
                    TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400)),
                onChanged: (state) {
                  setState(() {
                    setState(() {
                      _light = state;
                    });
                  });
                }),
            SwitchListTile(
                activeColor: Color(0xFF689EB8),
                contentPadding: const EdgeInsets.all(0),
                value: _light,
                title: Text('Received app updates',
                    style:
                    TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400)),
                onChanged: (state) {
                  setState(() {
                    setState(() {
                      _light = state;
                    });
                  });
                }),
            SwitchListTile(
                activeColor: Color(0xFF689EB8),
                contentPadding: const EdgeInsets.all(0),
                value: _theme,
                title: Text('Dark Theme',
                    style:
                    TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400)),
                onChanged: (state) {
                  setState(() {
                    setState(() {
                      _theme = state;
                    });
                  });
                })
          ],
        ),
      ),
    );
  }
}

Widget _buildDivider() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 8.0),
    width: double.infinity,
    height: 1.0,
    color: Colors.grey.shade400,
  );
}
