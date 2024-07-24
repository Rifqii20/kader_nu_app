// lib/pages/aset_page.dart
import 'package:flutter/material.dart';
import 'package:kader_nu/pages/aset/aset_form_page.dart';
import 'package:kader_nu/providers/aset_provider.dart';
import 'package:kader_nu/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import 'aset_detail_page.dart';

class AsetPage extends StatefulWidget {
  @override
  _AsetPageState createState() => _AsetPageState();
}

class _AsetPageState extends State<AsetPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<AsetProvider>(context, listen: false).fetchAset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aset List'),
      ),
      drawer: AppDrawer(),
      body: Consumer<AsetProvider>(
        builder: (context, asetProvider, child) {
          return ListView.builder(
            itemCount: asetProvider.aset.length,
            itemBuilder: (context, index) {
              final aset = asetProvider.aset[index];
              return ListTile(
                title: Text(aset.nama),
                subtitle: Text(aset.lokasi),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AsetDetailPage(aset: aset),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AsetFormPage(),
          ),
        ),
        child: Icon(Icons.add),
      )
    );
  }
}
