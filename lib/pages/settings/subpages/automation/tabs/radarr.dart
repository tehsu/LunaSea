import 'package:flutter/material.dart';
import 'package:lunasea/configuration/values.dart';
import 'package:lunasea/logic/automation/radarr.dart';
import 'package:lunasea/system/ui.dart';

class Radarr extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return _RadarrWidget();
    }
}

class _RadarrWidget extends StatefulWidget {
    @override
    State<StatefulWidget> createState() {
        return _RadarrState();
    }
}

class _RadarrState extends State<StatefulWidget> {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    List<dynamic> _radarrValues;

    @override
    void initState() {
        super.initState();
        _refreshData();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            key: _scaffoldKey,
            body: _radarrSettings(),
            floatingActionButton: _buildFloatingActionButton(),
        );
    }

    void _refreshData() {
        setState(() {
            _radarrValues = List.from(Values.radarrValues);
        });
    }

    Widget _buildFloatingActionButton() {
        return FloatingActionButton(
            heroTag: null,
            tooltip: 'Test & Save',
            child: Elements.getIcon(Icons.save),
            onPressed: () async {
                if(await RadarrAPI.testConnection(_radarrValues)) {
                    await Values.setRadarr(_radarrValues);
                    _refreshData();
                    Notifications.showSnackBar(_scaffoldKey, 'Settings saved');
                } else {
                    Notifications.showSnackBar(_scaffoldKey, 'Connection test failed: Settings not saved');
                }
            },
        );
    }

    Widget _radarrSettings() {
        return Scrollbar(
            child: ListView(
                children: <Widget>[
                    Card(
                        child: ListTile(
                            title: Elements.getTitle('Enable Radarr'),
                            trailing: Switch(
                                value: _radarrValues[0],
                                onChanged: (value) {
                                    setState(() {
                                        _radarrValues[0] = value;
                                    });
                                },
                            ),
                        ),
                        margin: Elements.getCardMargin(),
                        elevation: 4.0,
                    ),
                    Card(
                        child: ListTile(
                            title: Elements.getTitle('Host'),
                            subtitle: Elements.getSubtitle(_radarrValues[1] == '' ? 'Not Set' : _radarrValues[1], preventOverflow: true),
                            trailing: IconButton(
                                icon: Elements.getIcon(Icons.arrow_forward_ios),
                                onPressed: null,
                            ),
                            onTap: () async {
                                List<dynamic> _values = await SystemDialogs.showEditTextPrompt(context, 'Radarr Host', prefill: _radarrValues[1]);
                                if(_values[0]) {
                                    setState(() {
                                        _radarrValues[1] = _values[1];
                                    });
                                }
                            }
                        ),
                        margin: Elements.getCardMargin(),
                        elevation: 4.0,
                    ),
                    Card(
                        child: ListTile(
                            title: Elements.getTitle('API Key'),
                            subtitle: Elements.getSubtitle(_radarrValues[2] == '' ? 'Not Set' : _radarrValues[2], preventOverflow: true),
                            trailing: IconButton(
                                icon: Elements.getIcon(Icons.arrow_forward_ios),
                                onPressed: null,
                            ),
                            onTap: () async {
                                List<dynamic> _values = await SystemDialogs.showEditTextPrompt(context, 'Radarr API Key', prefill: _radarrValues[2]);
                                if(_values[0]) {
                                    setState(() {
                                        _radarrValues[2] = _values[1];
                                    });
                                }
                            }
                        ),
                        margin: Elements.getCardMargin(),
                        elevation: 4.0,
                    ),
                ],
                padding: Elements.getListViewPadding(),
            ),
        );
    }
}
